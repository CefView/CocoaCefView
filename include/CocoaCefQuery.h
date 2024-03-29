//
//  CocoaCefQuery.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#ifndef CocoaCefQuery_h
#define CocoaCefQuery_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the query object of CocoaCef
@interface CocoaCefQuery : NSObject

/// The query id
@property (readonly) int64_t rid;

/// The request content
@property (copy, readonly) NSString* request;

/// The response content
@property (copy, readonly) NSString* response;

/// Indicates whether the repsonse succeeds or not
@property (readonly) bool success;

/// The response error code
@property (readonly) int error;

/// <#Description#>
/// @param response <#response description#>
/// @param result <#result description#>
/// @param ec <#ec description#>
- (void)setResponse:(NSString*)response WithResult:(bool)result AndErrorCode:(int)ec;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefQuery_h
