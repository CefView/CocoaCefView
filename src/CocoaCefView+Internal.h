//
//  CocoaCefView.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#import <CocoaCefView/CocoaCefView.h>

#import "CocoaCefContext+Internal.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents the cef view of CocoaCef
@interface
CocoaCefView ()

@property std::shared_ptr<CocoaCefClientDelegate> cefBrowserClientDelegate;

+ (void)destroyAllBrowsers;

- (void)createCefBrowser:(CocoaCefSetting*)settings;

- (void)destroyCefBrowser;

- (void)onCefMainBrowserCreated:(CefRefPtr<CefBrowser>&)browser;

- (void)onCefPopupBrowserCreated:(CefRefPtr<CefBrowser>&)browser;

- (void)onCefBeforeCloseBrowser:(CefRefPtr<CefBrowser>&)browser;

- (void)setCefWindowFocus:(bool)focused;

- (void)onCefWindowLostTabFocus:(bool)next;

- (void)onCefWindowGotFocus;

@end

NS_ASSUME_NONNULL_END
