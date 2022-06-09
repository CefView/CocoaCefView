//
//  CocoaCefConfig.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#ifndef CocoaCefConfig_h
#define CocoaCefConfig_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// <summary>
/// Represents the log severity
/// </summary>
typedef NS_ENUM(NSUInteger, LogLevel) {
  /// Default logging (currently INFO logging)
  kLogSeverityDefault,

  /// Verbose logging
  kLogSeverityVerbose,

  /// DEBUG logging
  kLogSeverityDebug,

  /// INFO logging
  kLogSeverityInfo,

  /// WARNING logging
  kLogSeverityWarnning,

  /// ERROR logging
  kLogSeverityError,

  /// FATAL logging
  kLogSeverityFatal,

  /// Disable logging to file for all messages, and to stderr for messages with severity less than FATAL
  kLogSeverityDisable = 99
};

/// <#Description#>
@interface CocoaCefConfig : NSObject

/// <#Description#>
@property NSUInteger logLevel;

/// short
@property NSUInteger remoteDebuggingPort;

/// boolean
@property BOOL persistSessionCookies;

/// boolean
@property BOOL persistUserPreferences;

/// <#Description#>
@property NSString* locale;

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

/// <#Description#>
/// @param smitch <#smitch description#>
- (void)addCommandLineSwitch:(NSString*)smitch;

/// <#Description#>
/// @param smitch <#smitch description#>
/// @param value <#value description#>
- (void)addCommandLineSwitch:(NSString*)smitch WithValue:(NSString*)value;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefConfig_h
