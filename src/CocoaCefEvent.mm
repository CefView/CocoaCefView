//
//  CocoaCefEvent.mm
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/11.
//

#import <CocoaCefView/CocoaCefEvent.h>

@implementation CocoaCefEvent

+ (nonnull instancetype)initWithName:(nonnull NSString*)name
{
  CocoaCefEvent* instance = [[CocoaCefEvent alloc] init];
  instance.name = name;
  return instance;
}

- (instancetype)init
{
  if (self = [super init]) {
    self.arguments = [[NSMutableArray alloc] init];
  }
  return self;
}

@end
