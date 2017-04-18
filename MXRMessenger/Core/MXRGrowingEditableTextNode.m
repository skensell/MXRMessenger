//
//  MXRGrowingEditableTextNode.m
//  Mixer
//
//  Created by Scott Kensell on 3/5/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/MXRGrowingEditableTextNode.h>

@interface MXRGrowingEditableTextNode()

@property (nonatomic, assign) CGFloat previouslyCalculatedHeight;
@property (nonatomic, strong) id textViewObservingToken;

@end

@implementation MXRGrowingEditableTextNode

- (void)didLoad {
    [super didLoad];
    __weak typeof(self) weakSelf = self;
    self.textViewObservingToken = [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:self.textView queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf calculateNewFrameAndNotify];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_textViewObservingToken];
}

- (void)calculateNewFrameAndNotify {
    if (!self.isNodeLoaded) return;
    CGFloat newHeight = [self frameForTextRange:NSMakeRange(0, self.textView.text.length)].size.height;
    if (fabs(newHeight - _previouslyCalculatedHeight) > 1) {
        self.previouslyCalculatedHeight = newHeight;
        [self setNeedsLayout];
    }
}

@end
