//
//  AppDelegate.m
//  CocoaCefDemo
//
//  Created by Sheen Tian on 2020/6/15.
//

#import "AppDelegate.h"

#import "CefDemoView.h"

@interface
AppDelegate ()

@property (weak) IBOutlet NSWindow* window;

@property (weak) IBOutlet NSBox* rightBox;

@property (weak) IBOutlet CefDemoView* cefDemoView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
  // Insert code here to initialize your application
  NSLog(@"applicationDidFinishLaunching");
}

- (void)applicationWillTerminate:(NSNotification*)aNotification
{
  // Insert code here to tear down your application
  NSLog(@"applicationWillTerminate");
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
  NSLog(@"applicationShouldTerminateAfterLastWindowClosed");
  return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)sender
{
  NSLog(@"applicationShouldTerminate");
  return NSTerminateNow;
}

- (IBAction)onChangeBGColorBtnClicked:(id)sender
{
  [_cefDemoView changeBackgroundColor];
}

- (IBAction)onRecreateBrowserBtnClicked:(id)sender
{
  // remove old view
  CefDemoView* cefDemoView = _cefDemoView;
  [cefDemoView removeFromSuperview];
  
  // create new view
  CocoaCefSetting* settings = [[CocoaCefSetting alloc] init];
  cefDemoView = [[CefDemoView alloc] initWithFrame:[self.rightBox bounds] AndSettings:settings];
  [cefDemoView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [self.rightBox.contentView addSubview:cefDemoView];
  [cefDemoView navigateToUrl:@"http://www.baidu.com"];

  // weak reference
  _cefDemoView = cefDemoView;
}

@end
