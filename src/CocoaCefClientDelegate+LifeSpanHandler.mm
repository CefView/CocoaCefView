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
CocoaCefClientDelegate::onBeforePopup(CefRefPtr<CefBrowser>& browser,
                                      int64_t frameId,
                                      const std::string& targetUrl,
                                      const std::string& targetFrameName,
                                      CefLifeSpanHandler::WindowOpenDisposition targetDisposition,
                                      CefWindowInfo& windowInfo,
                                      CefBrowserSettings& settings,
                                      bool& DisableJavascriptAccess)
{
  return false;
}

void
CocoaCefClientDelegate::onAfterCreate(CefRefPtr<CefBrowser>& browser)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    if (browser->IsPopup())
      [cocoaCefView onCefPopupBrowserCreated:browser];
    else
      [cocoaCefView onCefMainBrowserCreated:browser];
  }
}

bool
CocoaCefClientDelegate::doClose(CefRefPtr<CefBrowser> browser)
{  
  return false;
}

void
CocoaCefClientDelegate::OnBeforeClose(CefRefPtr<CefBrowser> browser)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onCefBeforeCloseBrowser:browser];
  }
}
