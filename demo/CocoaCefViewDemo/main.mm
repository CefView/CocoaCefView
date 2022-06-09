//
//  main.m
//  CocoaCefDemo
//
//  Created by Sheen Tian on 2020/6/15.
//

#import <Cocoa/Cocoa.h>

#import <CocoaCefView/CocoaCefConfig.h>
#import <CocoaCefView/CocoaCefContext.h>

#import "webres.h"

int
main(int argc, const char* argv[])
{
  @autoreleasepool {
    // Setup code that might create autoreleased objects goes here.
    CocoaCefConfig* cefConfig = [[CocoaCefConfig alloc] init];
    cefConfig.userAgent = @"QCefViewTest";
    cefConfig.logLevel = LogLevel::kLogSeverityDefault;
    cefConfig.bridgeObjectName = @"CallBridge";
    cefConfig.remoteDebuggingPort = 0;
    cefConfig.backgroundColor = [NSColor colorWithCalibratedRed:0 green:0 blue:255 alpha:1.0f];

    // add command line args
    // config.addCommandLineSwitch("allow-universal-access-from-files");
    [cefConfig addCommandLineSwitch:@"enable-media-stream"];
    [cefConfig addCommandLineSwitch:@"use-mock-keychain"];
    [cefConfig addCommandLineSwitch:@"allow-file-access-from-files"];
    [cefConfig addCommandLineSwitch:@"disable-spell-checking"];
    [cefConfig addCommandLineSwitch:@"disable-site-isolation-trials"];
    [cefConfig addCommandLineSwitch:@"enable-aggressive-domstorage-flushing"];
    [cefConfig addCommandLineSwitch:@"renderer-process-limit" WithValue:@"1"];
    [cefConfig addCommandLineSwitch:@"disable-features"
                          WithValue:@"BlinkGenPropertyTrees,TranslateUI,site-per-process"];

    CocoaCefContext* cefContext = [CocoaCefContext contextWithConfig:cefConfig];
    NSString* webroot = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@FEAPP_FOLDER];
    [[CocoaCefContext sharedInstance] addLocalFolderResource:webroot forUrl:@FEAPP_BASE_URL withPriority:0];
  }

  return NSApplicationMain(argc, argv);
}
