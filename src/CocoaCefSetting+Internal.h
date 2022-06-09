//
//  CocoaCefSetting+Internal.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <CocoaCefView/CocoaCefSetting.h>

NS_ASSUME_NONNULL_BEGIN

@interface
CocoaCefSetting ()

- (void)copyToCefBrowserSettings:(CefBrowserSettings&)settings;

@end

NS_ASSUME_NONNULL_END
