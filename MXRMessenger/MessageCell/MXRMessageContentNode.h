//
//  MXRMessageContentNode.h
//  Mixer
//
//  Created by Scott Kensell on 3/31/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "MXRMessageContentNodeDelegate.h"
#import "MXRMessageNodeConfiguration.h"

@interface MXRMessageContentNode : ASDisplayNode <UIResponderStandardEditActions>

@property (nonatomic, assign) MXRMessageMenuItemTypes menuItemTypes;
@property (nonatomic, assign) BOOL showsUIMenuControllerOnLongTap;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, weak) id<MXRMessageContentNodeDelegate> delegate;

- (instancetype)initWithConfiguration:(MXRMessageNodeConfiguration*)configuration NS_DESIGNATED_INITIALIZER;

// these call delegate by default, subclasses should call super
- (void)copy:(id)sender;
- (void)delete:(id)sender;

- (void)redrawBubbleWithCorners:(UIRectCorner)cornersHavingRadius; // abstract, override

@end
