//
//  AppDelegate.m
//  CocoaCefDemo
//
//  Created by Sheen Tian on 2020/6/15.
//

#import "AppDelegate.h"

#import "CefDemoView.h"

@interface AppDelegate ()

@property(weak) IBOutlet CefDemoView *cefDemoView;
@property(weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  NSLog(@"applicationDidFinishLaunching");
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
  NSLog(@"applicationWillTerminate");
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  NSLog(@"applicationShouldTerminateAfterLastWindowClosed");
  return YES;
}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
  NSLog(@"applicationShouldTerminate");
  return NSTerminateNow;
}

- (IBAction)onChangeBGColorBtnClicked:(id)sender {
  [_cefDemoView changeBackgroundColor];
}

@end
