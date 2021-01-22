//
//  CocoaCefApp.m
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/17.
//
#import <CocoaCefView/CocoaCefApp.h>

#pragma region cef_headers
#include <include/cef_application_mac.h>
#include <include/cef_sandbox_mac.h>
#pragma endregion cef_headers

#import "details/CCefManager.h"
#import "CocoaCefSetting.h"

@interface CocoaCefApp () <CefAppProtocol> {
@private
  BOOL handlingSendEvent_;
}

@end

@implementation CocoaCefApp

#pragma mark -- Override Methods

- (BOOL)isHandlingSendEvent {
  return handlingSendEvent_;
}

- (void)setHandlingSendEvent:(BOOL)handlingSendEvent {
  handlingSendEvent_ = handlingSendEvent;
}

- (void)initCefSettings:(CocoaCefSetting*)proposedSetting {
  
}

- (void)sendEvent:(NSEvent *)event {
  CefScopedSendingEvent sendingEventScoper;
  [super sendEvent:event];
}

- (void)finishLaunching {
  [super finishLaunching];
}

- (void)terminate:(id)sender {
  [super terminate:sender];
}

- (void)replyToApplicationShouldTerminate:(BOOL)shouldTerminate {
  if (shouldTerminate) {
    // simulate the terminate notification
    NSNotification* n = [NSNotification notificationWithName:NSApplicationWillTerminateNotification
                                                      object:nil];
    [[self delegate] applicationWillTerminate:n];
    CCefManager::getInstance().closeAllBrowserHandler();
  }
  
  [super replyToApplicationShouldTerminate:NO];
}

#pragma mark -- Helper Methods

+ (CocoaCefApp*)createInstance:(int)argc Args:(const char**) argv {
  Class principalClass = NSClassFromString([[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSPrincipalClass"]);
  CocoaCefApp* app = [principalClass sharedApplication];
  if (![app isKindOfClass:CocoaCefApp.class]) {
    @throw([NSException exceptionWithName:@"InvalidApplicationBase"
                                   reason:@"No application inherited from CocoaCefApp found"
                                 userInfo:nil]);
  }
  
  // initialize the cef settings, this must be called before loading the main Nib file,
  // because there may be CocoaCefView in the main Nib file
  [app initializeCefSettings:argc Args:argv];
  
  [app loadMainNibFile];
  
  return app;
}

- (void)initializeCefSettings:(int)argc Args:(const char**) argv {
  @autoreleasepool {
    // get settings from user defined method
    CocoaCefSetting* settings = [[CocoaCefSetting alloc] init];
    if ([self respondsToSelector:@selector(initCefSettings:)]) {
      [self performSelector:@selector(initCefSettings:) withObject:settings ];
    }
    
    // copy all settings to the cef manager
    if (settings.bridgeObjectName)
      CCefManager::getInstance().bridgeObjectName = settings.bridgeObjectName.UTF8String;
    if (settings.cacheRootPath)
      CCefManager::getInstance().cacheRootPath = settings.cacheRootPath.UTF8String;
    if (settings.cachePath)
      CCefManager::getInstance().cachePath = settings.cachePath.UTF8String;
    CCefManager::getInstance().debugPort = settings.debugPort;
    CCefManager::getInstance().backgroundColor = settings.backgroundColor;
    
    CCefManager::getInstance().initializeCef(argc, argv);
  }
}

- (void)loadMainNibFile {
  // initialize the main XIB file
  NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
  NSString* mainNibFileName = [infoDict objectForKey:@"NSMainNibFile"];
  [[NSBundle mainBundle] loadNibNamed:mainNibFileName
                                owner:self
                      topLevelObjects:nil];
}

- (void)runMessageLoop {
  // start the cef message loop
  CCefManager::getInstance().runMessageLoop();
}

- (void)exitMessageLoop {
  CCefManager::getInstance().exitMessageLoop();
}

@end

int CocoaCefApplicationMain(int argc, const char *_Nonnull argv[_Nonnull]) {
  @autoreleasepool {
    [[CocoaCefApp createInstance:argc Args:argv] runMessageLoop];
  }
    
  // uninitialize the cef library
  CCefManager::getInstance().uninitializeCef();
  
  return 0;
}
