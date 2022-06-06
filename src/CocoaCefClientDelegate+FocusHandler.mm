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
CocoaCefClientDelegate::takeFocus(CefRefPtr<CefBrowser>& browser, bool next)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onCefWindowLostTabFocus:next];
  }
}

bool
CocoaCefClientDelegate::setFocus(CefRefPtr<CefBrowser>& browser)
{
  return false;
}

void
CocoaCefClientDelegate::gotFocus(CefRefPtr<CefBrowser>& browser)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onCefWindowGotFocus];
  }
}
