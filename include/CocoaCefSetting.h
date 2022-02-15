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

@interface CocoaCefSetting : NSObject

// string
@property NSString* standardFontFamily;
@property NSString* fixedFontFamily;
@property NSString* serifFontFamily;
@property NSString* sansSerifFontFamily;
@property NSString* cursiveFontFamily;
@property NSString* fantasyFontFamily;
@property NSString* defaultEncoding;
@property NSString* acceptLanguageList;

// int
@property NSNumber* windowlessFrameRate;
@property NSNumber* defaultFontSize;
@property NSNumber* defaultFixedFontSize;
@property NSNumber* minimumFontSize;
@property NSNumber* minimumLogicalFontSize;

// optional boolean
@property NSNumber* remoteFonts;
@property NSNumber* javascript;
@property NSNumber* javascriptCloseWindows;
@property NSNumber* javascriptAccessClipboard;
@property NSNumber* javascriptDomPaste;
@property NSNumber* plugins;
@property NSNumber* universalAccessFromFileUrls;
@property NSNumber* fileAccessFromFileUrls;
@property NSNumber* webSecurity;
@property NSNumber* imageLoading;
@property NSNumber* imageShrinkStandaloneToFit;
@property NSNumber* textAreaResize;
@property NSNumber* tabToLinks;
@property NSNumber* localStorage;
@property NSNumber* databases;
@property NSNumber* applicationCache;
@property NSNumber* webgl;

@property NSColor* backgroundColor;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefSetting_h
