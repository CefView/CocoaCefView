//
//  CocoaCefConfig+Internal.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#include <unordered_map>

#import <CocoaCefView/CocoaCefConfig.h>

#include <include/cef_app.h>

NS_ASSUME_NONNULL_BEGIN

typedef std::unordered_map<std::string, std::string> ArgsMap;

@interface
CocoaCefConfig ()

- (void)copyToCefSettings:(CefSettings&)settings;

- (const ArgsMap&)getCommandLineArgs;

@end

NS_ASSUME_NONNULL_END
