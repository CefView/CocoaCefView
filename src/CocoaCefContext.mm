//
//  CocoaCefContext.mm
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import "CocoaCefContext.h"

#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>

#pragma region cef_headers
#include <include/cef_application_mac.h>
#include <include/cef_sandbox_mac.h>
#include <include/wrapper/cef_library_loader.h>
#pragma endregion cef_headers

#include <CefViewBrowserApp.h>
#include <CefViewBrowserClient.h>

#include "details/CocoaCefClientDelegate.h"

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

@interface NSApplication (QCefApp) <CefAppProtocol>
- (void)_swizzled_sendEvent:(NSEvent *)event;
- (void)_swizzled_terminate:(id)sender;
@end

@implementation NSApplication (QCefApp)
// wraps sendEvent and terminate
+ (void)load {
  Method original = class_getInstanceMethod(self, @selector(sendEvent));
  Method swizzled =
  class_getInstanceMethod(self, @selector(_swizzled_sendEvent));
  Method originalTerm = class_getInstanceMethod(self,
                                                @selector(terminate:));
  Method swizzledTerm =
  class_getInstanceMethod(self, @selector(_swizzled_terminate:));
  
  method_exchangeImplementations(original, swizzled);
  method_exchangeImplementations(originalTerm, swizzledTerm);
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
  std::shared_ptr<CCefAppDelegate> pAppDelegate_;
  
  CefRefPtr<CefViewBrowserClient> pClient_;
  std::shared_ptr<CocoaCefClientDelegate> pClientDelegate_;
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
    config->CopyToCefSettings(cef_settings);
  
  // fixed values
  CefString(&cef_settings.framework_dir_path) = cefFrameworkPath();
  CefString(&cef_settings.browser_subprocess_path) = cefSubprocessPath();
  cef_settings.pack_loading_disabled = false;
  cef_settings.multi_threaded_message_loop = false;
  cef_settings.external_message_pump = true;
  
#if !defined(CEF_USE_SANDBOX)
  cef_settings.no_sandbox = true;
#endif
  
  // Initialize CEF.
  CefMainArgs main_args(config->argc, config->argv);
  auto appDelegate = std::make_shared<CCefAppDelegate>(this);
  auto app = new CefViewBrowserApp(config->bridgeObjectName_, appDelegate);
  if (!CefInitialize(main_args, cef_settings, app, nullptr)) {
    assert(0);
    return false;
  }
  
  pApp_ = app;
  pAppDelegate_ = appDelegate;
  
  return true;
}

- (void)uninitCefContext {
  if (!pApp_)
    return;
  
  pAppDelegate_ = nullptr;
  pApp_ = nullptr;
  
  // shutdown the cef
  CefShutdown();
  
  freeCefLibrary();
}

- (void)addLocalFolderResource:(nonnull NSString *)path forUrl:(nonnull NSString *)url withPriority:(int)priority {
  <#code#>;
}

- (void)addLocalArchiveResource:(nonnull NSString *)path forUrl:(nonnull NSString *)url withPassword:(int)pwd {
  <#code#>;
}

- (void)addCookie:(nonnull NSString *)name withValue:(nonnull NSString *)value forDomain:(nonnull NSString *)domain andUrl:(nonnull NSString *)url { 
  <#code#>;
}

@end
