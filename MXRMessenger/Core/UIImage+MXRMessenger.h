//
//  UIImage+MXRMessenger.h
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface UIImage (MXRMessenger)

+ (UIImage *)mxr_fromColor:(UIColor*)color;

+ (UIImage *)mxr_bubbleImageWithMaximumCornerRadius:(CGFloat)maxCornerRadius
                               minimumCornerRadius:(CGFloat)minCornerRadius
                                             color:(UIColor *)fillColor
                           cornersToApplyMaxRadius:(UIRectCorner)roundedCorners;

+ (asimagenode_modification_block_t)mxr_imageModificationBlockToScaleToSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (asimagenode_modification_block_t)mxr_imageModificationBlockToScaleToSize:(CGSize)size
                                                       maximumCornerRadius:(CGFloat)maxCornerRadius
                                                       minimumCornerRadius:(CGFloat)minCornerRadius
                                                               borderColor:(UIColor*)borderColor
                                                               borderWidth:(CGFloat)borderWidth
                                                   cornersToApplyMaxRadius:(UIRectCorner)roundedCorners;

@end
