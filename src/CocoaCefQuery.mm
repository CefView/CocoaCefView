//
//  CocoaCefQuery.mm
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#import <CocoaCefView/CocoaCefQuery.h>

@implementation CocoaCefQuery

+ (id)queryWithRequest:(NSString*)request AndId:(int64_t)rid {
  CocoaCefQuery* instance = [[CocoaCefQuery alloc] init];
  instance.rid = rid;
  instance.request = [NSString stringWithString:request];
}

- (void)setRid:(int64_t)rid {
  _rid = rid;
}

- (void)setRequest:(NSString *_Nonnull)request {
  _request = request;
}

@end
