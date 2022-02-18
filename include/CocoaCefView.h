//
//  CocoaCefView.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#ifndef CocoaCefView_h
#define CocoaCefView_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CocoaCefView/CocoaCefSetting.h>
#import <CocoaCefView/CocoaCefEvent.h>
#import <CocoaCefView/CocoaCefQuery.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the cef view of CocoaCef
@interface CocoaCefView : NSView

/// <#Description#>
- (int)browserId;

/// <#Description#>
/// @param content <#content description#>
- (void)navigateToString:(NSString*)content;

/// <#Description#>
/// @param url <#url description#>
- (void)navigateToUrl:(NSString*)url;

/// <#Description#>
- (bool)browserCanGoBack;

/// <#Description#>
- (bool)browserCanGoForward;

/// <#Description#>
- (void)browserGoBack;

/// <#Description#>
- (void)browserGoForward;

/// <#Description#>
- (bool)browserIsLoading;

/// <#Description#>
- (void)browserReload;

/// <#Description#>
- (void)browserStopLoad;

/// <#Description#>
/// @param event <#event description#>
- (bool)triggerEvent:(CocoaCefEvent*)event;

/// <#Description#>
/// @param event <#event description#>
/// @param frameId <#frameId description#>
- (bool)triggerEvent:(CocoaCefEvent*)event inFrame:(int)frameId;

/// <#Description#>
/// @param event <#event description#>
- (bool)broadcastEvent:(CocoaCefEvent*)event;

/// <#Description#>
/// @param query <#query description#>
- (bool)responseCefQuery:(CocoaCefQuery*)query;

/// <#Description#>
/// @param isLoading <#isLoading description#>
/// @param canGoBack <#canGoBack description#>
/// @param canGoForward <#canGoForward description#>
- (void)onLoadingStateChanged:(bool)isLoading CanGoBack:(bool)canGoBack CanGoForward:(bool)canGoForward;

/// <#Description#>
- (void)onLoadStart;

/// <#Description#>
/// @param httpStatusCode <#httpStatusCode description#>
- (void)onLoadEnd:(int)httpStatusCode;

/// <#Description#>
/// @param errorCode <#errorCode description#>
/// @param errorMsg <#errorMsg description#>
/// @param failedUrl <#failedUrl description#>
/// @param handled <#handled description#>
- (bool)onLoadError:(int)errorCode ErrorMsg:(NSString*)errorMsg FailedUrl:(NSString*)failedUrl Handled:(bool&)handled;

/// <#Description#>
/// @param draggableRegion <#draggableRegion description#>
/// @param nonDraggableRegion <#nonDraggableRegion description#>
- (void)onDraggableRegionChanged:(NSBezierPath*)draggableRegion  NonDraggableRegion:(NSBezierPath*)nonDraggableRegion;

/// <#Description#>
/// @param frameId <#frameId description#>
/// @param url <#url description#>
- (void)onAddressChanged:(int)frameId url:(NSString*)url;

/// <#Description#>
/// @param title <#title description#>
- (void)onTitleChanged:(NSString*)title;

/// <#Description#>
/// @param fullscreen <#fullscreen description#>
- (void)onFullscreenModeChanged:(bool)fullscreen;

/// <#Description#>
/// @param message <#message description#>
- (void)onStatusMessage:(NSString*)message;

/// <#Description#>
/// @param message <#message description#>
/// @param level <#level description#>
- (void)onConsoleMessage:(NSString*)message withLevel:(int)level;

/// <#Description#>
/// @param progress <#progress description#>
- (void)onLoadingProgressChanged:(double)progress;

/// <#Description#>
/// @param browserId <#browserId description#>
/// @param frameId <#frameId description#>
/// @param query <#query description#>
- (void)onCefQueryRequest:(int)browserId Frame:(int)frameId Query:(CocoaCefQuery*)query;

/// <#Description#>
/// @param browserId <#browserId description#>
/// @param frameId <#frameId description#>
/// @param method <#method description#>
/// @param arguments <#arguments description#>
- (void)onInvokeMethod:(int)browserId Frame:(int)frameId Method:(NSString*)method Arguments:(NSArray*)arguments;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefView_h
