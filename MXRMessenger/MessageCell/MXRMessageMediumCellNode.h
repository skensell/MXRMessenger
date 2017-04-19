//
//  MXRMessageMediumCellNode.h
//  Mixer
//
//  Created by Scott Kensell on 4/4/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "MXRMessageNodeConfiguration.h"
#import "MXRPlayButtonNode.h"

@interface MXRMessageMediumCellNode : ASCellNode

@property (nonatomic, strong, readonly) ASNetworkImageNode* imageNode;
@property (nonatomic, strong, readonly) MXRPlayButtonNode* playButtonNode;

- (instancetype)initWithImageURL:(NSURL*)imageURL configuration:(MXRMessageNodeConfiguration*)configuration size:(CGSize)size cornersHavingRadius:(UIRectCorner)cornersHavingRadius showsPlayButton:(BOOL)showsPlayButton;

- (void)redrawWithCornersHavingRadius:(UIRectCorner)cornersHavingRadius;

@end
