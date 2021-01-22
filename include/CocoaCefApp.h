//
//  CocoaCefApp.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/17.
//

#ifndef CocoaCefApp_h
#define CocoaCefApp_h

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the base class of CocoaCefApp
@interface CocoaCefApp : NSApplication

@end

FOUNDATION_EXPORT int CocoaCefApplicationMain(int argc, const char *_Nonnull argv[_Nonnull]);

NS_ASSUME_NONNULL_END

#endif // CocoaCefApp_h
