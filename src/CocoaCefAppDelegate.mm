//
//  CocoaCefAppDelegate.m
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import "CocoaCefAppDelegate.h"

CocoaCefAppDelegate::CocoaCefAppDelegate(void* context)
: _context((__bridge CocoaCefContext*)context) {
}


void CocoaCefAppDelegate::OnScheduleMessageLoopWork(int64_t delay_ms) {
  [_context scheduleCefLoopWork:delay_ms];
}
