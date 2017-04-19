//
//  MXRMessageImageNode.h
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageContentNode.h"

#import "MXRPlayButtonNode.h"

@class MXRMessageImageConfiguration;

@interface MXRMessageImageNode : MXRMessageContentNode

@property (nonatomic, strong, readonly) ASNetworkImageNode* imageNode;
@property (nonatomic, strong, readonly) MXRPlayButtonNode* playButtonNode;

- (instancetype)initWithImageURL:(NSURL*)imageURL configuration:(MXRMessageImageConfiguration*)configuration cornersToApplyMaxRadius:(UIRectCorner)cornersHavingRadius showsPlayButton:(BOOL)showsPlayButton NS_DESIGNATED_INITIALIZER;

@end


@interface MXRMessageImageConfiguration : MXRMessageNodeConfiguration

/**
 * If placeholder is nil, this size will still be used to display a plain white image
 * until the image is downloaded.
 */
@property (nonatomic, assign) CGSize placeholderImageSize;
@property (nonatomic, strong) UIImage* placeholderImage;

/**
 * MXRMessageImageNode at present does not support the fractionOfWidthToLayoutContent
 * of MXRMessageCellLayoutConfiguration. Here you can specify the box within which
 * the rendered image will be AspectFit.
 */
@property (nonatomic, assign) CGSize maximumImageSize;

+ (CGSize)suggestedMaxImageSizeForScreenSize:(CGSize)screenSize;

@end

