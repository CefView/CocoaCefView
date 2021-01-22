//
//  CocoaCefDelegate.h
//  CocoaCefView
//
//  Created by START-TEST on 1/24/21.
//
#pragma once

#pragma region std_headers
#include <memory>
#pragma endregion std_headers

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

#include <CefViewBrowserDelegate.h>

#include <CocoaCefView/CocoaCefQuery.h>
#include <CocoaCefView/CocoaCefView.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

class CocoaCefDelegate : public CefViewBrowserDelegateInterface {
public:
  CocoaCefDelegate(void *host);
    
  void setCefBrowserWindowHandle(CefWindowHandle win) override;

  void loadingStateChanged(bool isLoading, bool canGoBack, bool canGoForward) override;

  void loadStart() override;

  void loadEnd(int httpStatusCode) override;

  void loadError(int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) override;
  
  void draggableRegionChanged(const std::vector<CefDraggableRegion>& regions) override;
    
  void consoleMessage(const std::string& message, int level) override;
  
  void takeFocus(bool next) override;

  void processUrlRequest(const std::string &url) override;

  void processQueryRequest(const std::string &query, const int64_t query_id) override ;

  void invokeMethodNotify(int browserId, int frameId, const std::string &method,
                          const CefRefPtr<CefListValue> &arguments) override;

  void browserIsDestroying() override;
  
private:
  CocoaCefView *__weak _host;
};

NS_ASSUME_NONNULL_END
