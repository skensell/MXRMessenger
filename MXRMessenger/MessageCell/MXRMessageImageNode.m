//
//  MXRMessageImageNode.m
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageImageNode.h"

#import "UIImage+MXRMessenger.h"
#import "UIColor+MXRMessenger.h"

@interface MXRMessageImageNode() <ASNetworkImageNodeDelegate>

@end

@implementation MXRMessageImageNode {
    CGSize _maxSize;
    CGFloat _maxCornerRadius;
    CGFloat _minCornerRadius;
    UIRectCorner _cornersHavingMaxRadius;
    UIColor* _borderColor;
    CGFloat _borderWidth;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL configuration:(MXRMessageImageConfiguration *)configuration cornersToApplyMaxRadius:(UIRectCorner)cornersHavingRadius showsPlayButton:(BOOL)showsPlayButton {
    self = [super initWithConfiguration:configuration];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        _maxSize = configuration.maximumImageSize;
        _maxCornerRadius = configuration.maxCornerRadius;
        _minCornerRadius = configuration.minCornerRadius;
        _cornersHavingMaxRadius = cornersHavingRadius;
        _borderColor = configuration.borderColor;
        _borderWidth = configuration.borderWidth;
        
        if (configuration.imageCache && configuration.imageDownloader) {
            _imageNode = [[ASNetworkImageNode alloc] initWithCache:configuration.imageCache downloader:configuration.imageDownloader];
        } else {
            _imageNode = [[ASNetworkImageNode alloc] init];
        }
        [self setImageModificationBlockForSize:configuration.placeholderImageSize];
        
        if (configuration.placeholderImage) {
            _imageNode.defaultImage = configuration.placeholderImage;
        } else {
            // We need a non-nil image so that we can see the border created in the imageModificationBlock
            _imageNode.defaultImage = [UIImage mxr_fromColor:[UIColor whiteColor]];
        }
        _imageNode.style.preferredSize = configuration.placeholderImageSize;
        self.style.preferredSize = _imageNode.style.preferredSize;
        _imageNode.contentMode = UIViewContentModeScaleAspectFill;
        _imageNode.delegate = self;
        _imageNode.URL = imageURL;
        
        if (showsPlayButton) {
            _playButtonNode = [[MXRPlayButtonNode alloc] init];
        }
        
    }
    return self;
}

- (instancetype)initWithConfiguration:(MXRMessageNodeConfiguration *)configuration {
    ASDISPLAYNODE_NOT_DESIGNATED_INITIALIZER();
    return [self initWithImageURL:nil configuration:nil cornersToApplyMaxRadius:UIRectCornerAllCorners showsPlayButton:NO];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec* imageInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_imageNode];
    if (_playButtonNode) {
        _playButtonNode.style.preferredSize = [MXRPlayButtonNode suggestedSizeWhenRenderedOverImageWithSizeInPoints:_imageNode.style.preferredSize];
        return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageInset overlay:[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:_playButtonNode]];
    }
    return imageInset;
}

- (void)setImageModificationBlockForSize:(CGSize)size {
    if (_minCornerRadius > 0.0f || _borderWidth > 0.0f) {
        _imageNode.imageModificationBlock = [UIImage mxr_imageModificationBlockToScaleToSize:size maximumCornerRadius:_maxCornerRadius minimumCornerRadius:_minCornerRadius borderColor:_borderColor borderWidth:_borderWidth cornersToApplyMaxRadius:_cornersHavingMaxRadius];
    }
}

- (void)redrawBubbleWithCorners:(UIRectCorner)cornersHavingRadius {
    _cornersHavingMaxRadius = cornersHavingRadius;
    [self setImageModificationBlockForSize:_imageNode.frame.size];
    [_imageNode setNeedsDisplay];
}

#pragma mark - ASNetworkImageNodeDelegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    if (!image || image.size.width == 0 || image.size.height == 0) return;
    
    // The next layout pass may happen after the image finishes decoding, so we need to
    // give ASyncDisplayKit a hint to its target size so it decodes correctly. This is
    // why we set its frame.
    CGFloat scaleFactor = (_maxSize.width / image.size.width);
    CGFloat scaleFactor2 = (_maxSize.height / image.size.height);
    CGFloat scale = MIN(scaleFactor2, scaleFactor);
    
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    _imageNode.frame = (CGRect){CGPointZero, newSize};
    [self setImageModificationBlockForSize:newSize];
    _imageNode.style.preferredSize = _imageNode.frame.size;
    self.style.preferredSize = _imageNode.style.preferredSize;
    [self setNeedsLayout];
}

@end


@implementation MXRMessageImageConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.borderColor = [UIColor colorWithRed:0.592f green:0.592f blue:0.592f alpha:1];
        self.borderWidth = 0.5f;
        _placeholderImageSize = CGSizeMake(100, 100);
        _maximumImageSize = [MXRMessageImageConfiguration suggestedMaxImageSizeForScreenSize:[UIScreen mainScreen].bounds.size];
    }
    return self;
}

+ (CGSize)suggestedMaxImageSizeForScreenSize:(CGSize)screenSize {
    int maximumImageWidth = (int)(screenSize.width * 0.75f);
    while ((maximumImageWidth % 3 != 1) && (maximumImageWidth % 2 != 0)) {
        // for the media collection it helps with spacing if its 1 mod 3 and 0 mod 2
        maximumImageWidth--;
    }
    return CGSizeMake(maximumImageWidth, 1.77f*maximumImageWidth);
}

@end
