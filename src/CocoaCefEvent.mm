//
//  CocoaCefEvent.mm
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/11.
//

#import <CocoaCefView/CocoaCefEvent.h>

@implementation CocoaCefEventValue

@end

@implementation CocoaCefEvent {
  NSMutableDictionary *_dict;
}

+ (nonnull instancetype)initWithName:(nonnull NSString *)name {
  CocoaCefEvent *instance = [[CocoaCefEvent alloc] init];
  instance.name = name;
  return instance;
}

- (instancetype)init {
  if (self = [super init]) {
    _dict = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)setBooleanValue:(bool)v forKey:(nonnull NSString *)key {
  CocoaCefEventValue *n = [[CocoaCefEventValue alloc] init];
  n.type = kCocoaCefBoolean;
  n.value = [NSNumber numberWithBool:v];
  [_dict setValue:n forKey:key];
}

- (void)setIntegerValue:(int)v forKey:(nonnull NSString *)key {
  CocoaCefEventValue *n = [[CocoaCefEventValue alloc] init];
  n.type = kCocoaCefInteger;
  n.value = [NSNumber numberWithInt:v];
  [_dict setValue:n forKey:key];
}

- (void)setDoubleValue:(double)v forKey:(nonnull NSString *)key {
  CocoaCefEventValue *n = [[CocoaCefEventValue alloc] init];
  n.type = kCocoaCefDouble;
  n.value = [NSNumber numberWithDouble:v];
  [_dict setValue:n forKey:key];
}

- (void)setStringValue:(nonnull NSString *)v forKey:(nonnull NSString *)key {
  CocoaCefEventValue *n = [[CocoaCefEventValue alloc] init];
  n.type = kCocoaCefString;
  n.value = v;
  [_dict setValue:n forKey:key];
}

- (void)setBinaryValue:(nonnull NSData *)v forKey:(nonnull NSString *)key {
  CocoaCefEventValue *n = [[CocoaCefEventValue alloc] init];
  n.type = kCocoaCefBinary;
  n.value = v;
  [_dict setValue:n forKey:key];
}

- (void)enumerateAllValuesUsingBlock:(void(NS_NOESCAPE ^)(NSString *key, CocoaCefEventValue *val, BOOL *stop))block {
  [_dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
    if ([key isKindOfClass:NSString.class] && [obj isKindOfClass:CocoaCefEventValue.class]) {
      block(key, obj, stop);
    }
  }];
}

@end
