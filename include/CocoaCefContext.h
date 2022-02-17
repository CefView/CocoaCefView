//
//  CocoaCefContext.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#ifndef CocoaCefContext_h
#define CocoaCefContext_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CocoaCefView/CocoaCefConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCefContext : NSObject

@property(class, strong, readonly) __kindof CocoaCefContext* sharedInstance;

/// <#Description#>
/// @param config <#config description#>
+ (id)contextWithConfig:(CocoaCefConfig*)config;

/// <#Description#>
/// @param path <#path description#>
/// @param url <#url description#>
/// @param priority <#priority description#>
- (void)addLocalFolderResource:(NSString*)path forUrl:(NSString *)url withPriority:(int)priority;

/// <#Description#>
/// @param path <#path description#>
/// @param url <#url description#>
/// @param pwd <#pwd description#>
- (void)addLocalArchiveResource:(NSString*)path forUrl:(NSString *)url withPassword:(int)pwd;

/// <#Description#>
/// @param name <#name description#>
/// @param value <#value description#>
/// @param domain <#domain description#>
/// @param url <#url description#>
/// @return 
- (bool)addCookie:(NSString*)name withValue:(NSString *)value forDomain:(NSString*)domain andUrl:(NSString*)url;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefContext_h
