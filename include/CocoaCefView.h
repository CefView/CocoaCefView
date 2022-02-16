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

- (int)browserId;
- (void)navigateToString:(NSString*)content;
- (void)navigateToUrl:(NSString*)url;
- (bool)browserCanGoBack;
- (bool)browserCanGoForward;
- (void)browserGoBack;
- (void)browserGoForward;
- (bool)browserIsLoading;
- (void)browserReload;
- (void)browserStopLoad;
- (bool)triggerEvent:(CocoaCefEvent*)event;
- (bool)triggerEvent:(CocoaCefEvent*)event inFrame:(int)frameId;
- (bool)broadcastEvent:(CocoaCefEvent*)event;
- (bool)responseCefQuery:(CocoaCefQuery*)query;

- (void)onLoadingStateChanged:(bool)isLoading CanGoBack:(bool)canGoBack CanGoForward:(bool)canGoForward;
- (void)onLoadStart;
- (void)onLoadEnd:(int)httpStatusCode;
- (bool)onLoadError:(int)errorCode ErrorMsg:(NSString*)errorMsg FailedUrl:(NSString*)failedUrl Handled:(bool&)handled;
- (void)onDraggableRegionChanged:(NSBezierPath*)draggableRegion  NonDraggableRegion:(NSBezierPath*)nonDraggableRegion;
- (void)onAddressChanged:(int)frameId url:(NSString*)url;
- (void)onTitleChanged:(NSString*)title;
- (void)onFullscreenModeChanged:(bool)fullscreen;
- (void)onStatusMessage:(NSString*)message;
- (void)onConsoleMessage:(NSString*)message withLevel:(int)level;
- (void)onLoadingProgressChanged:(double)progress;
- (void)onCefQueryRequest:(int)browserId Frame:(int)frameId Query:(CocoaCefQuery*)query;
- (void)onInvokeMethod:(int)browserId Frame:(int)frameId Method:(NSString*)method Arguments:(NSArray*)arguments;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefView_h
