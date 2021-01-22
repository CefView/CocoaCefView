//
//  CocoaCefSetting.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#ifndef CocoaCefSetting_h
#define CocoaCefSetting_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCefSetting : NSObject

/// The debug port. 0 disables remote debug.
@property uint16_t debugPort;

/// 0xAARRGGBB
@property uint32_t backgroundColor;

/// The cache root path.
@property (copy) NSString* cacheRootPath;

/// The cache path.
@property (copy) NSString* cachePath;

/// The bridge object name.
@property (copy) NSString* bridgeObjectName;

/// Gets the default instance.
+ (nonnull CocoaCefSetting*)defaultInstance;

/// Adds cross origin allow list entry.
/// @param sourceOrigin The source origin
/// @param targetProtocol The target protocol
/// @param targetDomain The target domain
/// @param allowSubdomains Indicates whether to allow the sub domain or not
+ (bool)addCrossOriginAllowlistEntry:(NSString*)sourceOrigin TargetProtocol:(NSString*)targetProtocol TargetDomain:(NSString*)targetDomain AllowSubDomain:(bool)allowSubdomains;

@end

@interface CocoaCefBrowserSetting : NSObject

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefSetting_h
