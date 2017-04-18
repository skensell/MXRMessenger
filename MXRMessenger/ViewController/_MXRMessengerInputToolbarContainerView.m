//
//  _MXRMessengerInputToolbarContainerView.m
//  Mixer
//
//  Created by Scott Kensell on 3/18/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/_MXRMessengerInputToolbarContainerView.h>

static NSString* MXRNewCalculatedSizeNotification = @"MXRNewCalculatedSizeNotification";

@interface MXRNewSizeNotifyingNode : ASDisplayNode

@property (nonatomic, strong) ASDisplayNode* innerNode;

@end

@implementation MXRMessengerInputToolbarContainerView {
    id _newSizeNotification;
    MXRNewSizeNotifyingNode* _containerNode;
}

- (instancetype)initWithMessengerInputToolbar:(MXRMessengerInputToolbar *)toolbarNode constrainedSize:(ASSizeRange)constrainedSize {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _toolbarNode = toolbarNode;
        _containerNode = [[MXRNewSizeNotifyingNode alloc] init];
        _containerNode.innerNode = _toolbarNode;
        [_containerNode layoutThatFits:constrainedSize];
        _containerNode.frame = CGRectMake(0, 0, _containerNode.calculatedSize.width, _containerNode.calculatedSize.height);
        self.frame = _containerNode.frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight; // NOTE: Do not set flexibleHeight on Node too, creates bugs.
        [self addSubview:_containerNode.view];
        
        __weak typeof(self) weakSelf = self;
        _newSizeNotification = [[NSNotificationCenter defaultCenter] addObserverForName:MXRNewCalculatedSizeNotification object:_containerNode queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf invalidateIntrinsicContentSize];
        }];
    }
    return self;
}

- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:_newSizeNotification]; }
- (CGSize)intrinsicContentSize { return _containerNode.calculatedSize; }

@end


@implementation MXRNewSizeNotifyingNode {
    CGSize _previouslyCalculatedSize;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)calculatedLayoutDidChange {
    [super calculatedLayoutDidChange];
    if (!CGSizeEqualToSize(_previouslyCalculatedSize, self.calculatedSize)) {
        _previouslyCalculatedSize = self.calculatedSize;
        [[NSNotificationCenter defaultCenter] postNotificationName:MXRNewCalculatedSizeNotification object:self];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_innerNode];
}

@end
