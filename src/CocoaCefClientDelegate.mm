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

void CocoaCefClientDelegate::insertBrowserViewMapping(CefRefPtr<CefBrowser>& browser, CocoaCefView* view){
  auto bid = browser->GetIdentifier();
  view_map_[bid] = view;  
}

void CocoaCefClientDelegate::removeBrowserViewMapping(CefRefPtr<CefBrowser>& browser){
  auto id = browser->GetIdentifier();
  view_map_.erase(id);  
}

void CocoaCefClientDelegate::loadingStateChanged(CefRefPtr<CefBrowser> &browser, bool isLoading, bool canGoBack, bool canGoForward) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    [p onLoadingStateChanged:isLoading CanGoBack:canGoBack CanGoForward:canGoForward];
  }
}


void CocoaCefClientDelegate::loadStart(CefRefPtr<CefBrowser> &browser) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    [p onLoadStart];
  }
}


void CocoaCefClientDelegate::loadEnd(CefRefPtr<CefBrowser> &browser, int httpStatusCode) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    [p onLoadEnd:httpStatusCode];
  }
}


void CocoaCefClientDelegate::loadError(CefRefPtr<CefBrowser> &browser, int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString* msg = [NSString stringWithUTF8String:errorMsg.c_str()];
    NSString* url = [NSString stringWithUTF8String:failedUrl.c_str()];
    [p onLoadError:errorCode ErrorMsg:msg FailedUrl:url Handled:handled];
  }
}


void CocoaCefClientDelegate::draggableRegionChanged(CefRefPtr<CefBrowser> &browser, const std::vector<CefDraggableRegion> &regions) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSBezierPath* draggableRegion = [NSBezierPath bezierPath];
    NSBezierPath* nonDraggableRegion = [NSBezierPath bezierPath];
    for (auto it = regions.begin(); it != regions.end(); ++it) {
      NSRect rc = {
        static_cast<CGFloat>(it->bounds.x),
        static_cast<CGFloat>(it->bounds.y),
        static_cast<CGFloat>(it->bounds.width),
        static_cast<CGFloat>(it->bounds.height)
      };
      if (it->draggable) {
        [draggableRegion appendBezierPathWithRect:rc];
      } else {
        [nonDraggableRegion appendBezierPathWithRect:rc];
      }
    }
    [draggableRegion closePath];
    [nonDraggableRegion closePath];
    [p onDraggableRegionChanged:draggableRegion NonDraggableRegion:nonDraggableRegion];
  }
}


void CocoaCefClientDelegate::addressChanged(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &url) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString* u = [NSString stringWithUTF8String:url.c_str()];
    [p onAddressChanged:frameId url:u];
  }
}


void CocoaCefClientDelegate::titleChanged(CefRefPtr<CefBrowser> &browser, const std::string &title) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString* t = [NSString stringWithUTF8String:title.c_str()];
    [p onTitleChanged:t];
  }
}


bool CocoaCefClientDelegate::tooltipMessage(CefRefPtr<CefBrowser> &browser, const std::string &text) { 
  CocoaCefView* p = take(browser);
  return false;
}


void CocoaCefClientDelegate::fullscreenModeChanged(CefRefPtr<CefBrowser> &browser, bool fullscreen) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    [p onFullscreenModeChanged:fullscreen];
  }
}


void CocoaCefClientDelegate::statusMessage(CefRefPtr<CefBrowser> &browser, const std::string &value) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString* msg = [NSString stringWithUTF8String:value.c_str()];
    [p onStatusMessage:msg];
  }
}


void CocoaCefClientDelegate::loadingProgressChanged(CefRefPtr<CefBrowser> &browser, double progress) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    [p onLoadingProgressChanged:progress];
  }
}


void CocoaCefClientDelegate::consoleMessage(CefRefPtr<CefBrowser> &browser, const std::string &message, int level) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString* msg = [NSString stringWithUTF8String:message.c_str()];
    [p onConsoleMessage:msg withLevel:level];
  }
}


bool CocoaCefClientDelegate::cursorChanged(CefRefPtr<CefBrowser> browser, void * _Nonnull cursor, cef_cursor_type_t type, const CefCursorInfo &custom_cursor_info) { 
  return false;
}


void CocoaCefClientDelegate::takeFocus(CefRefPtr<CefBrowser> &browser, bool next) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
  }
}


bool CocoaCefClientDelegate::setFocus(CefRefPtr<CefBrowser> &browser) {
  CocoaCefView* p = take(browser);
  @autoreleasepool {
  }
  return false;
}


void CocoaCefClientDelegate::gotFocus(CefRefPtr<CefBrowser> &browser) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
  }
}


void CocoaCefClientDelegate::processQueryRequest(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &query, const int64_t query_id) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString* request = [NSString stringWithUTF8String:query.c_str()];
    CocoaCefQuery* q = [CocoaCefQuery queryWithRequest:request AndId:query_id];
    [p onCefQueryRequest:browser->GetIdentifier() Frame:frameId Query:q];
  }
}


void CocoaCefClientDelegate::invokeMethodNotify(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &method, const CefRefPtr<CefListValue> &arguments) { 
  CocoaCefView* p = take(browser);
  @autoreleasepool {
    NSString *strMethod = [NSString stringWithUTF8String:method.c_str()];

    // extract the arguments
    NSMutableArray *argsList = [[NSMutableArray alloc] init];
    for (int i = 0; i < arguments->GetSize(); i++) {
      NSValue* oV;
      auto cV = arguments->GetValue(i);
      ValueConvertor::CefValueToNSValue(&oV, cV);
      [argsList addObject:oV];
    }
    
    // extract the arguments
    for (int idx = 0; idx < (int)arguments->GetSize(); idx++) {
      if (CefValueType::VTYPE_NULL == arguments->GetType(idx)) {
        [argsList addObject:[NSNumber numberWithInt:0]];
      } else if (CefValueType::VTYPE_BOOL == arguments->GetType(idx)) {
        [argsList addObject:[NSNumber numberWithBool:arguments->GetBool(idx)]];
      } else if (CefValueType::VTYPE_INT == arguments->GetType(idx)) {
        [argsList addObject:[NSNumber numberWithInt:arguments->GetInt(idx)]];
      } else if (CefValueType::VTYPE_DOUBLE == arguments->GetType(idx)) {
        [argsList addObject:[NSNumber numberWithDouble:arguments->GetDouble(idx)]];
      } else if (CefValueType::VTYPE_STRING == arguments->GetType(idx)) {
        auto v = arguments->GetString(idx).ToString();
        [argsList addObject:[NSString stringWithUTF8String:v.c_str()]];
      } else if (CefValueType::VTYPE_BINARY == arguments->GetType(idx)) {
        auto v = arguments->GetBinary(idx);
        std::vector<uint8_t> buf(v->GetSize(), 0);
        v->GetData(buf.data(), buf.size(), 0);
        [argsList addObject:[NSData dataWithBytes:buf.data() length:buf.size()]];
      } else {
      }
    }
    [p onInvokeMethod:browser->GetIdentifier() Frame:frameId Method:strMethod Arguments:argsList];
  }
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
