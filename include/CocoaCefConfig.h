//
//  CocoaCefConfig.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#ifndef CocoaCefConfig_h
#define CocoaCefConfig_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// <#Description#>
@interface CocoaCefConfig : NSObject

/// <#Description#>
@property int logLevel;

/// short
@property short remoteDebuggingport;

/// boolean
@property BOOL persistSessionCookies;

/// boolean
@property BOOL persistUserPreferences;

/// <#Description#>
@property NSString* local;

/// <#Description#>
@property NSString* userAgent;

/// <#Description#>
@property NSString* cachePath;

/// <#Description#>
@property NSString* userDataPath;

/// <#Description#>
@property NSString* bridgeObjectName;

/// <#Description#>
@property NSString* acceptLanguageList;

/// <#Description#>
@property NSColor* backgroundColor;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefConfig_h
