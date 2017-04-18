//
//  MXRMessengerInputToolbar.h
//  Mixer
//
//  Created by Scott Kensell on 3/3/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import <MXRMessenger/MXRGrowingEditableTextNode.h>

@class MXRMessengerIconButtonNode;

@interface MXRMessengerInputToolbar : ASDisplayNode

@property (nonatomic, strong, readonly) MXRGrowingEditableTextNode* textInputNode;
@property (nonatomic, strong) ASDisplayNode* leftButtonsNode;
@property (nonatomic, strong) ASDisplayNode* rightButtonsNode;
@property (nonatomic, strong, readonly) MXRMessengerIconButtonNode* defaultSendButton; // setting rightButtonsNode hides this

@property (nonatomic, assign, readonly) CGFloat heightOfTextNodeWithOneLineOfText;
@property (nonatomic, strong, readonly) UIFont* font;
@property (nonatomic, strong, readonly) UIColor* tintColor;

- (instancetype)initWithFont:(UIFont*)font placeholder:(NSString*)placeholder tintColor:(UIColor*)tintColor;

- (NSString*)clearText; // clears and returns the current text with whitespace trimmed

@end


@interface MXRMessengerIconNode : ASDisplayNode

@property (nonatomic, strong) UIColor* color;

@end


@interface MXRMessengerSendIconNode : MXRMessengerIconNode
@end


@interface MXRMessengerPlusIconNode : MXRMessengerIconNode
@end


@interface MXRMessengerIconButtonNode : ASControlNode

@property (nonatomic, strong) MXRMessengerIconNode* icon;

+ (instancetype)buttonWithIcon:(MXRMessengerIconNode*)icon matchingToolbar:(MXRMessengerInputToolbar*)toolbar;

@end
