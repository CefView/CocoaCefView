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
CocoaCefClientDelegate::loadingStateChanged(CefRefPtr<CefBrowser>& browser,
                                            bool isLoading,
                                            bool canGoBack,
                                            bool canGoForward)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onLoadingStateChanged:browser->GetIdentifier()
                               IsLoading:isLoading
                               CanGoBack:canGoBack
                            CanGoForward:canGoForward];
  }
}

void
CocoaCefClientDelegate::loadStart(CefRefPtr<CefBrowser>& browser, CefRefPtr<CefFrame>& frame, int transition_type)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onLoadStart:browser->GetIdentifier()
                       FrameId:frame->GetIdentifier()
                   IsMainFrame:frame->IsMain()
                TransitionType:transition_type];
  }
}

void
CocoaCefClientDelegate::loadEnd(CefRefPtr<CefBrowser>& browser, CefRefPtr<CefFrame>& frame, int httpStatusCode)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    [cocoaCefView onLoadEnd:browser->GetIdentifier()
                     FrameId:frame->GetIdentifier()
                 IsMainFrame:frame->IsMain()
                  StatusCode:httpStatusCode];
  }
}

void
CocoaCefClientDelegate::loadError(CefRefPtr<CefBrowser>& browser,
                                  CefRefPtr<CefFrame>& frame,
                                  int errorCode,
                                  const std::string& errorMsg,
                                  const std::string& failedUrl,
                                  bool& handled)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString* msg = [NSString stringWithUTF8String:errorMsg.c_str()];
    NSString* url = [NSString stringWithUTF8String:failedUrl.c_str()];
    [cocoaCefView onLoadError:browser->GetIdentifier()
                       FrameId:frame->GetIdentifier()
                   IsMainFrame:frame->IsMain()
                     ErrorCode:errorCode
                      ErrorMsg:msg
                     FailedUrl:url
                       Handled:handled];
  }
}
