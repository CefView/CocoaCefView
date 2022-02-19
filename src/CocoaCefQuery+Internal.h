//
//  CocoaCefQuery+Internal.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/18.
//

#import <CocoaCefView/CocoaCefQuery.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCefQuery ()

+ (id)queryWithRequest:(NSString*)request AndId:(int64_t)rid;

@end

NS_ASSUME_NONNULL_END
