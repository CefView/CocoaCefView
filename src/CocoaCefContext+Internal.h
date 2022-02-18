//
//  CocoaCefContext+Internal.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <CocoaCefView/CocoaCefContext.h>

#include <memory>

#include <include/cef_app.h>

#include <CefViewBrowserClient.h>
#include <CefViewBrowserClientDelegate.h>

#include "CocoaCefClientDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCefContext ()

@property CefRefPtr<CefViewBrowserClient> cefBrowserClient;

@property std::shared_ptr<CocoaCefClientDelegate> cefBrowserClientDelegate;

- (bool)initCefContext:(CocoaCefConfig*)config;

- (void)runCefMessageLoop;

- (void)quitCefMessageLoop;

- (void)uninitCefContext;

- (void)closeAllBrowsers;

- (void)scheduleCefLoopWork:(int64_t)delayMs;

@end

NS_ASSUME_NONNULL_END
