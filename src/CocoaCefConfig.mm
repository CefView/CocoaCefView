//
//  CocoaCefConfig.mm
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <CocoaCefView/CocoaCefConfig.h>

#import "CocoaCefConfig+Internal.h"

@implementation CocoaCefConfig

- (void)copyToCefSettings:(CefSettings&)settings {
  if ([_userAgent length])
    CefString(&settings.user_agent) = _userAgent.UTF8String;

  if ([_cachePath length])
    CefString(&settings.cache_path) = _cachePath.UTF8String;

  if ([_userDataPath length])
    CefString(&settings.user_data_path) = _userDataPath.UTF8String;

  if ([_locale length])
    CefString(&settings.locale) = _locale.UTF8String;

  if ([_acceptLanguageList length])
    CefString(&settings.accept_language_list) = _acceptLanguageList.UTF8String;

  if (_persistSessionCookies)
    settings.persist_session_cookies = _persistSessionCookies.boolValue;

  if (_persistUserPreferences)
    settings.persist_user_preferences = _persistUserPreferences.boolValue;

  if (_backgroundColor) {
    NSColor* c = [_backgroundColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
    CGFloat r, g, b, a = 0;
    [c getRed:&r green:&g blue:&b alpha:&a];
    settings.background_color = CefColorSetARGB(a * 0xff, r * 0xff, g * 0xff, b * 0xff);
  }
  
  if (_remoteDebuggingport)
    settings.remote_debugging_port = _remoteDebuggingport.intValue;

  if (_logLevel)
    settings.log_severity = (cef_log_severity_t)_logLevel.intValue;
}

@end

