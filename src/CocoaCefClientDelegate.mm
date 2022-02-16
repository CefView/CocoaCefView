//
//  CocoaCefDelegate.m
//  CocoaCefView
//
//  Created by START-TEST on 1/24/21.
//

#import "CocoaCefClientDelegate.h"

#include "CocoaCefView+Internal.h"
#include "CocoaCefQuery+Internal.h"

CocoaCefClientDelegate::CocoaCefClientDelegate() {}

CocoaCefView* CocoaCefClientDelegate::take(CefRefPtr<CefBrowser>& browser){
  if (!browser)
    return nullptr;
  auto it = view_map_.find(browser->GetIdentifier());
  if (it == view_map_.end())
    return nullptr;

  return it->second;
}

void CocoaCefClientDelegate::insertBrowserViewMapping(CefRefPtr<CefBrowser>& browser, void* view){
  auto id = browser->GetIdentifier();
  view_map_[id] = view;  
}

void CocoaCefClientDelegate::removeBrowserViewMapping(CefRefPtr<CefBrowser>& browser){
  auto id = browser->GetIdentifier();
  view_map_.erase(id);  
}

void CocoaCefClientDelegate::loadingStateChanged(CefRefPtr<CefBrowser> &browser, bool isLoading, bool canGoBack, bool canGoForward) { 
  auto p = take(browser);
  if (p)
    [p loadingStateChanged(isLoading, canGoBack, canGoForward)];
}


void CocoaCefClientDelegate::loadStart(CefRefPtr<CefBrowser> &browser) { 
  
}


void CocoaCefClientDelegate::loadEnd(CefRefPtr<CefBrowser> &browser, int httpStatusCode) { 
  
}


void CocoaCefClientDelegate::loadError(CefRefPtr<CefBrowser> &browser, int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) { 
  
}


void CocoaCefClientDelegate::draggableRegionChanged(CefRefPtr<CefBrowser> &browser, const std::vector<CefDraggableRegion> &regions) { 
  
}


void CocoaCefClientDelegate::addressChanged(CefRefPtr<CefBrowser> &browser, int frameId, const CefString &url) { 
  
}


void CocoaCefClientDelegate::titleChanged(CefRefPtr<CefBrowser> &browser, const CefString &title) { 
  
}


bool CocoaCefClientDelegate::tooltipMessage(CefRefPtr<CefBrowser> &browser, const CefString &text) { 
  
}


void CocoaCefClientDelegate::fullscreenModeChanged(CefRefPtr<CefBrowser> &browser, bool fullscreen) { 
  
}


void CocoaCefClientDelegate::statusMessage(CefRefPtr<CefBrowser> &browser, const CefString &value) { 
  
}


void CocoaCefClientDelegate::loadingProgressChanged(CefRefPtr<CefBrowser> &browser, double progress) { 
  
}


void CocoaCefClientDelegate::consoleMessage(CefRefPtr<CefBrowser> &browser, const std::string &message, int level) { 
  
}


bool CocoaCefClientDelegate::cursorChanged(CefRefPtr<CefBrowser> browser, void * _Nonnull cursor, cef_cursor_type_t type, const CefCursorInfo &custom_cursor_info) { 
  return false;
}


void CocoaCefClientDelegate::takeFocus(CefRefPtr<CefBrowser> &browser, bool next) { 
  
}


bool CocoaCefClientDelegate::setFocus(CefRefPtr<CefBrowser> &browser) { 
  return false;
}


void CocoaCefClientDelegate::gotFocus(CefRefPtr<CefBrowser> &browser) { 
  
}


void CocoaCefClientDelegate::processQueryRequest(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &query, const int64_t query_id) { 
  
}


void CocoaCefClientDelegate::invokeMethodNotify(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &method, const CefRefPtr<CefListValue> &arguments) { 
  
}


bool CocoaCefClientDelegate::GetRootScreenRect(CefRefPtr<CefBrowser> browser, CefRect &rect) { 
  return false;
}


void CocoaCefClientDelegate::GetViewRect(CefRefPtr<CefBrowser> browser, CefRect &rect) { 
  
}


bool CocoaCefClientDelegate::GetScreenPoint(CefRefPtr<CefBrowser> browser, int viewX, int viewY, int &screenX, int &screenY) { 
  return false;
}


bool CocoaCefClientDelegate::GetScreenInfo(CefRefPtr<CefBrowser> browser, CefScreenInfo &screen_info) { 
  return false;
}


void CocoaCefClientDelegate::OnPopupShow(CefRefPtr<CefBrowser> browser, bool show) { 
  
}


void CocoaCefClientDelegate::OnPopupSize(CefRefPtr<CefBrowser> browser, const CefRect &rect) { 
  
}


void CocoaCefClientDelegate::OnPaint(CefRefPtr<CefBrowser> browser, CefRenderHandler::PaintElementType type, const CefRenderHandler::RectList &dirtyRects, const void * _Nonnull buffer, int width, int height) { 
  
}


//void CocoaCefClientDelegate::setBrowserWindowId(CefWindowHandle /* win */) {
//  // currently not use
//}
//
//void CocoaCefClientDelegate::loadingStateChanged(bool isLoading, bool canGoBack, bool canGoForward) {
//  [_host onLoadingStateChanged:isLoading CanGoBack:canGoBack CanGoForward:canGoBack];
//}
//
//void CocoaCefClientDelegate::loadStart() { [_host onLoadStart]; }
//
//void CocoaCefClientDelegate::loadEnd(int httpStatusCode) { [_host onLoadEnd:httpStatusCode]; }
//
//void CocoaCefClientDelegate::loadError(int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) {
//  @autoreleasepool {
//    NSString *strMsg = [NSString stringWithUTF8String:errorMsg.c_str()];
//    NSString *strUrl = [NSString stringWithUTF8String:failedUrl.c_str()];
//    handled = [_host onLoadError:errorCode ErrorMsg:strMsg FailedUrl:strUrl];
//  }
//}
//
//void CocoaCefClientDelegate::draggableRegionChanged(const std::vector<CefDraggableRegion>& regions) {
//  NSBezierPath* draggableRegion = [NSBezierPath bezierPath];
//  NSBezierPath* nonDraggableRegion = [NSBezierPath bezierPath];
//  for (auto it = regions.begin(); it != regions.end(); ++it) {
//    NSRect rc = {
//      static_cast<CGFloat>(it->bounds.x),
//      static_cast<CGFloat>(it->bounds.y),
//      static_cast<CGFloat>(it->bounds.width),
//      static_cast<CGFloat>(it->bounds.height)
//    };
//    if (it->draggable) {
//      [draggableRegion appendBezierPathWithRect:rc];
//    } else {
//      [nonDraggableRegion appendBezierPathWithRect:rc];
//    }
//  }
//  [draggableRegion closePath];
//  [nonDraggableRegion closePath];
//  [_host draggableRegionChanged:draggableRegion NonDraggableRegion:nonDraggableRegion];
//}
//
//void CocoaCefClientDelegate::consoleMessage(const std::string& message, int level) {
//  @autoreleasepool {
//    [_host onConsoleMessage:[NSString stringWithUTF8String:message.c_str()] level:level];
//  }
//}
//
//void CocoaCefClientDelegate::takeFocus(bool next) {
//
//}
//
//void CocoaCefClientDelegate::processUrlRequest(const std::string &url) {
//  @autoreleasepool {
//    NSString *strUrl = [NSString stringWithUTF8String:url.c_str()];
//    [_host onCocoaCefUrlRequest:strUrl];
//  }
//}
//
//void CocoaCefClientDelegate::processQueryRequest(const std::string &query, const int64_t query_id) {
//  @autoreleasepool {
//    NSString *strQuery = [NSString stringWithUTF8String:query.c_str()];
//    CocoaCefQuery *q = [[CocoaCefQuery alloc] init];
//    q.rid = query_id;
//    q.request = strQuery;
//    [_host onCocoaCefQueryRequest:q];
//  }
//}
//
//void CocoaCefClientDelegate::invokeMethodNotify(int browserId, int frameId, const std::string &method,
//                                                const CefRefPtr<CefListValue> &arguments) {
//  @autoreleasepool {
//    NSString *strMethod = [NSString stringWithUTF8String:method.c_str()];
//    NSMutableArray *argsList = [[NSMutableArray alloc] init];
//
//    // extract the arguments
//    for (int idx = 0; idx < (int)arguments->GetSize(); idx++) {
//      if (CefValueType::VTYPE_NULL == arguments->GetType(idx)) {
//        [argsList addObject:[NSNumber numberWithInt:0]];
//      } else if (CefValueType::VTYPE_BOOL == arguments->GetType(idx)) {
//        [argsList addObject:[NSNumber numberWithBool:arguments->GetBool(idx)]];
//      } else if (CefValueType::VTYPE_INT == arguments->GetType(idx)) {
//        [argsList addObject:[NSNumber numberWithInt:arguments->GetInt(idx)]];
//      } else if (CefValueType::VTYPE_DOUBLE == arguments->GetType(idx)) {
//        [argsList addObject:[NSNumber numberWithDouble:arguments->GetDouble(idx)]];
//      } else if (CefValueType::VTYPE_STRING == arguments->GetType(idx)) {
//        auto v = arguments->GetString(idx).ToString();
//        [argsList addObject:[NSString stringWithUTF8String:v.c_str()]];
//      } else if (CefValueType::VTYPE_BINARY == arguments->GetType(idx)) {
//        auto v = arguments->GetBinary(idx);
//        std::vector<uint8_t> buf(v->GetSize(), 0);
//        v->GetData(buf.data(), buf.size(), 0);
//        [argsList addObject:[NSData dataWithBytes:buf.data() length:buf.size()]];
//      } else {
//      }
//    }
//    [_host onInvokeMethodNotify:browserId FrameId:frameId Method:strMethod Arguements:argsList];
//  }
//}
//
//void CocoaCefClientDelegate::browserIsDestroying() {
//  [_host browserIsDestroying];
//}

