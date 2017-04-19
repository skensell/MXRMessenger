//
//  MXRMessageCellNode.m
//  Mixer
//
//  Created by Scott Kensell on 2/24/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageCellNode.h"

@implementation MXRMessageCellNode

- (instancetype)init {
    return [self initWithLayoutConfiguration:nil];
}

- (instancetype)initWithLayoutConfiguration:(MXRMessageCellLayoutConfiguration *)layoutConfig {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _layoutConfig = layoutConfig;
        NSAssert(layoutConfig != nil, @"You must provide a layoutConfig at init to MXRMessageCellNode");
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSAssert(!_avatarNode || !CGSizeEqualToSize(CGSizeZero, _avatarNode.style.preferredSize), @"avatarNode (if provided) must be sized with a non-zero preferredSize to be able to enforce maximum content width properly.");
    ASStackLayoutSpec* contentStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    contentStack.alignItems = ASStackLayoutAlignItemsEnd;
    contentStack.spacing = _layoutConfig.avatarToContentSpacing;
    NSMutableArray* contentChildren = [[NSMutableArray alloc] init];
    if (_avatarNode) [contentChildren addObject:_avatarNode];
    if (_messageContentNode) [contentChildren addObject:_messageContentNode];
    
    if (_layoutConfig.layoutDirection == MXRMessageLayoutDirectionRightToLeft) {
        NSMutableArray* reversedContentChildren = [[NSMutableArray alloc] initWithCapacity:contentChildren.count];
        [contentChildren enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [reversedContentChildren addObject:obj];
        }];
        contentChildren = reversedContentChildren;
    }
    
    if (CGSizeEqualToSize(_messageContentNode.style.preferredSize, CGSizeZero)) {
        // We enforce the maxWidth of the contentNode because it seems to be a bug in ASDK that
        // when a textNode is in a horizontal stack,
        //      on the first layout pass, contentSize.width is infinite
        //      on the 2nd layout pass, it's enforced by the flexShrink, flexGrow rules
        //      there is a missing 3rd layout pass where the textNode should clamp to its text's rendered bounds
        CGFloat usedWidth = _layoutConfig.finalInset.left + _layoutConfig.finalInset.right + _layoutConfig.avatarAndContentInset.left + _layoutConfig.avatarAndContentInset.right + (_avatarNode ? (_layoutConfig.avatarToContentSpacing + _avatarNode.style.preferredSize.width) : 0);
        CGFloat maxContentWidth = (constrainedSize.max.width - usedWidth) * _layoutConfig.fractionOfWidthToLayoutContent;
        if (maxContentWidth > 0) {
            _messageContentNode.style.maxWidth = ASDimensionMakeWithPoints(maxContentWidth);
        }
    }
    
    contentStack.children = contentChildren;
    
    ASInsetLayoutSpec* contentInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:_layoutConfig.avatarAndContentInset child:contentStack];
    
    ASStackLayoutSpec* headerContentAndFooterStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    headerContentAndFooterStack.alignItems = ASStackLayoutAlignItemsStretch;
    contentInset.style.alignSelf = _layoutConfig.layoutDirection == MXRMessageLayoutDirectionLeftToRight ? ASStackLayoutAlignSelfStart : ASStackLayoutAlignSelfEnd;
    NSMutableArray *a = [[NSMutableArray alloc] init];
    if (_headerNode) [a addObject:_headerNode];
    [a addObject:contentInset];
    if (_footerNode) [a addObject:_footerNode];
    headerContentAndFooterStack.children = a;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:_layoutConfig.finalInset child:headerContentAndFooterStack];
}

@end

@implementation MXRMessageCellLayoutConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutDirection = MXRMessageLayoutDirectionLeftToRight;
        _fractionOfWidthToLayoutContent = 0.80f;
        _avatarToContentSpacing = 6.0f;
        _avatarAndContentInset = UIEdgeInsetsMake(1.0, 8.0f, 1.0, 8.0f);
        _finalInset = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)copy {
    MXRMessageCellLayoutConfiguration* config = [[[self class] alloc] init];
    config.layoutDirection = self.layoutDirection;
    config.fractionOfWidthToLayoutContent = self.fractionOfWidthToLayoutContent;
    config.avatarToContentSpacing = self.avatarToContentSpacing;
    config.avatarAndContentInset = self.avatarAndContentInset;
    config.finalInset = self.finalInset;
    return config;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self copy];
}

+ (instancetype)leftToRight {
    MXRMessageCellLayoutConfiguration* config = [[MXRMessageCellLayoutConfiguration alloc] init];
    config.layoutDirection = MXRMessageLayoutDirectionLeftToRight;
    return config;
}

+ (instancetype)rightToLeft {
    MXRMessageCellLayoutConfiguration* config = [[MXRMessageCellLayoutConfiguration alloc] init];
    config.layoutDirection = MXRMessageLayoutDirectionRightToLeft;
    return config;
}

@end


