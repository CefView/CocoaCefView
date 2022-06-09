//
//  CocoaCefEvent.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/11.
//

#ifndef CocoaCefEvent_h
#define CocoaCefEvent_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the event of CocoaCef
@interface CocoaCefEvent : NSObject

/// The event name
@property (copy) NSString* name;

// The argument list
@property (strong) NSMutableArray* arguments;

/// Initializes a event instance with the specifed name
/// @param name The name
+ (instancetype)initWithName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefEvent_h
