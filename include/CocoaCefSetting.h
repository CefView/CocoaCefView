//
//  CocoaCefSetting.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#ifndef CocoaCefSetting_h
#define CocoaCefSetting_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// <#Description#>
@interface CocoaCefSetting : NSObject

// string
/// <#Description#>
@property NSString* standardFontFamily;

/// <#Description#>
@property NSString* fixedFontFamily;

/// <#Description#>
@property NSString* serifFontFamily;

/// <#Description#>
@property NSString* sansSerifFontFamily;

/// <#Description#>
@property NSString* cursiveFontFamily;

/// <#Description#>
@property NSString* fantasyFontFamily;

/// <#Description#>
@property NSString* defaultEncoding;

/// <#Description#>
@property NSString* acceptLanguageList;

// int
/// <#Description#>
@property NSNumber* windowlessFrameRate;

/// <#Description#>
@property NSNumber* defaultFontSize;

/// <#Description#>
@property NSNumber* defaultFixedFontSize;

/// <#Description#>
@property NSNumber* minimumFontSize;

/// <#Description#>
@property NSNumber* minimumLogicalFontSize;

// optional boolean
/// <#Description#>
@property NSNumber* remoteFonts;

/// <#Description#>
@property NSNumber* javascript;

/// <#Description#>
@property NSNumber* javascriptCloseWindows;

/// <#Description#>
@property NSNumber* javascriptAccessClipboard;

/// <#Description#>
@property NSNumber* javascriptDomPaste;

/// <#Description#>
@property NSNumber* plugins;

/// <#Description#>
@property NSNumber* universalAccessFromFileUrls;

/// <#Description#>
@property NSNumber* fileAccessFromFileUrls;

/// <#Description#>
@property NSNumber* webSecurity;

/// <#Description#>
@property NSNumber* imageLoading;

/// <#Description#>
@property NSNumber* imageShrinkStandaloneToFit;

/// <#Description#>
@property NSNumber* textAreaResize;

/// <#Description#>
@property NSNumber* tabToLinks;

/// <#Description#>
@property NSNumber* localStorage;

/// <#Description#>
@property NSNumber* databases;

/// <#Description#>
@property NSNumber* applicationCache;

/// <#Description#>
@property NSNumber* webgl;

/// <#Description#>
@property NSColor* backgroundColor;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefSetting_h
