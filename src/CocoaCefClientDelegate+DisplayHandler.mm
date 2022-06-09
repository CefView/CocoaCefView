//
//  CocoaCefDelegate.m
//  CocoaCefView
//
//  Created by Sheen Tian on 1/24/21.
//

#import "CocoaCefClientDelegate.h"

#include "CocoaCefView+Internal.h"
#include "CocoaCefQuery+Internal.h"

void
CocoaCefClientDelegate::draggableRegionChanged(CefRefPtr<CefBrowser>& browser,
                                               const std::vector<CefDraggableRegion>& regions)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSBezierPath* draggableRegion = [NSBezierPath bezierPath];
    NSBezierPath* nonDraggableRegion = [NSBezierPath bezierPath];
    for (auto it = regions.begin(); it != regions.end(); ++it) {
      NSRect rc = { static_cast<CGFloat>(it->bounds.x),
                    static_cast<CGFloat>(it->bounds.y),
                    static_cast<CGFloat>(it->bounds.width),
                    static_cast<CGFloat>(it->bounds.height) };
      if (it->draggable) {
        [draggableRegion appendBezierPathWithRect:rc];
      } else {
        [nonDraggableRegion appendBezierPathWithRect:rc];
      }
    }
    [draggableRegion closePath];
    [nonDraggableRegion closePath];
    [cocoaCefView onDraggableRegionChanged:draggableRegion NonDraggableRegion:nonDraggableRegion];
  }
}

void
CocoaCefClientDelegate::addressChanged(CefRefPtr<CefBrowser>& browser, int64_t frameId, const std::string& url)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString* u = [NSString stringWithUTF8String:url.c_str()];
    [cocoaCefView onAddressChanged:frameId url:u];
  }
}

void
CocoaCefClientDelegate::titleChanged(CefRefPtr<CefBrowser>& browser, const std::string& title)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString* t = [NSString stringWithUTF8String:title.c_str()];
    [cocoaCefView onTitleChanged:t];
  }
}

void
CocoaCefClientDelegate::faviconURLChanged(CefRefPtr<CefBrowser> browser, const std::vector<CefString>& icon_urls)
{
}

void
CocoaCefClientDelegate::faviconChanged(CefRefPtr<CefImage> image)
{
}

void
CocoaCefClientDelegate::fullscreenModeChanged(CefRefPtr<CefBrowser>& browser, bool fullscreen)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onFullscreenModeChanged:fullscreen];
  }
}

bool
CocoaCefClientDelegate::tooltipMessage(CefRefPtr<CefBrowser>& browser, const std::string& text)
{
  return false;
}

void
CocoaCefClientDelegate::statusMessage(CefRefPtr<CefBrowser>& browser, const std::string& value)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString* msg = [NSString stringWithUTF8String:value.c_str()];
    [cocoaCefView onStatusMessage:msg];
  }
}

void
CocoaCefClientDelegate::consoleMessage(CefRefPtr<CefBrowser>& browser, const std::string& message, int level)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString* msg = [NSString stringWithUTF8String:message.c_str()];
    [cocoaCefView onConsoleMessage:msg withLevel:level];
  }
}

void
CocoaCefClientDelegate::loadingProgressChanged(CefRefPtr<CefBrowser>& browser, double progress)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onLoadingProgressChanged:progress];
  }
}

bool
CocoaCefClientDelegate::cursorChanged(CefRefPtr<CefBrowser> browser,
                                      CefCursorHandle cursor,
                                      cef_cursor_type_t type,
                                      const CefCursorInfo& custom_cursor_info)
{
  return false;
};
