//
//  main.m
//  CocoaCefDemo
//
//  Created by Sheen Tian on 2020/6/15.
//

#import <Cocoa/Cocoa.h>

#import <CocoaCefView/CocoaCef.h>

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    // Setup code that might create autoreleased objects goes here.
    CocoaCefConfig* cefConfig = [[CocoaCefConfig alloc] init];
    cefConfig.bridgeObjectName = @"CallBridge";
    cefConfig.remoteDebuggingport = [NSNumber numberWithInt:9000];
    cefConfig.backgroundColor = [NSColor cyanColor];
    
    CocoaCefContext* cefContext = [CocoaCefContext contextWithConfig:cefConfig];
  }
  return NSApplicationMain(argc, argv);
}
