//
//  CocoaCefView.mm
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//
#import <CocoaCefView/CocoaCefView.h>

#import "CocoaCefContext+Internal.h"
#import "CocoaCefView+Internal.h"

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

#import "CocoaCefQuery+Internal.h"

@implementation CocoaCefView {
  CefRefPtr<CefBrowser> pCefBrowser_;
  
  CocoaCefContext* _cefContext;
  
  BOOL _movingWindow;
  NSBezierPath* _draggableRegion;
  NSBezierPath* _nonDraggableRegion;
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

- (instancetype)initWithCoder:(NSCoder*)coder {
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
  
  _cefContext = [CocoaCefContext sharedInstance];
  
  // Set window info
  CefWindowInfo window_info;
  window_info.SetAsChild((__bridge void*)(self), 0, 0, self.frame.size.width, self.frame.size.height);
  
  CefBrowserSettings browserSettings;
  
  // Create the main browser window.
  auto pCefBrowser = CefBrowserHost::CreateBrowserSync(window_info,                       // window info
                                                       _cefContext.cefBrowserClient,      // handler
                                                       CefString("about:blank"),          // url
                                                       browserSettings,                   // settings
                                                       nullptr,
                                                       CefRequestContext::GetGlobalContext());
  
  if (!pCefBrowser) {
    return;
  }
  
  // register view to client delegate
  _cefContext.cefBrowserClientDelegate->insertBrowserViewMapping(pCefBrowser, self);
  
  pCefBrowser_ = pCefBrowser;
}

- (void)dealloc {
  _cefContext.cefBrowserClientDelegate->removeBrowserViewMapping(pCefBrowser_);
}

- (BOOL) isFlipped {
  return TRUE;
}

- (NSView*)hitTest:(NSPoint)point {
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

- (void)mouseDown:(NSEvent*)event {
  if (_movingWindow) {
    [self.window performWindowDragWithEvent:event];
    return;
  }
  
  [super mouseDown:event];
}

- (void)mouseDragged:(NSEvent*)event {
  if (_movingWindow)
    return;
  [super mouseDragged:event];
}

#pragma mark-- Browser Control Methods
- (int)browserId {
  
}

- (void)navigateToString:(NSString*)content {
  if (pCefBrowser_) {
    std::string data = [content UTF8String];
    data = CefURIEncode(CefBase64Encode(data.c_str(), data.size()), false).ToString();
    data = "data:text/html;base64," + data;
    pCefBrowser_->GetMainFrame()->LoadURL(data);
  }
}

- (void)navigateToUrl:(NSString*)url {
  if (pCefBrowser_) {
    CefString strUrl;
    strUrl.FromString([url UTF8String]);
    pCefBrowser_->GetMainFrame()->LoadURL(strUrl);
  }
}

- (bool)browserCanGoBack {
  if (pCefBrowser_) {
    return pCefBrowser_->CanGoBack();
  }
  return false;
}

- (void)browserGoBack {
  if (pCefBrowser_) {
    pCefBrowser_->GoBack();
  }
}

- (bool)browserCanGoForward {
  if (pCefBrowser_) {
    return pCefBrowser_->CanGoForward();
  }
  return false;
}

- (void)browserGoForward {
  if (pCefBrowser_) {
    pCefBrowser_->GoForward();
  }
}

- (bool)browserIsLoading {
  if (pCefBrowser_) {
    return pCefBrowser_->IsLoading();
  }
  return false;
}

- (void)browserReload {
  if (pCefBrowser_) {
    pCefBrowser_->Reload();
  }
}

- (void)browserStopLoad {
  if (pCefBrowser_) {
    pCefBrowser_->StopLoad();
  }
}

- (bool)triggerEvent:(CocoaCefEvent*)event {
  return false;
}

- (bool)triggerEvent:(CocoaCefEvent*)event inFrame:(int)frameId {
  if (![event.name length] || !pCefBrowser_) {
    return false;
  }
  
  return [self sendEventNotifyMessage:frameId Event:event];
}

- (bool)broadcastEvent:(CocoaCefEvent*)event {
  if (![event.name length] || !pCefBrowser_) {
    return false;
  }
  
  return [self sendEventNotifyMessage:CefViewBrowserClient::ALL_FRAMES Event:event];
}

- (bool)responseCefQuery:(CocoaCefQuery*)query {
  if (pCefBrowser_) {
    return _cefContext.cefBrowserClient->ResponseQuery(query.rid, query.success, query.response.UTF8String, query.error);
  }
  return false;
}

#pragma mark-- Browser Event Callbacks

- (void)onLoadingStateChanged:(bool)isLoading CanGoBack:(bool)canGoBack CanGoForward:(bool)canGoForward {
}

- (void)onLoadStart {
}

- (void)onLoadEnd:(int)httpStatusCode {
}

- (bool)onLoadError:(int)errorCode ErrorMsg:(NSString*)errorMsg FailedUrl:(NSString*)failedUrl Handled:(bool&)handled {
  return false;
}

- (void)onDraggableRegionChanged:(NSBezierPath*)draggableRegion  NonDraggableRegion:(NSBezierPath*)nonDraggableRegion {
  _draggableRegion = draggableRegion;
  _nonDraggableRegion = nonDraggableRegion;
}

- (void)onAddressChanged:(int)frameId url:(NSString*)url {
  
}

- (void)onTitleChanged:(NSString*)title {
  
}

- (void)onFullscreenModeChanged:(bool)fullscreen {
  
}

- (void)onStatusMessage:(NSString*)message {
  
}

- (void)onConsoleMessage:(NSString*)message withLevel:(int)level {
  
}

- (void)onLoadingProgressChanged:(double)progress {
  
}

- (void)onCefQueryRequest:(int)browserId Frame:(int)frameId Query:(CocoaCefQuery*)query {
}

- (void)onInvokeMethod:(int)browserId Frame:(int)frameId Method:(NSString*)method Arguments:(NSArray*)arguments {
}

#pragma mark-- Private Helper Methods

- (bool)sendEventNotifyMessage:(int)frameId Event:(CocoaCefEvent*)event {
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
     enumerateAllValuesUsingBlock:^(NSString* _Nonnull key, CocoaCefEventValue* _Nonnull val, BOOL* _Nonnull stop) {
      if (val.type == kCocoaCefString) {
        // string (utf-8)
        dict->SetString(CefString([key UTF8String]), CefString([(NSString*)val.value UTF8String]));
      } else if (val.type == kCocoaCefBinary) {
        // data
        NSData* data = (NSData*)val.value;
        dict->SetBinary(CefString([key UTF8String]), CefBinaryValue::Create([data bytes], [data length]));
      } else if (val.type == kCocoaCefBoolean) {
        // bool
        NSNumber* number = (NSNumber*)val.value;
        dict->SetBool(CefString([key UTF8String]), [number boolValue]);
      } else if (val.type == kCocoaCefInteger) {
        // int
        NSNumber* number = (NSNumber*)val.value;
        dict->SetInt(CefString([key UTF8String]), [number intValue]);
      } else if (val.type == kCocoaCefDouble) {
        // double
        NSNumber* number = (NSNumber*)val.value;
        dict->SetDouble(CefString([key UTF8String]), [number doubleValue]);
      }
    }];
  }
  
  // add parameter object to the message
  arguments->SetDictionary(idx++, dict);
  return _cefContext.cefBrowserClient->TriggerEvent(pCefBrowser_, frameId, msg);
}

@end
