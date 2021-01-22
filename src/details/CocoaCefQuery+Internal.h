//
//  CocoaCefQuery+Internal.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/18.
//

#import <CocoaCefView/CocoaCef.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCefQuery ()

/// The query id
@property(readwrite) int64_t rid;

/// The request content
@property(copy, readwrite) NSString *request;

@end

NS_ASSUME_NONNULL_END
