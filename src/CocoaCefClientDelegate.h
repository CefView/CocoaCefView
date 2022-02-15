//
//  CocoaCefDelegate.h
//  CocoaCefView
//
//  Created by START-TEST on 1/24/21.
//

#import <Foundation/Foundation.h>

#pragma region std_headers
#include <memory>
#pragma endregion std_headers

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

#include <CefViewBrowserClientDelegate.h>

#include <CocoaCefView/CocoaCefQuery.h>
#include <CocoaCefView/CocoaCefView.h>

NS_ASSUME_NONNULL_BEGIN

class CocoaCefClientDelegate : public CefViewBrowserClientDelegateInterface {
public:
  CocoaCefClientDelegate(void *host);
  
  //  void setBrowserWindowId(CefWindowHandle win) override;
  //
  //  void loadingStateChanged(bool isLoading, bool canGoBack, bool canGoForward) override;
  //
  //  void loadStart() override;
  //
  //  void loadEnd(int httpStatusCode) override;
  //
  //  void loadError(int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) override;
  //
  //  void draggableRegionChanged(const std::vector<CefDraggableRegion>& regions) override;
  //
  //  void consoleMessage(const std::string& message, int level) override;
  //
  //  void takeFocus(bool next) override;
  //
  //  void processQueryRequest(const std::string &query, const int64_t query_id) override ;
  //
  //  void invokeMethodNotify(int browserId, int frameId, const std::string &method,
  //                          const CefRefPtr<CefListValue> &arguments) override;
  //
  //  void browserIsDestroying() override;
  
  void loadingStateChanged(CefRefPtr<CefBrowser> &browser, bool isLoading, bool canGoBack, bool canGoForward) override;
  
  void loadStart(CefRefPtr<CefBrowser> &browser) override;
  
  void loadEnd(CefRefPtr<CefBrowser> &browser, int httpStatusCode) override;
  
  void loadError(CefRefPtr<CefBrowser> &browser, int errorCode, const std::string &errorMsg, const std::string &failedUrl, bool &handled) override;
  
  void draggableRegionChanged(CefRefPtr<CefBrowser> &browser, const std::vector<CefDraggableRegion> &regions) override;
  
  void addressChanged(CefRefPtr<CefBrowser> &browser, int frameId, const CefString &url) override;
  
  void titleChanged(CefRefPtr<CefBrowser> &browser, const CefString &title) override;
  
  bool tooltipMessage(CefRefPtr<CefBrowser> &browser, const CefString &text) override;
  
  void fullscreenModeChanged(CefRefPtr<CefBrowser> &browser, bool fullscreen) override;
  
  void statusMessage(CefRefPtr<CefBrowser> &browser, const CefString &value) override;
  
  void loadingProgressChanged(CefRefPtr<CefBrowser> &browser, double progress) override;
  
  void consoleMessage(CefRefPtr<CefBrowser> &browser, const std::string &message, int level) override;
  
  bool cursorChanged(CefRefPtr<CefBrowser> browser, void *cursor, cef_cursor_type_t type, const CefCursorInfo &custom_cursor_info) override;
  
  void takeFocus(CefRefPtr<CefBrowser> &browser, bool next) override;
  
  bool setFocus(CefRefPtr<CefBrowser> &browser) override;
  
  void gotFocus(CefRefPtr<CefBrowser> &browser) override;
  
  void processUrlRequest(const std::string &url) override {};
  
  void processQueryRequest(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &query, const int64_t query_id) override;
  
  void invokeMethodNotify(CefRefPtr<CefBrowser> &browser, int frameId, const std::string &method, const CefRefPtr<CefListValue> &arguments) override;
  
  bool GetRootScreenRect(CefRefPtr<CefBrowser> browser, CefRect &rect) override;
  
  void GetViewRect(CefRefPtr<CefBrowser> browser, CefRect &rect) override;
  
  bool GetScreenPoint(CefRefPtr<CefBrowser> browser, int viewX, int viewY, int &screenX, int &screenY) override;
  
  bool GetScreenInfo(CefRefPtr<CefBrowser> browser, CefScreenInfo &screen_info) override;
  
  void OnPopupShow(CefRefPtr<CefBrowser> browser, bool show) override;
  
  void OnPopupSize(CefRefPtr<CefBrowser> browser, const CefRect &rect) override;
  
  void OnPaint(CefRefPtr<CefBrowser> browser, CefRenderHandler::PaintElementType type, const CefRenderHandler::RectList &dirtyRects, const void *buffer, int width, int height) override;
  
private:
  CocoaCefView *__weak _host;
};

NS_ASSUME_NONNULL_END
