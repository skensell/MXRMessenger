//
//  MXRMessageMediumCellNode.m
//  Mixer
//
//  Created by Scott Kensell on 4/4/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageMediumCellNode.h"

#import <MXRMessenger/UIImage+MXRMessenger.h>

@implementation MXRMessageMediumCellNode {
    MXRMessageNodeConfiguration* _configuration;
    CGSize _size;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL configuration:(MXRMessageNodeConfiguration *)configuration size:(CGSize)size cornersHavingRadius:(UIRectCorner)cornersHavingRadius showsPlayButton:(BOOL)showsPlayButton {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _configuration = configuration;
        _size = size;
        
        ASNetworkImageNode* imageNode = nil;
        if (configuration.imageCache && configuration.imageDownloader) {
            imageNode = [[ASNetworkImageNode alloc] initWithCache:configuration.imageCache downloader:configuration.imageDownloader];
        } else {
            imageNode = [[ASNetworkImageNode alloc] init];
        }
        _imageNode = imageNode;
        imageNode.layerBacked = YES;
        imageNode.contentMode = UIViewContentModeScaleAspectFill;
        imageNode.style.preferredSize = size;
        [self redrawWithCornersHavingRadius:cornersHavingRadius];
        imageNode.URL = imageURL;
        
        if (showsPlayButton) {
            _playButtonNode = [[MXRPlayButtonNode alloc] init];
            _playButtonNode.style.preferredSize = [MXRPlayButtonNode suggestedSizeWhenRenderedOverImageWithSizeInPoints:size];
        }
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec* imageInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_imageNode];
    if (_playButtonNode) {
        return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageInset overlay:[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:_playButtonNode]];
    }
    return imageInset;
}

- (void)redrawWithCornersHavingRadius:(UIRectCorner)cornersHavingRadius {
    CGFloat maxCornerRadius = cornersHavingRadius > 0 ? _configuration.maxCornerRadius : _configuration.minCornerRadius;
    _imageNode.imageModificationBlock = [UIImage mxr_imageModificationBlockToScaleToSize:_size maximumCornerRadius:maxCornerRadius minimumCornerRadius:_configuration.minCornerRadius borderColor:_configuration.borderColor borderWidth:_configuration.borderWidth cornersToApplyMaxRadius:cornersHavingRadius];
    if (self.isNodeLoaded) [_imageNode setNeedsDisplay];
}

@end
