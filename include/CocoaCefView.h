//
//  CocoaCefView.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#ifndef CocoaCefView_h
#define CocoaCefView_h

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import <CocoaCefView/CocoaCefEvent.h>
#import <CocoaCefView/CocoaCefSetting.h>
#import <CocoaCefView/CocoaCefQuery.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the cef view of CocoaCef
@interface CocoaCefView : NSView

#pragma mark-- Browser Event Callbacks

/// Gets called when laoding status changed
/// @param isLoading Indicates whether the browser is loding
/// @param canGoBack Indicates whethter the browser can go back
/// @param canGoForward Indicates whether the browser can go forward
- (void)onLoadingStateChanged:(bool)isLoading CanGoBack:(bool)canGoBack CanGoForward:(bool)canGoForward;

/// Gets called when the loading stats
- (void)onLoadStart;

/// Gets called when the loading ends
/// @param httpStatusCode The status code of the response
- (void)onLoadEnd:(int)httpStatusCode;

/// Gets called when load failed
/// @param errorCode The error code
/// @param errorMsg The error message
/// @param failedUrl The failed url
- (bool)onLoadError:(int)errorCode ErrorMsg:(NSString *)errorMsg FailedUrl:(NSString *)failedUrl;

/// Gets called when CocoaCef url request coming
/// @param url The requested url
- (void)onCocoaCefUrlRequest:(NSString *)url;

/// Gets called when CocoaCefQuery coming
/// @param query The query
- (void)onCocoaCefQueryRequest:(CocoaCefQuery *)query;

/// Gets called when invoking method notification coming
/// @param browserId The browser id
/// @param frameId The frame id
/// @param method The method
/// @param arguments The argument list
- (void)onInvokeMethodNotify:(int)browserId
                     FrameId:(int)frameId
                      Method:(NSString *)method
                  Arguements:(NSArray *)arguments;

/// Gets called on console message
/// @param message The message
- (void)onConsoleMessage:(NSString*)message level:(int)level;

#pragma mark-- Browser Control Methods

/// Adds a local folder as resoruce provider for specifed url prefix
/// @param path Local file folder path
/// @param url The url prefix
- (void)addLocalFolderResource:(NSString *)path forUrl:(NSString *)url;


/// Adds a archive path as resoruce provider for specifed url prefix
/// @param path archive file folder path
/// @param url The url prefix
/// @param password archive password
- (void)addArchiveResource:(NSString *)path forUrl:(NSString *)url password:(NSString *)password;

/// Adds cookie for url.
/// @param name The cookie name
/// @param value The cookie value
/// @param domain The cookie domain
/// @param url The url
- (bool)addCookie:(NSString*)name withValue:(NSString*)value ofDomain:(NSString*)domain forUrl:(NSString*)url;

/// Navigates to the content
/// @param content The content in string format
- (void)navigateToString:(NSString *)content;

/// Navigates to the url
/// @param url The url
- (void)navigateToUrl:(NSString *)url;

/// Checks whether the browser can go back
- (bool)browserCanGoBack;

/// Makes the browser go back
- (void)browserGoBack;

/// Checks whether the browser can go forward
- (bool)browserCanGoForward;

/// Makes the browser go forward
- (void)browserGoForward;

/// Checks whether the browser is loading
- (bool)browserIsLoading;

/// Reloads the page
- (void)browserReload;

/// Stops the loading
- (void)browserStopLoad;

/// Triggers the event to dedicated browser frame
/// @param event The event
/// @param frameId The frame id
- (bool)triggerEvent:(CocoaCefEvent *)event inFrame:(int)frameId;

/// Broadcasts the event to all browser frames
/// @param event The event
- (bool)broadcastEvent:(CocoaCefEvent *)event;

/// Responses the CocoaCefQuery
/// @param query The query
- (bool)responseCefQuery:(CocoaCefQuery *)query;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefView_h
