//
//  CocoaCefConfig.mm
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import "CocoaCefConfig.h"

@implementation CocoaCefConfig

-(id)init {
  if (self = [super init])  {
    self.logLevel = 0;
    self.remoteDebuggingport = 0;
    self.persistSessionCookies = YES;
    self.persistUserPreferences = YES;
  }
  return self;
}

@end

