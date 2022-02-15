//
//  CocoaCefConfig+Internal.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <CocoaCefView/CocoaCefConfig.h>

#include <include/cef_app.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaCefConfig ()

- (void)copyToCefSettings:(CefSettings&)setting;

@end

NS_ASSUME_NONNULL_END
