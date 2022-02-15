//
//  CocoaCefDelegate.m
//  CocoaCefView
//
//  Created by START-TEST on 1/24/21.
//

#import "CocoaCefClientDelegate.h"

#include "CocoaCefView+Internal.h"
#include "CocoaCefQuery+Internal.h"

CocoaCefClientDelegate::CocoaCefClientDelegate(void *host) : _host((__bridge CocoaCefView *)host) {}

void CocoaCefClientDelegate::setBrowserWindowId(CefWindowHandle /* win */) {
    // currently not use
}

void CocoaCefClientDelegate::loadingStateChanged(bool isLoading, bool canGoBack, bool canGoForward) {
  [_host onLoadingStateChanged:isLoading CanGoBack:canGoBack CanGoForward:canGoBack];
}

void CocoaCefClientDelegate::loadStart() { [_host onLoadStart]; }

void CocoaCefClientDelegate::loadEnd(int httpStatusCode) { [_host onLoadEnd:httpStatusCode]; }

void CocoaCefClientDelegate::loadError(int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) {
  @autoreleasepool {
    NSString *strMsg = [NSString stringWithUTF8String:errorMsg.c_str()];
    NSString *strUrl = [NSString stringWithUTF8String:failedUrl.c_str()];
    handled = [_host onLoadError:errorCode ErrorMsg:strMsg FailedUrl:strUrl];
  }
}

void CocoaCefClientDelegate::draggableRegionChanged(const std::vector<CefDraggableRegion>& regions) {
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
  [_host draggableRegionChanged:draggableRegion NonDraggableRegion:nonDraggableRegion];
}

void CocoaCefClientDelegate::consoleMessage(const std::string& message, int level) {
  @autoreleasepool {
    [_host onConsoleMessage:[NSString stringWithUTF8String:message.c_str()] level:level];
  }
}

void CocoaCefClientDelegate::takeFocus(bool next) {

}

void CocoaCefClientDelegate::processUrlRequest(const std::string &url) {
@autoreleasepool {
  NSString *strUrl = [NSString stringWithUTF8String:url.c_str()];
  [_host onCocoaCefUrlRequest:strUrl];
}
}

void CocoaCefClientDelegate::processQueryRequest(const std::string &query, const int64_t query_id) {
  @autoreleasepool {
    NSString *strQuery = [NSString stringWithUTF8String:query.c_str()];
    CocoaCefQuery *q = [[CocoaCefQuery alloc] init];
    q.rid = query_id;
    q.request = strQuery;
    [_host onCocoaCefQueryRequest:q];
  }
}

void CocoaCefClientDelegate::invokeMethodNotify(int browserId, int frameId, const std::string &method,
                      const CefRefPtr<CefListValue> &arguments) {
  @autoreleasepool {
    NSString *strMethod = [NSString stringWithUTF8String:method.c_str()];
    NSMutableArray *argsList = [[NSMutableArray alloc] init];

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
    [_host onInvokeMethodNotify:browserId FrameId:frameId Method:strMethod Arguements:argsList];
  }
}

void CocoaCefClientDelegate::browserIsDestroying() {
  [_host browserIsDestroying];
}

