//
//  UIImage+MXRMessenger.m
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/UIImage+MXRMessenger.h>

#import <MXRMessenger/UIBezierPath+MXRMessenger.h>

@implementation UIImage (MXRMessenger)

+ (UIImage *)mxr_fromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)mxr_bubbleImageWithMaximumCornerRadius:(CGFloat)maxCornerRadius minimumCornerRadius:(CGFloat)minCornerRadius color:(UIColor *)fillColor cornersToApplyMaxRadius:(UIRectCorner)roundedCorners {
    CGFloat smallestImageHeight = (maxCornerRadius * 2) + 1;
    CGSize smallestImageSize = CGSizeMake(smallestImageHeight, smallestImageHeight);
    UIBezierPath* clippingPath = [UIBezierPath mxr_bezierPathForRoundedRectWithCorners:UIRectCornerAllCorners radius:minCornerRadius size:smallestImageSize];
    UIBezierPath* path = [UIBezierPath mxr_bezierPathForRoundedRectWithCorners:roundedCorners radius:maxCornerRadius size:smallestImageSize];
    
    UIGraphicsBeginImageContextWithOptions(clippingPath.bounds.size, NO, 0.0f);
    
    [clippingPath addClip];
    [fillColor setFill];
    [path fillWithBlendMode:kCGBlendModeCopy alpha:1];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(maxCornerRadius, maxCornerRadius, maxCornerRadius, maxCornerRadius);
    result = [result resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    
    return result;
}

+ (asimagenode_modification_block_t)mxr_imageModificationBlockToScaleToSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    return ^UIImage*(UIImage *originalImage){
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        UIBezierPath *roundOutline = [UIBezierPath mxr_bezierPathForRoundedRectWithCorners:UIRectCornerAllCorners radius:cornerRadius size:size];
        [roundOutline addClip];
        [originalImage drawInRect:(CGRect){CGPointZero, size} blendMode:kCGBlendModeCopy alpha:1.0f];
        UIImage *modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return modifiedImage;
    };
}

+ (asimagenode_modification_block_t)mxr_imageModificationBlockToScaleToSize:(CGSize)size maximumCornerRadius:(CGFloat)maxCornerRadius minimumCornerRadius:(CGFloat)minCornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornersToApplyMaxRadius:(UIRectCorner)roundedCorners {
    return ^UIImage*(UIImage *originalImage){
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        UIBezierPath *outerOutline = [UIBezierPath mxr_bezierPathForRoundedRectWithCorners:UIRectCornerAllCorners radius:minCornerRadius size:size];
        [outerOutline addClip];
        UIBezierPath *innerOutline = [UIBezierPath mxr_bezierPathForRoundedRectWithCorners:roundedCorners radius:maxCornerRadius size:size];
        [innerOutline addClip];
        
        [originalImage drawInRect:(CGRect){CGPointZero, size} blendMode:kCGBlendModeCopy alpha:1.0f];
        
        if (borderWidth > 0.0) {
            [borderColor setStroke];
            [outerOutline setLineWidth:borderWidth];
            [outerOutline stroke];
            [innerOutline setLineWidth:borderWidth];
            [innerOutline stroke];
        }
        
        UIImage *modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return modifiedImage;
    };
}

@end

