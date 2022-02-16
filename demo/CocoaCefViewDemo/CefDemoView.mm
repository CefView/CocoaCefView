//
//  CefDemoView.m
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/15.
//

#import "CefDemoView.h"

#if (defined(DEBUG) || defined(_DEBUG) || !defined(DNDEBUG))
#define FLog(message, ...)                                                     \
  NSLog((@"%s [Line %d] " message), __PRETTY_FUNCTION__, __LINE__,             \
        ##__VA_ARGS__)
#else
#define FLog(message, ...)
#endif

#define FEAPP_SCHEME "http://"
#define FEAPP_FOLDER "webres"
#define FEAPP_HOST "feapp"
#define FEAPP_INDEX "/index.html"
#define FEAPP_BASE_URL FEAPP_SCHEME FEAPP_HOST

@implementation CefDemoView {
  BOOL _movingWindow;
  BOOL _firstLoadingDone;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
  
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setupCefDemoView];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {

  self = [super initWithCoder:coder];
  if (self) {
    [self setupCefDemoView];
  }
  return self;
}

- (void)setupCefDemoView {
  _movingWindow = FALSE;
  _firstLoadingDone = TRUE;
  
  NSString *webroot = [[[NSBundle mainBundle] resourcePath]
      stringByAppendingPathComponent:@FEAPP_FOLDER];
//  [self addLocalFolderResource:webroot forUrl:@FEAPP_BASE_URL];

  NSURL *indexUrl =
      [NSURL URLWithString:@FEAPP_INDEX
             relativeToURL:[NSURL URLWithString:@FEAPP_BASE_URL]];
  
  [self navigateToUrl:indexUrl.absoluteString];
}

- (void)changeBackgroundColor {
  CocoaCefEvent *event = [CocoaCefEvent initWithName:@"colorChange"];
  [event setStringValue:[NSString stringWithFormat:@"#%06X",
                                                   (arc4random() % 0xFFFFFF)]
                 forKey:@"color"];
  [self broadcastEvent:event];
}

- (void)onLoadingStateChanged:(bool)isLoading
                    CanGoBack:(bool)canGoBack
                 CanGoForward:(bool)canGoForward {
  if (_firstLoadingDone && !isLoading) {
    // loading complete
      _firstLoadingDone = FALSE;
    [self.window setIsVisible:YES];
  }
  FLog(@"%hd", isLoading);
}

- (void)onLoadStart {
  FLog(@"");
}

- (void)onLoadEnd:(int)httpStatusCode {
  FLog(@"");
}

- (bool)onLoadError:(int)errorCode
           ErrorMsg:(NSString *)errorMsg
          FailedUrl:(NSString *)failedUrl {
  FLog(@"");
  return false;
}

- (void)onCocoaCefUrlRequest:(NSString *)url {
  FLog(@"");
}

- (void)onCocoaCefQueryRequest:(CocoaCefQuery *)query {
  FLog(@"");
  NSString *reqeust = query.request;
  query.response = reqeust.uppercaseString;
  query.error = 0;
  query.success = true;
  [self responseCefQuery:query];
}

- (void)onInvokeMethodNotify:(int)browserId
                     FrameId:(int)frameId
                      Method:(NSString *)method
                  Arguements:(NSArray *)arguments {
  FLog(@"");
  if ([method isEqual:@"TestMethod"]) {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"native method invoked from javascript"];

    NSMutableString *msg = [[NSMutableString alloc] init];
    for (int i = 0; i < arguments.count; i++) {
      NSObject *arg = [arguments objectAtIndex:i];
      [msg
          appendFormat:@"args[%d]: type:%@, value:%@\n", i, arg.className, arg];
    }
    [alert setInformativeText:msg];

    [alert runModal];
  }
}

- (void)onConsoleMessage:(NSString*)message level:(int)level {
  NSLog(@"web log: %d, %@", level, message);
}

@end
