//
//  CocoaCefView.m
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//
#import <CocoaCefView/CocoaCefView.h>
#import "details/CocoaCefView+Internal.h"

#pragma region cef_headers
#include <include/cef_app.h>
#include <include/cef_application_mac.h>
#include <include/cef_browser.h>
#include <include/cef_frame.h>
#include <include/cef_parser.h>
#include <include/cef_sandbox_mac.h>
#include <include/internal/cef_mac.h>
#include <include/internal/cef_types_mac.h>
#pragma endregion cef_headers

#import <CefViewCoreProtocol.h>

#import <CefViewBrowserDelegate.h>
#import <CefViewBrowserHandler.h>

#import "details/CCefManager.h"
#import "details/CocoaCefDelegate.h"
#import "details/CocoaCefQuery+Internal.h"

@implementation CocoaCefView {
  BOOL _movingWindow;
  NSBezierPath* _draggableRegion;
  NSBezierPath* _nonDraggableRegion;
  CefRefPtr<CefViewBrowserHandler> _cefBrowserHandler;
  CefViewBrowserDelegatePtr _cefBrowserDelegate;
}

#pragma mark-- initialization

- (instancetype)initWithFrame:(NSRect)frameRect {
  NSAssert([NSApp conformsToProtocol:@protocol(CefAppProtocol)],
           @"CefAppProtocol conformation requried, make sure current NSApplication inherits from CocoaCefApp");
  
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setupCocoaCefView];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  NSAssert([NSApp conformsToProtocol:@protocol(CefAppProtocol)],
           @"CefAppProtocol conformation requried, make sure current NSApplication inherits from CocoaCefApp");
  
  self = [super initWithCoder:coder];
  if (self) {
    [self setupCocoaCefView];
  }
  return self;
}

- (void)setupCocoaCefView {
  _movingWindow = FALSE;
  _draggableRegion = nullptr;
  
  // create the browser delegate
  CefViewBrowserDelegatePtr cefBrowserDelegate = std::make_shared<CocoaCefDelegate>((__bridge void *)self);

  // Create the browser
  CefRefPtr<CefViewBrowserHandler> cefBrowserHandler = new CefViewBrowserHandler(cefBrowserDelegate);

  // Set window info
  CefWindowInfo window_info;
  window_info.SetAsChild((__bridge void *)(self), 0, 0, self.frame.size.width, self.frame.size.height);

  CefBrowserSettings browserSettings;
  // Create the main browser window.
  if (!CefBrowserHost::CreateBrowserSync(window_info,              // window info
                                         cefBrowserHandler,        // handler
                                         CefString("about:blank"), // url
                                         browserSettings,          // settings
                                         nullptr,
                                         CefRequestContext::GetGlobalContext())) {
    return;
  }
  
  CCefManager::getInstance().registerBrowserHandler(cefBrowserHandler);
  
  _cefBrowserDelegate = cefBrowserDelegate;
  _cefBrowserHandler = cefBrowserHandler;
}

- (void)dealloc {
  if (_cefBrowserHandler) {
    CCefManager::getInstance().removeBrowserHandler(_cefBrowserHandler);
  }
}

- (BOOL) isFlipped {
  return TRUE;
}

- (NSView *)hitTest:(NSPoint)point {
  NSPoint pt = [self convertPoint:point fromView:nil];
  if (_draggableRegion && [_draggableRegion containsPoint:pt]) {
    if (!_nonDraggableRegion || ![_nonDraggableRegion containsPoint:pt]) {
      _movingWindow = TRUE;
      return self;
    }
  }
  _movingWindow = FALSE;
  return [super hitTest:point];
}

- (void)mouseDown:(NSEvent *)event {
  if (_movingWindow) {
    [self.window performWindowDragWithEvent:event];
    return;
  }
  
  [super mouseDown:event];
}

- (void)mouseDragged:(NSEvent *)event {
  if (_movingWindow)
    return;
  [super mouseDragged:event];
}

#pragma mark-- Browser Event Callbacks

- (void)draggableRegionChanged:(NSBezierPath*)draggableRegion  NonDraggableRegion:(NSBezierPath*)nonDraggableRegion {
  _draggableRegion = draggableRegion;
  _nonDraggableRegion = nonDraggableRegion;
}

- (void)onLoadingStateChanged:(bool)isLoading CanGoBack:(bool)canGoBack CanGoForward:(bool)canGoForward {
}

- (void)onLoadStart {
}

- (void)onLoadEnd:(int)httpStatusCode {
}

- (bool)onLoadError:(int)errorCode ErrorMsg:(NSString *)errorMsg FailedUrl:(NSString *)failedUrl {
  return false;
}

- (void)onCocoaCefUrlRequest:(NSString *)url {
}

- (void)onCocoaCefQueryRequest:(CocoaCefQuery *)query {
}

- (void)onInvokeMethodNotify:(int)browserId
                     FrameId:(int)frameId
                      Method:(NSString *)method
                  Arguements:(NSArray *)arguments {
}

- (void)onConsoleMessage:(NSString*)message level:(int)level {
}

- (void)browserIsDestroying {
  CCefManager::getInstance().removeBrowserHandler(_cefBrowserHandler);
  _cefBrowserHandler = nullptr;
}

#pragma mark-- Browser Control Methods

- (void)addLocalFolderResource:(NSString *)path forUrl:(NSString *)url {
  if (_cefBrowserHandler) {
    _cefBrowserHandler->AddLocalDirectoryResourceProvider(path.UTF8String, url.UTF8String);
  }
}

- (void)addArchiveResource:(NSString *)path forUrl:(NSString *)url password:(NSString *)password {
  if (_cefBrowserHandler) {
    _cefBrowserHandler->AddArchiveResourceProvider(path.UTF8String, url.UTF8String, password.UTF8String);
  }
}

- (bool)addCookie:(NSString*)name withValue:(NSString*)value ofDomain:(NSString*)domain forUrl:(NSString*)url {
  return CCefManager::getInstance().addCookie([name UTF8String], [value UTF8String], [domain UTF8String], [url UTF8String]);
}

- (void)navigateToString:(NSString *)content {
  if (_cefBrowserHandler) {
    std::string data = [content UTF8String];
    data = CefURIEncode(CefBase64Encode(data.c_str(), data.size()), false).ToString();
    data = "data:text/html;base64," + data;
    _cefBrowserHandler->GetBrowser()->GetMainFrame()->LoadURL(data);
  }
}

- (void)navigateToUrl:(NSString *)url {
  if (_cefBrowserHandler) {
    CefString strUrl;
    strUrl.FromString([url UTF8String]);
    _cefBrowserHandler->GetBrowser()->GetMainFrame()->LoadURL(strUrl);
  }
}

- (bool)browserCanGoBack {
  if (_cefBrowserHandler) {
    return _cefBrowserHandler->GetBrowser()->CanGoBack();
  }
  return false;
}

- (void)browserGoBack {
  if (_cefBrowserHandler) {
    _cefBrowserHandler->GetBrowser()->GoBack();
  }
}

- (bool)browserCanGoForward {
  if (_cefBrowserHandler) {
    return _cefBrowserHandler->GetBrowser()->CanGoForward();
  }
  return false;
}

- (void)browserGoForward {
  if (_cefBrowserHandler) {
    _cefBrowserHandler->GetBrowser()->GoForward();
  }
}

- (bool)browserIsLoading {
  if (_cefBrowserHandler) {
    return _cefBrowserHandler->GetBrowser()->IsLoading();
  }
  return false;
}

- (void)browserReload {
  if (_cefBrowserHandler) {
    _cefBrowserHandler->GetBrowser()->Reload();
  }
}

- (void)browserStopLoad {
  if (_cefBrowserHandler) {
    _cefBrowserHandler->GetBrowser()->StopLoad();
  }
}

- (bool)triggerEvent:(CocoaCefEvent *)event inFrame:(int)frameId {
  if (![event.name length] || !_cefBrowserHandler) {
    return false;
  }

  return [self sendEventNotifyMessage:frameId Event:event];
}

- (bool)broadcastEvent:(CocoaCefEvent *)event {
  if (![event.name length] || !_cefBrowserHandler) {
    return false;
  }

  return [self sendEventNotifyMessage:CefViewBrowserHandler::ALL_FRAMES Event:event];
}

- (bool)responseCefQuery:(CocoaCefQuery *)query {
  if (_cefBrowserHandler) {
    return _cefBrowserHandler->ResponseQuery(query.rid, query.success, query.response.UTF8String, query.error);
  }
  return false;
}

#pragma mark-- Private Helper Methods

- (bool)sendEventNotifyMessage:(int)frameId Event:(CocoaCefEvent *)event {
  if (!_cefBrowserHandler)
    return false;

  // create the event notify message
  CefRefPtr<CefProcessMessage> msg = CefProcessMessage::Create(TRIGGEREVENT_NOTIFY_MESSAGE);
  CefRefPtr<CefListValue> arguments = msg->GetArgumentList();

  int idx = 0;

  // set event name
  CefString eventName = [event.name UTF8String];
  arguments->SetString(idx++, eventName);

  // create parameter object
  CefRefPtr<CefDictionaryValue> dict = CefDictionaryValue::Create();

  // add event name to the parameter object
  CefString cefStr = [event.name UTF8String];
  dict->SetString("_event_name_", cefStr);

  @autoreleasepool {
    [event
        enumerateAllValuesUsingBlock:^(NSString *_Nonnull key, CocoaCefEventValue *_Nonnull val, BOOL *_Nonnull stop) {
          if (val.type == kCocoaCefString) {
            // string (utf-8)
            dict->SetString(CefString([key UTF8String]), CefString([(NSString *)val.value UTF8String]));
          } else if (val.type == kCocoaCefBinary) {
            // data
            NSData *data = (NSData *)val.value;
            dict->SetBinary(CefString([key UTF8String]), CefBinaryValue::Create([data bytes], [data length]));
          } else if (val.type == kCocoaCefBoolean) {
            // bool
            NSNumber *number = (NSNumber *)val.value;
            dict->SetBool(CefString([key UTF8String]), [number boolValue]);
          } else if (val.type == kCocoaCefInteger) {
            // int
            NSNumber *number = (NSNumber *)val.value;
            dict->SetInt(CefString([key UTF8String]), [number intValue]);
          } else if (val.type == kCocoaCefDouble) {
            // double
            NSNumber *number = (NSNumber *)val.value;
            dict->SetDouble(CefString([key UTF8String]), [number doubleValue]);
          }
        }];
  }

  // add parameter object to the message
  arguments->SetDictionary(idx++, dict);
  return _cefBrowserHandler->TriggerEvent(frameId, msg);
}

@end
