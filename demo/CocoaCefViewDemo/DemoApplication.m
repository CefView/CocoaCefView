//
//  DemoApplication.m
//  CocoaCefDemo
//
//  Created by Sheen Tian on 2020/6/17.
//

#import "DemoApplication.h"

@implementation DemoApplication

- (void)initCefSettings:(CocoaCefSetting*)proposedSetting {
  proposedSetting.bridgeObjectName = @"CallBridge";
  proposedSetting.debugPort = 9999;
  proposedSetting.backgroundColor = 0xffff0000;
}

- (void)sendEvent:(NSEvent *)event {
  [super sendEvent:event];
}

@end

