//
//  CocoaCefDelegate.h
//  CocoaCefView
//
//  Created by Sheen Tian on 1/24/21.
//

#import <Foundation/Foundation.h>

#pragma region std_headers
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
#pragma endregion std_headers

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

#include <CefViewBrowserClientDelegate.h>

#include <CocoaCefView/CocoaCefQuery.h>
#include <CocoaCefView/CocoaCefView.h>

NS_ASSUME_NONNULL_BEGIN

class CocoaCefClientDelegate : public CefViewBrowserClientDelegateInterface
{
private:
  CocoaCefView* __weak _cocoaCefView;

public:
  CocoaCefClientDelegate(CocoaCefView* cocoaCefView);

public:
  virtual void processUrlRequest(const std::string& url) override;

  virtual void processQueryRequest(CefRefPtr<CefBrowser>& browser,
                                   int64_t frameId,
                                   const std::string& query,
                                   const int64_t query_id) override;

  virtual void focusedEditableNodeChanged(CefRefPtr<CefBrowser>& browser,
                                          int64_t frameId,
                                          bool focusOnEditableNode) override;

  virtual void invokeMethodNotify(CefRefPtr<CefBrowser>& browser,
                                  int64_t frameId,
                                  const std::string& method,
                                  const CefRefPtr<CefListValue>& arguments) override;
  virtual void reportJSResult(CefRefPtr<CefBrowser>& browser,
                              int64_t frameId,
                              int64_t contextId,
                              const CefRefPtr<CefValue>& result) override;
  // CefContextMenuHandler
  virtual void onBeforeContextMenu(CefRefPtr<CefBrowser> browser,
                                   CefRefPtr<CefFrame> frame,
                                   CefRefPtr<CefContextMenuParams> params,
                                   CefRefPtr<CefMenuModel> model) override;

  virtual bool onRunContextMenu(CefRefPtr<CefBrowser> browser,
                                CefRefPtr<CefFrame> frame,
                                CefRefPtr<CefContextMenuParams> params,
                                CefRefPtr<CefMenuModel> model,
                                CefRefPtr<CefRunContextMenuCallback> callback) override;

  virtual bool onContextMenuCommand(CefRefPtr<CefBrowser> browser,
                                    CefRefPtr<CefFrame> frame,
                                    CefRefPtr<CefContextMenuParams> params,
                                    int command_id,
                                    CefContextMenuHandler::EventFlags event_flags) override;

  virtual void onContextMenuDismissed(CefRefPtr<CefBrowser> browser, CefRefPtr<CefFrame> frame) override;

  // LifSpanHandler
  virtual bool onBeforePopup(CefRefPtr<CefBrowser>& browser,
                             int64_t frameId,
                             const std::string& targetUrl,
                             const std::string& targetFrameName,
                             CefLifeSpanHandler::WindowOpenDisposition targetDisposition,
                             CefWindowInfo& windowInfo,
                             CefBrowserSettings& settings,
                             bool& DisableJavascriptAccess) override;
  virtual void onAfterCreate(CefRefPtr<CefBrowser>& browser) override;
  virtual bool doClose(CefRefPtr<CefBrowser> browser) override;
  virtual void OnBeforeClose(CefRefPtr<CefBrowser> browser) override;

  // LoadHandler
  virtual void loadingStateChanged(CefRefPtr<CefBrowser>& browser,
                                   bool isLoading,
                                   bool canGoBack,
                                   bool canGoForward) override;
  virtual void loadStart(CefRefPtr<CefBrowser>& browser, CefRefPtr<CefFrame>& frame, int transition_type) override;
  virtual void loadEnd(CefRefPtr<CefBrowser>& browser, CefRefPtr<CefFrame>& frame, int httpStatusCode) override;
  virtual void loadError(CefRefPtr<CefBrowser>& browser,
                         CefRefPtr<CefFrame>& frame,
                         int errorCode,
                         const std::string& errorMsg,
                         const std::string& failedUrl,
                         bool& handled) override;

  // DisplayHandler
  virtual void draggableRegionChanged(CefRefPtr<CefBrowser>& browser,
                                      const std::vector<CefDraggableRegion>& regions) override;
  virtual void addressChanged(CefRefPtr<CefBrowser>& browser, int64_t frameId, const std::string& url) override;
  virtual void titleChanged(CefRefPtr<CefBrowser>& browser, const std::string& title) override;
  virtual void faviconURLChanged(CefRefPtr<CefBrowser> browser, const std::vector<CefString>& icon_urls) override;
  virtual void faviconChanged(CefRefPtr<CefImage> image) override;
  virtual void fullscreenModeChanged(CefRefPtr<CefBrowser>& browser, bool fullscreen) override;
  virtual bool tooltipMessage(CefRefPtr<CefBrowser>& browser, const std::string& text) override;
  virtual void statusMessage(CefRefPtr<CefBrowser>& browser, const std::string& value) override;
  virtual void consoleMessage(CefRefPtr<CefBrowser>& browser, const std::string& message, int level) override;
  virtual void loadingProgressChanged(CefRefPtr<CefBrowser>& browser, double progress) override;
  virtual bool cursorChanged(CefRefPtr<CefBrowser> browser,
                             CefCursorHandle cursor,
                             cef_cursor_type_t type,
                             const CefCursorInfo& custom_cursor_info) override;

  // KeyboardHandler
  virtual bool onPreKeyEvent(CefRefPtr<CefBrowser> browser,
                             const CefKeyEvent& event,
                             CefEventHandle os_event,
                             bool* is_keyboard_shortcut) override;
  virtual bool onKeyEvent(CefRefPtr<CefBrowser> browser, const CefKeyEvent& event, CefEventHandle os_event) override;

  // FocusHandler
  virtual void takeFocus(CefRefPtr<CefBrowser>& browser, bool next) override;
  virtual bool setFocus(CefRefPtr<CefBrowser>& browser) override;
  virtual void gotFocus(CefRefPtr<CefBrowser>& browser) override;
};

NS_ASSUME_NONNULL_END
