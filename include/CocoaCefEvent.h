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

typedef enum {
  kCocoaCefBoolean,
  kCocoaCefInteger,
  kCocoaCefDouble,
  kCocoaCefString,
  kCocoaCefBinary,
} CocoaCefEventValueType;

/// The CocoaCefNumber
@interface CocoaCefEventValue : NSObject

/// The type
@property CocoaCefEventValueType type;

/// The number
@property NSObject *value;

@end

/// Represents the event of CocoaCef
@interface CocoaCefEvent : NSObject

/// The event name
@property(copy) NSString *name;

/// Initializes a event instance with the specifed name
/// @param name The name
+ (instancetype)initWithName:(NSString *)name;

/// Sets a boolean value for the specifed key
/// @param v The boolean value
/// @param key The key
- (void)setBooleanValue:(bool)v forKey:(NSString *)key;

/// Sets a integer value for the specifed key
/// @param v The integer value
/// @param key The key
- (void)setIntegerValue:(int)v forKey:(NSString *)key;

/// Sets a double value for the specifed key
/// @param v The double value
/// @param key The key
- (void)setDoubleValue:(double)v forKey:(NSString *)key;

/// Sets a string value for the specifed key
/// @param v The string value
/// @param key The key
- (void)setStringValue:(NSString *)v forKey:(NSString *)key;

/// Sets a binary data value for the specifed key
/// @param v The binary data value
/// @param key The key
- (void)setBinaryValue:(NSData *)v forKey:(NSString *)key;

/// Enumerates all keys and objects in the event
/// @param opts The options
/// @param block The processor block
- (void)enumerateAllValuesUsingBlock:(void(NS_NOESCAPE ^)(NSString *key, CocoaCefEventValue *val, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END

#endif // CocoaCefEvent_h
