//
//  CocoaCefView.mm
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//
#import <CocoaCefView/CocoaCefView.h>

#import <unordered_set>

#import "CocoaCefContext+Internal.h"
#import "CocoaCefView+Internal.h"
#import "CocoaCefSetting+Internal.h"

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

#include <CefViewCoreProtocol.h>

#include "CocoaCefQuery+Internal.h"
#include "ValueConvertor.h"

static std::unordered_set<void*> sLiveInstances;

@implementation CocoaCefView {
  CefRefPtr<CefBrowser> _browser;
  CefRefPtr<CefViewBrowserClient> _client;
  CocoaCefClientDelegate::RefPtr _clientDelegate;

  CocoaCefContext* _cefContext;

  BOOL _movingWindow;
  NSBezierPath* _draggableRegion;
  NSBezierPath* _nonDraggableRegion;
}

#pragma mark-- initialization

- (instancetype)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setupCocoaCefView:nil];
  }
  return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect AndSettings:(CocoaCefSetting*)settings
{
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setupCocoaCefView:settings];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setupCocoaCefView:nil];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder AndSettings:(CocoaCefSetting*)settings
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setupCocoaCefView:settings];
  }
  return self;
}

- (void)setupCocoaCefView:(CocoaCefSetting*)settings
{
  sLiveInstances.insert((__bridge void*)self);

  _movingWindow = FALSE;
  _draggableRegion = nullptr;

  [self createCefBrowser:settings];
}

- (void)dealloc
{
  [self destroyCefBrowser];

  sLiveInstances.erase((__bridge void*)self);
}

+ (void)destroyAllBrowsers
{
  for (auto& p : sLiveInstances) {
    CocoaCefView* _self = (__bridge CocoaCefView*)p;
    [_self destroyCefBrowser];
  }
}

- (void)createCefBrowser:(CocoaCefSetting*)settings
{
  _cefContext = [CocoaCefContext sharedInstance];

  auto pClientDelegate = std::make_shared<CocoaCefClientDelegate>(self);
  auto pClient = new CefViewBrowserClient([_cefContext getCefApp], pClientDelegate);

  for (auto& folderMapping : [_cefContext getFolderResourceMappingList]) {
    pClient->AddLocalDirectoryResourceProvider(folderMapping.path, folderMapping.url, folderMapping.priority);
  }

  for (auto& archiveMapping : [_cefContext getArchiveResourceMappingList]) {
    pClient->AddArchiveResourceProvider(
      archiveMapping.path, archiveMapping.url, archiveMapping.password, archiveMapping.priority);
  }

  // Set window info
  CefWindowInfo window_info;
  window_info.SetAsChild((__bridge void*)(self),
                         CefRect{ 0, 0, (int)self.frame.size.width, (int)self.frame.size.height });

  CefBrowserSettings browserSettings;
  if (settings)
    [settings copyToCefBrowserSettings:browserSettings];

  // Create the main browser window.
  auto pCefBrowser = CefBrowserHost::CreateBrowserSync(window_info,              // window info
                                                       pClient,                  // handler
                                                       CefString("about:blank"), // url
                                                       browserSettings,          // settings
                                                       nullptr,
                                                       CefRequestContext::GetGlobalContext());

  if (!pCefBrowser) {
    return;
  }

  _browser = pCefBrowser;
  _client = pClient;
  _clientDelegate = pClientDelegate;
}

- (void)destroyCefBrowser
{
  if (!_client)
    return;
  
  NSView* browserView = (__bridge NSView*)(_browser->GetHost()->GetWindowHandle());
  [browserView removeFromSuperview];
  
  // clean all browsers
  _client->CloseAllBrowsers();
  _client = nullptr;
  _browser = nullptr;
}

- (void)onCefMainBrowserCreated:(CefRefPtr<CefBrowser>&)browser
{
  _browser = browser;
}

- (void)onCefPopupBrowserCreated:(CefRefPtr<CefBrowser>&)browser
{
}

- (void)onCefBeforeCloseBrowser:(CefRefPtr<CefBrowser>&)browser
{
}

- (void)setCefWindowFocus:(bool)focused
{
  if (_browser) {
    CefRefPtr<CefBrowserHost> host = _browser->GetHost();
    if (host) {
      host->SetFocus(focused);
    }
  }
}

- (void)onCefWindowLostTabFocus:(bool)next
{
  if (next)
    [self.window selectNextKeyView:self];
  else
    [self.window selectPreviousKeyView:self];
}

- (void)onCefWindowGotFocus
{
}

- (BOOL)isFlipped
{
  return TRUE;
}

- (NSView*)hitTest:(NSPoint)point
{
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

- (void)mouseDown:(NSEvent*)event
{
  if (_movingWindow) {
    [self.window performWindowDragWithEvent:event];
    return;
  }

  [super mouseDown:event];
}

- (void)mouseDragged:(NSEvent*)event
{
  if (_movingWindow)
    return;
  [super mouseDragged:event];
}

#pragma mark-- Browser Control Methods

- (void)addLocalFolderResource:(nonnull NSString*)path forUrl:(nonnull NSString*)url withPriority:(int)priority
{
  std::string p = path.UTF8String;
  std::string u = url.UTF8String;
  _client->AddLocalDirectoryResourceProvider(p, u, priority);
}

- (void)addLocalArchiveResource:(nonnull NSString*)path
                         forUrl:(nonnull NSString*)url
                   withPassword:(NSString*)pwd
                   withPriority:(int)priority
{
  std::string p = path.UTF8String;
  std::string u = url.UTF8String;
  std::string s = pwd.UTF8String;
  _client->AddArchiveResourceProvider(p, u, s, priority);
}

- (int)browserId
{
  return _browser->GetIdentifier();
}

- (void)navigateToString:(NSString*)content
{
  if (_browser) {
    std::string data = [content UTF8String];
    data = CefURIEncode(CefBase64Encode(data.c_str(), data.size()), false).ToString();
    data = "data:text/html;base64," + data;
    _browser->GetMainFrame()->LoadURL(data);
  }
}

- (void)navigateToUrl:(NSString*)url
{
  if (_browser) {
    CefString strUrl;
    strUrl.FromString([url UTF8String]);
    _browser->GetMainFrame()->LoadURL(strUrl);
  }
}

- (bool)browserCanGoBack
{
  if (_browser) {
    return _browser->CanGoBack();
  }
  return false;
}

- (void)browserGoBack
{
  if (_browser) {
    _browser->GoBack();
  }
}

- (bool)browserCanGoForward
{
  if (_browser) {
    return _browser->CanGoForward();
  }
  return false;
}

- (void)browserGoForward
{
  if (_browser) {
    _browser->GoForward();
  }
}

- (bool)browserIsLoading
{
  if (_browser) {
    return _browser->IsLoading();
  }
  return false;
}

- (void)browserReload
{
  if (_browser) {
    _browser->Reload();
  }
}

- (void)browserStopLoad
{
  if (_browser) {
    _browser->StopLoad();
  }
}

- (bool)triggerEvent:(CocoaCefEvent*)event
{
  return false;
}

- (bool)triggerEvent:(CocoaCefEvent*)event InFrame:(long long)frameId
{
  if (![event.name length] || !_browser) {
    return false;
  }

  return [self sendEventNotifyMessage:frameId Event:event];
}

- (bool)broadcastEvent:(CocoaCefEvent*)event
{
  if (![event.name length] || !_browser) {
    return false;
  }

  return [self sendEventNotifyMessage:CefViewBrowserClient::ALL_FRAMES Event:event];
}

- (bool)responseCefQuery:(CocoaCefQuery*)query
{
  if (_browser) {
    return _client->ResponseQuery(query.rid, query.success, query.response.UTF8String, query.error);
  }
  return false;
}

- (bool)executeJavascript:(NSString*)code InFrame:(long long)frameId WithUrl:(NSString*)url StartAt:(int)lineNum
{
  if (_browser) {
    CefRefPtr<CefFrame> frame = _browser->GetFrame(frameId);
    if (frame) {
      CefString c;
      c.FromString(code.UTF8String);

      CefString u;
      u.FromString(url.UTF8String);

      frame->ExecuteJavaScript(c, u, lineNum);

      return true;
    }
  }

  return false;
}

- (bool)setPreference:(NSString*)name withValue:(NSData*)value onError:(NSString*)error
{
  if (_browser) {
    CefRefPtr<CefBrowserHost> host = _browser->GetHost();
    if (host) {
      CefString n;
      n.FromString(name.UTF8String);

      auto v = [ValueConvertor CefValueFromNSValue:value];
      CefString e;
      auto r = host->GetRequestContext()->SetPreference(n, v, e);
      error = [NSString stringWithUTF8String:e.ToString().c_str()];
      return r;
    }
  }

  return false;
}

#pragma mark-- Browser Event Callbacks

- (void)onLoadingStateChanged:(int)browserId
                    IsLoading:(bool)isLoading
                    CanGoBack:(bool)canGoBack
                 CanGoForward:(bool)canGoForward
{
}

- (void)onLoadStart:(int)browserId
            FrameId:(long long)frameId
        IsMainFrame:(bool)isMainFrame
     TransitionType:(int)transitionType
{
}

- (void)onLoadEnd:(int)browserId FrameId:(long long)frameId IsMainFrame:(bool)isMainFrame StatusCode:(int)httpStatusCode
{
}

- (bool)onLoadError:(int)browserId
            FrameId:(long long)frameId
        IsMainFrame:(bool)isMainFrame
          ErrorCode:(int)errorCode
           ErrorMsg:(NSString*)errorMsg
          FailedUrl:(NSString*)failedUrl
            Handled:(bool&)handled
{
  return false;
}

- (void)onDraggableRegionChanged:(NSBezierPath*)draggableRegion NonDraggableRegion:(NSBezierPath*)nonDraggableRegion
{
  _draggableRegion = draggableRegion;
  _nonDraggableRegion = nonDraggableRegion;
}

- (void)onAddressChanged:(long long)frameId url:(NSString*)url
{
}

- (void)onTitleChanged:(NSString*)title
{
}

- (void)onFullscreenModeChanged:(bool)fullscreen
{
}

- (void)onStatusMessage:(NSString*)message
{
}

- (void)onConsoleMessage:(NSString*)message withLevel:(int)level
{
}

- (void)onLoadingProgressChanged:(double)progress
{
}

- (void)onCefQueryRequest:(int)browserId Frame:(long long)frameId Query:(CocoaCefQuery*)query
{
}

- (void)onInvokeMethod:(int)browserId Frame:(long long)frameId Method:(NSString*)method Arguments:(NSArray*)arguments
{
}

- (void)onReportJavascriptResult:(int)browserId
                           Frame:(long long)frameId
                         Context:(long long)context
                          Result:(NSObject*)result
{
}

#pragma mark-- Private Helper Methods

- (bool)sendEventNotifyMessage:(long long)frameId Event:(CocoaCefEvent*)event
{
  // create the event notify message
  CefRefPtr<CefProcessMessage> msg = CefProcessMessage::Create(kCefViewClientBrowserTriggerEventMessage);
  CefRefPtr<CefListValue> arguments = msg->GetArgumentList();

  int idx = 0;
  CefString eventName = [event.name UTF8String];
  arguments->SetString(idx++, eventName);

  // set event arguments
  for (id arg in event.arguments) {
    auto cVal = [ValueConvertor CefValueFromNSValue:arg];
    arguments->SetValue(idx++, cVal);
  }

  return _client->TriggerEvent(_browser, frameId, msg);
}

@end
