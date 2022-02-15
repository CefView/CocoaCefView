//
//  CocoaCefSetting.mm
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#import <CocoaCefView/CocoaCefSetting.h>

#pragma region cef_headers
#include <include/cef_origin_whitelist.h>
#include <include/internal/cef_types_wrappers.h>
#pragma endregion cef_headers

#import "details/CCefManager.h"

@implementation CocoaCefSetting

+ (nonnull CocoaCefSetting*)defaultInstance {
    static CocoaCefSetting* s_sharedInstance = nil;
    @synchronized (self) {
        if (nil == s_sharedInstance)
            s_sharedInstance = [[self alloc] init];
    }
    return s_sharedInstance;
}

//+ (NSString *)local;
//+ (void)setLocale:(NSString *)locale;
//
//+ (NSString *)userAgent;
//+ (void)setUserAgent:(NSString *)userAgent;
//
//+ (NSString *)cachePath;
//+ (void)setCachePath:(NSString *)cachePath;
//
//+ (NSString *)userDataPath;
//+ (void)setUserDataPath:(NSString *)userDataPath;
//
//+ (NSString *)browserSubProcessPath;
//+ (void)setBrowserSubProcessPath:(NSString *)browserSubProcessPath;
//
//+ (NSString *)resourceDirectoryPath;
//+ (void)setResourceDirectoryPath:(NSString *)resourceDirectoryPath;
//
//+ (NSString *)localesDirectoryPath;
//+ (void)setLocalDirectoryPath:(NSString *)localesDirectoryPath;
//
//+ (NSString *)acceptLanguageList;
//+ (void)setAcceptLanguateList:(NSString *)acceptLanguageList;
//
//+ (bool)persistSessionCookies;
//+ (void)setPersistSessionCookies:(bool)persistSessionCookies;
//
//+ (bool)persistUserPreferences;
//+ (void)setPersistUserPreferences:(bool)persistUserPreferences;
//
//+ (int)remoteDebuggingPort;
//+ (void)setRemoteDebuggingPort:(int)remoteDebuggingPort;
//
//+ (uint32_t)backgroundColor;
//+ (void)setBackgroundColor:(uint32_t)backgroundColor;

+ (bool)addCrossOriginAllowlistEntry:(NSString*)sourceOrigin TargetProtocol:(NSString*)targetProtocol TargetDomain:(NSString*)targetDomain AllowSubDomain:(bool)allowSubdomains {
  CefAddCrossOriginWhitelistEntry(sourceOrigin.UTF8String,
                                  targetProtocol.UTF8String,
                                  targetDomain.UTF8String,
                                  allowSubdomains);
}

@end
