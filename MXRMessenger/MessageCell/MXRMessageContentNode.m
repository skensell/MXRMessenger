//
//  MXRMessageContentNode.m
//  Mixer
//
//  Created by Scott Kensell on 3/31/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageContentNode.h"

@implementation MXRMessageContentNode {
    NSTimeInterval _touchStartTimestamp;
}

- (instancetype)initWithConfiguration:(MXRMessageNodeConfiguration *)configuration {
    self = [super init];
    if (self) {
        _menuItemTypes = configuration.menuItemTypes;
        _showsUIMenuControllerOnLongTap = configuration.showsUIMenuControllerOnLongTap;
        self.userInteractionEnabled = _showsUIMenuControllerOnLongTap;
    }
    return self;
}

- (instancetype)init {
    ASDISPLAYNODE_NOT_DESIGNATED_INITIALIZER();
    return [self initWithConfiguration:nil];
}

- (void)setDelegate:(id<MXRMessageContentNodeDelegate>)delegate {
    _delegate = delegate;
    self.userInteractionEnabled = self.userInteractionEnabled || ([_delegate respondsToSelector:@selector(messageContentNode:didSingleTap:)] || [_delegate respondsToSelector:@selector(messageContentNode:didLongTap:)]);
}

- (void)redrawBubbleWithCorners:(UIRectCorner)cornersHavingRadius { NSAssert(NO, @"Abstract method not implemented: %@", NSStringFromSelector(_cmd)); }

#pragma mark - UIResponderStandardEditActions

- (BOOL)respondsToSelector:(SEL)aSelector {
    // see note in `canPerformAction:withSender:`
    if (aSelector == @selector(copy:) || aSelector == @selector(delete:)) {
        return [self canPerformAction:aSelector withSender:self];
    }
    return [super respondsToSelector:aSelector];
}

- (BOOL)canBecomeFirstResponder {
    return _menuItemTypes != MXRMessageMenuItemTypeNone;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // Note: This is not being called because _ASDisplayView does not forward the call from UIView.
    // You can see in _ASDisplayView it checks to see if `action` is implemented on the node by calling
    // `respondsToSelector:`. Our workaround is to call this method from within `respondsToSelector:`
    // Calling super would create a loop I believe, so dont.
    return ((action == @selector(copy:) && (_menuItemTypes & MXRMessageMenuItemTypeCopy)) ||
            (action == @selector(delete:) && (_menuItemTypes & MXRMessageMenuItemTypeDelete)));
}

- (void)copy:(id)sender {
    [_delegate messageContentNode:self didTapMenuItemWithType:MXRMessageMenuItemTypeCopy];
}

- (void)delete:(id)sender {
    [_delegate messageContentNode:self didTapMenuItemWithType:MXRMessageMenuItemTypeDelete];
}


#pragma mark - ASDisplayNode Overrides
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchStartTimestamp = event.timestamp;
    self.highlighted = YES;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    UITouch* touch = [touches anyObject];
    BOOL isInside = [self pointInside:[touch locationInView:self.view] withEvent:event];
    if (!isInside) return;
    CGFloat duration = event.timestamp - _touchStartTimestamp;
    if (duration > 0.35f) {
        // long tap
        if (_showsUIMenuControllerOnLongTap && [self becomeFirstResponder]) {
            [[UIMenuController sharedMenuController] setTargetRect:self.bounds inView:self.view];
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        }
        if ([_delegate respondsToSelector:@selector(messageContentNode:didLongTap:)]) {
            [_delegate messageContentNode:self didLongTap:nil];
        }
    } else {
        // tap
        if ([_delegate respondsToSelector:@selector(messageContentNode:didSingleTap:)]) {
            [_delegate messageContentNode:self didSingleTap:nil];
        }
    }
}

#pragma clang diagnostic pop

@end
