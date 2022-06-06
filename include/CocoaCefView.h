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

#import <CocoaCefView/CocoaCefConfig.h>
#import <CocoaCefView/CocoaCefContext.h>
#import <CocoaCefView/CocoaCefEvent.h>
#import <CocoaCefView/CocoaCefQuery.h>
#import <CocoaCefView/CocoaCefSetting.h>
#import <CocoaCefView/CocoaCefView.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the cef view of CocoaCef
@interface CocoaCefView : NSView

/// <#Description#>
/// @param frameRect <#frameRect description#>
/// @param settings <#settings description#>
- (instancetype)initWithFrame:(NSRect)frameRect AndSettings:(CocoaCefSetting*)settings;

/// <#Description#>
/// @param coder <#coder description#>
/// @param settings <#settings description#>
- (instancetype)initWithCoder:(NSCoder*)coder AndSettings:(CocoaCefSetting*)settings;

/// <#Description#>
/// @param path <#path description#>
/// @param url <#url description#>
/// @param priority <#priority description#>
- (void)addLocalFolderResource:(NSString*)path forUrl:(NSString*)url withPriority:(int)priority;

/// <#Description#>
/// @param path <#path description#>
/// @param url <#url description#>
/// @param pwd <#pwd description#>
- (void)addLocalArchiveResource:(NSString*)path
                         forUrl:(NSString*)url
                   withPassword:(NSString*)pwd
                   withPriority:(int)priority;

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
- (bool)triggerEvent:(CocoaCefEvent*)event InFrame:(long long)frameId;

/// <#Description#>
/// @param event <#event description#>
- (bool)broadcastEvent:(CocoaCefEvent*)event;

/// <#Description#>
/// @param query <#query description#>
- (bool)responseCefQuery:(CocoaCefQuery*)query;

/// <#Description#>
/// @param code <#code description#>
/// @param frameId <#frameId description#>
/// @param url <#url description#>
/// @param lineNum <#lineNum description#>
- (bool)executeJavascript:(NSString*)code InFrame:(long long)frameId WithUrl:(NSString*)url StartAt:(int)lineNum;

/// <#Description#>
/// @param name <#name description#>
/// @param value <#value description#>
/// @param error <#error description#>
- (bool)setPreference:(NSString*)name withValue:(NSData*)value onError:(NSString*)error;

/// <#Description#>
/// @param isLoading <#isLoading description#>
/// @param canGoBack <#canGoBack description#>
/// @param canGoForward <#canGoForward description#>
- (void)onLoadingStateChanged:(int)browserId
                    IsLoading:(bool)isLoading
                    CanGoBack:(bool)canGoBack
                 CanGoForward:(bool)canGoForward;

/// <#Description#>
- (void)onLoadStart:(int)browserId
            FrameId:(long long)frameId
        IsMainFrame:(bool)isMainFrame
     TransitionType:(int)transitionType;

/// <#Description#>
/// @param httpStatusCode <#httpStatusCode description#>
- (void)onLoadEnd:(int)browserId
          FrameId:(long long)frameId
      IsMainFrame:(bool)isMainFrame
       StatusCode:(int)httpStatusCode;

/// <#Description#>
/// @param errorCode <#errorCode description#>
/// @param errorMsg <#errorMsg description#>
/// @param failedUrl <#failedUrl description#>
/// @param handled <#handled description#>
- (bool)onLoadError:(int)browserId
            FrameId:(long long)frameId
        IsMainFrame:(bool)isMainFrame
          ErrorCode:(int)errorCode
           ErrorMsg:(NSString*)errorMsg
          FailedUrl:(NSString*)failedUrl
            Handled:(bool&)handled;

/// <#Description#>
/// @param draggableRegion <#draggableRegion description#>
/// @param nonDraggableRegion <#nonDraggableRegion description#>
- (void)onDraggableRegionChanged:(NSBezierPath*)draggableRegion NonDraggableRegion:(NSBezierPath*)nonDraggableRegion;

/// <#Description#>
/// @param frameId <#frameId description#>
/// @param url <#url description#>
- (void)onAddressChanged:(long long)frameId url:(NSString*)url;

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
- (void)onCefQueryRequest:(int)browserId Frame:(long long)frameId Query:(CocoaCefQuery*)query;

/// <#Description#>
/// @param browserId <#browserId description#>
/// @param frameId <#frameId description#>
/// @param method <#method description#>
/// @param arguments <#arguments description#>
- (void)onInvokeMethod:(int)browserId Frame:(long long)frameId Method:(NSString*)method Arguments:(NSArray*)arguments;

/// <#Description#>
/// @param browserId <#browserId description#>
/// @param frameId <#frameId description#>
/// @param context <#context description#>
/// @param result <#result description#>
- (void)onReportJavascriptResult:(int)browserId
                           Frame:(long long)frameId
                         Context:(long long)context
                          Result:(NSObject*)result;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefView_h
