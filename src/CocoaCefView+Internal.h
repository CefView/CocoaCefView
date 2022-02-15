//
//  CocoaCefView.h
//  CocoaCef
//
//  Created by Sheen Tian on 2020/6/10.
//

#import <CocoaCefView/CocoaCefView.h>

#import "CocoaCefContext+Internal.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents the cef view of CocoaCef
@interface CocoaCefView ()

#pragma mark -- internal methods

- (void)draggableRegionChanged:(NSBezierPath*)draggableRegion NonDraggableRegion:(NSBezierPath*)nonDraggableRegion;

/// Checks whether the browser is loading
- (void)browserIsDestroying;

@end

NS_ASSUME_NONNULL_END
