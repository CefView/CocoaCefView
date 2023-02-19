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

#import "CocoaCefSetting+Internal.h"

@implementation CocoaCefSetting

- (void)copyToCefBrowserSettings:(CefBrowserSettings&)settings
{
  if (_standardFontFamily.length)
    CefString(&settings.standard_font_family) = _standardFontFamily.UTF8String;

  if (_fixedFontFamily.length)
    CefString(&settings.fixed_font_family) = _fixedFontFamily.UTF8String;

  if (_serifFontFamily.length)
    CefString(&settings.serif_font_family) = _serifFontFamily.UTF8String;

  if (_sansSerifFontFamily.length)
    CefString(&settings.sans_serif_font_family) = _sansSerifFontFamily.UTF8String;

  if (_cursiveFontFamily.length)
    CefString(&settings.cursive_font_family) = _cursiveFontFamily.UTF8String;

  if (_fantasyFontFamily.length)
    CefString(&settings.fantasy_font_family) = _fantasyFontFamily.UTF8String;

  if (_defaultEncoding.length)
    CefString(&settings.default_encoding) = _defaultEncoding.UTF8String;

  if (_acceptLanguageList.length)
    CefString(&settings.accept_language_list) = _acceptLanguageList.UTF8String;

  if (_windowlessFrameRate)
    settings.windowless_frame_rate = _windowlessFrameRate.intValue;

  if (_defaultFontSize)
    settings.default_font_size = _defaultFontSize.intValue;

  if (_defaultFixedFontSize)
    settings.default_fixed_font_size = _defaultFixedFontSize.intValue;

  if (_minimumFontSize)
    settings.minimum_font_size = _minimumFontSize.intValue;

  if (_minimumLogicalFontSize)
    settings.minimum_logical_font_size = _minimumLogicalFontSize.intValue;

  if (_remoteFonts)
    settings.remote_fonts = _remoteFonts.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_javascript)
    settings.javascript = _javascript.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_javascriptCloseWindows)
    settings.javascript_close_windows = _javascriptCloseWindows.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_javascriptAccessClipboard)
    settings.javascript_access_clipboard = _javascriptAccessClipboard.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_javascriptDomPaste)
    settings.javascript_dom_paste = _javascriptDomPaste.boolValue ? STATE_ENABLED : STATE_DISABLED;

#if CEF_VERSION_MAJOR < 100
  if (_plugins)
    settings.plugins = _plugins.boolValue ? STATE_ENABLED : STATE_DISABLED;
#endif
  
  if (_imageLoading)
    settings.image_loading = _imageLoading.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_imageShrinkStandaloneToFit)
    settings.image_shrink_standalone_to_fit = _imageShrinkStandaloneToFit.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_textAreaResize)
    settings.text_area_resize = _textAreaResize.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_tabToLinks)
    settings.tab_to_links = _tabToLinks.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_localStorage)
    settings.local_storage = _localStorage.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_databases)
    settings.databases = _databases.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_webgl)
    settings.webgl = _webgl.boolValue ? STATE_ENABLED : STATE_DISABLED;

  if (_backgroundColor) {
    NSColor* c = [_backgroundColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
    CGFloat r, g, b, a = 0;
    [c getRed:&r green:&g blue:&b alpha:&a];
    settings.background_color = CefColorSetARGB(a * 0xff, r * 0xff, g * 0xff, b * 0xff);
  }
}

@end
