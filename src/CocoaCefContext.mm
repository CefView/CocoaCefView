//
//  CocoaCefContext.mm
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <CocoaCefView/CocoaCefContext.h>
#import <CocoaCefView/CocoaCefConfig.h>

#import <Cocoa/Cocoa.h>
#import <crt_externs.h>
#import <objc/runtime.h>

#pragma region cef_headers
#include <include/cef_application_mac.h>
#include <include/cef_sandbox_mac.h>
#include <include/wrapper/cef_library_loader.h>
#pragma endregion cef_headers

#include <CefViewBrowserApp.h>
#include <CefViewBrowserClient.h>

#include "CocoaCefAppDelegate.h"

#import "CocoaCefConfig+Internal.h"

#define CEF_BINARY_NAME "Chromium Embedded Framework"
#define CEF_FRAMEWORK_NAME "Chromium Embedded Framework.framework"
#define HELPER_BUNDLE_NAME "CefViewWing.app"
#define HELPER_BINARY_NAME "CefViewWing"

@interface PathFactory : NSObject
+ (NSString*) AppMainBundlePath;
+ (NSString*) CefFrameworkPath;
+ (NSString*) CefSubprocessPath;
@end

@implementation PathFactory
+ (NSString*) AppMainBundlePath {
  return [[NSBundle mainBundle] bundlePath];
}

+ (NSString*) CefFrameworkPath {
  NSString* path = [[NSBundle bundleForClass:[PathFactory class]] resourcePath];
  path = [path stringByAppendingPathComponent:@CEF_FRAMEWORK_NAME];
  return path;
}

+ (NSString*) CefSubprocessPath {
  NSString* path = [[NSBundle bundleForClass:[PathFactory class]] resourcePath];
  path = [path stringByAppendingPathComponent:@HELPER_BUNDLE_NAME];
  path = [path stringByAppendingPathComponent:@"Contents"];
  path = [path stringByAppendingPathComponent:@"MacOS"];
  path = [path stringByAppendingPathComponent:@HELPER_BINARY_NAME];
  return path;
}
@end

bool g_handling_send_event = false;

@interface NSApplication (CocoaCefApp) <CefAppProtocol>
- (void)_swizzled_sendEvent:(NSEvent *)event;
- (void)_swizzled_terminate:(id)sender;
- (void)_swizzled_run;
- (void)_swizzled_replyToApplicationShouldTerminate:(BOOL)shouldTerminate;
@end

@implementation NSApplication (CocoaCefApp)
// wraps sendEvent, terminate and run
+ (void)swizzleMethods {
  // swizzle the sendEvent method
  Method original_sendEvent = class_getInstanceMethod(self, @selector(sendEvent:));
  Method swizzled_sendEvent = class_getInstanceMethod(self, @selector(_swizzled_sendEvent:));
  method_exchangeImplementations(original_sendEvent, swizzled_sendEvent);

  // swizzle the terminate method
  Method original_terminate = class_getInstanceMethod(self, @selector(terminate:));
  Method swizzled_terminate = class_getInstanceMethod(self, @selector(_swizzled_terminate:));
  method_exchangeImplementations(original_terminate, swizzled_terminate);
  
  // swizzle replyToApplicationShouldTerminate
  Method original_replyToApplicationShouldTerminate = class_getInstanceMethod(self, @selector(replyToApplicationShouldTerminate:));
  Method swizzled_replyToApplicationShouldTerminate = class_getInstanceMethod(self, @selector(_swizzled_replyToApplicationShouldTerminate:));
  method_exchangeImplementations(original_replyToApplicationShouldTerminate, swizzled_replyToApplicationShouldTerminate);

  // swizzle the run method to catch the first invocation of run method
  [self swizzleRunMethod];
}

+ (void)swizzleRunMethod {
  Method original_run = class_getInstanceMethod(self, @selector(run));
  Method swizzled_run = class_getInstanceMethod(self, @selector(_swizzled_run));
  method_exchangeImplementations(original_run, swizzled_run);
}

+ (void)restoreRunMethod {
  Method original_run = class_getInstanceMethod(self, @selector(run));
  Method swizzled_run = class_getInstanceMethod(self, @selector(_swizzled_run));
  method_exchangeImplementations(original_run, swizzled_run);
}

- (BOOL)isHandlingSendEvent {
  return g_handling_send_event;
}

- (void)setHandlingSendEvent:(BOOL)handlingSendEvent {
  g_handling_send_event = handlingSendEvent;
}

- (void)_swizzled_sendEvent:(NSEvent *)event {
  CefScopedSendingEvent sendingEventScoper;
  
  [self _swizzled_sendEvent:event];
}

- (void)_swizzled_terminate:(id)sender {
  [self _swizzled_terminate:sender];
}

- (void)_swizzled_run {
  // restore the run method so that the CefRunMessageLoop() can call the correct run method
  [self.class restoreRunMethod];

  // start cef message loop
  [[CocoaCefContext sharedInstance] runCefMessageLoop];
  
  // uninitialize cef context
  [[CocoaCefContext sharedInstance] uninitCefContext];
}

- (void)_swizzled_replyToApplicationShouldTerminate:(BOOL)shouldTerminate {
  [self _swizzled_replyToApplicationShouldTerminate:NO];
  if (shouldTerminate) {
    // simulate the terminate notification
    [[self delegate] applicationWillTerminate:[NSNotification notificationWithName:NSApplicationWillTerminateNotification
                                                                            object:nil]];
    [[CocoaCefContext sharedInstance] performSelector:@selector(exitApplication)
                                           withObject:nil
                                           afterDelay:0];
  }
}

@end

const char*
appMainBundlePath()
{
  static std::string path;
  if (!path.empty())
    return path.c_str();
  
  @autoreleasepool {
    path = [PathFactory AppMainBundlePath].UTF8String;
  }
  return path.c_str();
}

const char*
cefFrameworkPath()
{
  static std::string path;
  if (!path.empty())
    return path.c_str();
  
  @autoreleasepool {
    path = [PathFactory CefFrameworkPath].UTF8String;
  }
  return path.c_str();
}

const char*
cefSubprocessPath()
{
  static std::string path;
  if (!path.empty())
    return path.c_str();
  
  @autoreleasepool {
    path = [PathFactory CefSubprocessPath].UTF8String;
  }
  return path.c_str();
}

const char*
cefLibraryPath()
{
  static std::string path;
  if (!path.empty())
    return path.c_str();
  
  path = cefFrameworkPath();
  path += "/";
  path += CEF_BINARY_NAME;
  return path.c_str();
}

bool
loadCefLibrary()
{
  return (1 == cef_load_library(cefLibraryPath()));
}

void
freeCefLibrary()
{
  cef_unload_library();
}

static CocoaCefContext* sharedInstance_;

@implementation CocoaCefContext {
  CefRefPtr<CefViewBrowserApp> pApp_;
  std::shared_ptr<CocoaCefAppDelegate> pAppDelegate_;
}

+ (nonnull id)sharedInstance {
  @synchronized(self) {
    if (sharedInstance_ == nil)
      sharedInstance_ = [[self alloc] initWithConfig:nil];
  }
  return sharedInstance_;
}

+ (nonnull id)contextWithConfig:(nonnull CocoaCefConfig *)config {
  @synchronized(self) {
    if (sharedInstance_ == nil)
      sharedInstance_ = [[self alloc] initWithConfig:config];
  }
  return sharedInstance_;
}

- (id)initWithConfig:(CocoaCefConfig*)config {
  if (self = [super init]) {
    if (![self initCefContext:config])
      return nil;
  }
  return self;
}

- (void)dealloc {
  [self uninitCefContext];
}

- (bool)initCefContext:(CocoaCefConfig*)config {
  // load the cef library
  if (!loadCefLibrary()) {
    return false;
  }
  
  // Build CefSettings
  CefSettings cef_settings;
  if (config)
    [config copyToCefSettings:cef_settings];
  
  // fixed values
  CefString(&cef_settings.framework_dir_path) = cefFrameworkPath();
  CefString(&cef_settings.browser_subprocess_path) = cefSubprocessPath();
  cef_settings.pack_loading_disabled = false;
  cef_settings.multi_threaded_message_loop = false;
  cef_settings.external_message_pump = false;
  
#if !defined(CEF_USE_SANDBOX)
  cef_settings.no_sandbox = true;
#endif
  
  // Initialize CEF.
  CefMainArgs main_args(*_NSGetArgc(), *_NSGetArgv());
  auto appDelegate = std::make_shared<CocoaCefAppDelegate>((__bridge void*)self);
  
  auto app = new CefViewBrowserApp([[config bridgeObjectName] UTF8String], appDelegate);
  if (!CefInitialize(main_args, cef_settings, app, nullptr)) {
    assert(0);
    return false;
  }
  
  pApp_ = app;
  pAppDelegate_ = appDelegate;
  
  _cefBrowserClientDelegate = std::make_shared<CocoaCefClientDelegate>();
  _cefBrowserClient = new CefViewBrowserClient(_cefBrowserClientDelegate);
  
  [NSApplication swizzleMethods];
  return true;
}

- (void)runCefMessageLoop {
  CefRunMessageLoop();
}

- (void)quitCefMessageLoop {
  CefQuitMessageLoop();
}

- (void)uninitCefContext {
  _cefBrowserClient = nullptr;
  _cefBrowserClientDelegate = nullptr;
  
  if (!pApp_)
    return;
  
  pAppDelegate_ = nullptr;
  pApp_ = nullptr;
  
  // shutdown the cef
  CefShutdown();
  
  freeCefLibrary();
}

- (void)exitApplication {
  [self closeAllBrowsers];
  [self quitCefMessageLoop];
}

- (void)addLocalFolderResource:(nonnull NSString *)path forUrl:(nonnull NSString *)url withPriority:(int)priority {
  _cefBrowserClient->AddLocalDirectoryResourceProvider(path.UTF8String, url.UTF8String, priority);
}

- (void)addLocalArchiveResource:(nonnull NSString *)path forUrl:(nonnull NSString *)url withPassword:(NSString *)pwd withPriority:(int)priority{
  _cefBrowserClient->AddArchiveResourceProvider(path.UTF8String, url.UTF8String, pwd.UTF8String, priority);
}

- (bool)addCookie:(nonnull NSString *)name withValue:(nonnull NSString *)value forDomain:(nonnull NSString *)domain andUrl:(nonnull NSString *)url { 
  CefCookie cookie;
  CefString(&cookie.name).FromString(name.UTF8String);
  CefString(&cookie.value).FromString(value.UTF8String);
  CefString(&cookie.domain).FromString(domain.UTF8String);
  return CefCookieManager::GetGlobalManager(nullptr)->SetCookie(CefString(url.UTF8String), cookie, nullptr);
}

- (void)closeAllBrowsers {
  _cefBrowserClient->CloseAllBrowsers();
}

- (void)scheduleCefLoopWork:(int64_t)delayMs {
}

@end
