//
//  CefDemoView.m
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/15.
//

#import "CefDemoView.h"
#import "webres.h"

#if (defined(DEBUG) || defined(_DEBUG) || !defined(DNDEBUG))
#define FLog(message, ...) NSLog((@"%s [Line %d] " message), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define FLog(message, ...)
#endif

@implementation CefDemoView {
  BOOL _movingWindow;
  BOOL _firstLoadingDone;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
  CocoaCefSetting* settings = [[CocoaCefSetting alloc] init];
  settings.backgroundColor = [NSColor grayColor];

  self = [super initWithFrame:frameRect AndSettings:settings];
  if (self) {
    [self setupCefDemoView];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
  CocoaCefSetting* settings = [[CocoaCefSetting alloc] init];
  settings.backgroundColor = [NSColor grayColor];

  self = [super initWithCoder:coder AndSettings:settings];
  if (self) {
    [self setupCefDemoView];
  }
  return self;
}

- (void)setupCefDemoView
{
  _movingWindow = FALSE;
  _firstLoadingDone = TRUE;

  NSURL* indexUrl = [NSURL URLWithString:@FEAPP_INDEX relativeToURL:[NSURL URLWithString:@FEAPP_BASE_URL]];

  [self navigateToUrl:indexUrl.absoluteString];
}

- (void)changeBackgroundColor
{
  CocoaCefEvent* event = [CocoaCefEvent initWithName:@"colorChange"];
  [event.arguments addObject:[NSString stringWithFormat:@"#%06X", (arc4random() % 0xFFFFFF)]];
  [self broadcastEvent:event];
}

- (void)onLoadingStateChanged:(bool)isLoading CanGoBack:(bool)canGoBack CanGoForward:(bool)canGoForward
{
  if (_firstLoadingDone && !isLoading) {
    // loading complete
    _firstLoadingDone = FALSE;
    [self.window setIsVisible:YES];
  }
  FLog(@"%hd", isLoading);
}

- (void)onLoadStart
{
  FLog(@"");
}

- (void)onLoadEnd:(int)httpStatusCode
{
  FLog(@"");
}

- (bool)onLoadError:(int)errorCode ErrorMsg:(NSString*)errorMsg FailedUrl:(NSString*)failedUrl
{
  FLog(@"");
  return false;
}

- (void)onCefQueryRequest:(int)browserId Frame:(long long)frameId Query:(CocoaCefQuery*)query
{
  FLog(@"");
  NSString* reqeust = query.request;
  [query setResponse:reqeust.uppercaseString WithResult:true AndErrorCode:0];
  [self responseCefQuery:query];
}

- (void)onInvokeMethod:(int)browserId Frame:(long long)frameId Method:(NSString*)method Arguments:(NSArray*)arguments
{
  FLog(@"");
  if ([method isEqual:@"TestMethod"]) {
    NSAlert* alert = [[NSAlert alloc] init];
    [alert setMessageText:@"native method invoked from javascript"];

    NSMutableString* msg = [[NSMutableString alloc] init];
    for (int i = 0; i < arguments.count; i++) {
      NSObject* arg = [arguments objectAtIndex:i];

      [msg appendFormat:@"args[%d]: type:%@, value:%@\n", i, arg.className, arg];
    }
    [alert setInformativeText:msg];

    [alert runModal];
  }
}

- (void)onConsoleMessage:(NSString*)message withLevel:(int)level
{
  NSLog(@"web log: %d, %@", level, message);
}

@end
