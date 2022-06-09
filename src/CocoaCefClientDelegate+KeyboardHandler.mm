//
//  CocoaCefDelegate.m
//  CocoaCefView
//
//  Created by Sheen Tian on 1/24/21.
//

#import "CocoaCefClientDelegate.h"

#include "CocoaCefView+Internal.h"
#include "CocoaCefQuery+Internal.h"

bool
CocoaCefClientDelegate::onPreKeyEvent(CefRefPtr<CefBrowser> browser,
                                      const CefKeyEvent& event,
                                      CefEventHandle os_event,
                                      bool* is_keyboard_shortcut)
{
  return false;
}

bool
CocoaCefClientDelegate::onKeyEvent(CefRefPtr<CefBrowser> browser, const CefKeyEvent& event, CefEventHandle os_event)
{
  return false;
}
