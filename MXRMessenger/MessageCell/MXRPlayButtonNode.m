//
//  MXRPlayButtonNode.m
//  Mixer
//
//  Created by Scott Kensell on 4/12/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRPlayButtonNode.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@implementation MXRPlayButtonNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

+ (CGSize)suggestedSizeWhenRenderedOverImageWithSizeInPoints:(CGSize)imageSize {
    CGFloat smallerSide = MIN(imageSize.width, imageSize.height);
    if (smallerSide >= 140.0f) return CGSizeMake(70.0, 70.0f);
    return CGSizeMake(0.50f*smallerSide, 0.50f*smallerSide);
}

+ (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing {
    
    UIColor *white = [UIColor whiteColor];
    
    UIColor *fadedBlack = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    CGFloat borderWidth = (2.5f/70.0f)*w;
    CGFloat tw = (22.4f/70.0f)*w; // triangle width and height
    CGFloat th = tw;
    CGFloat shift = (3.0f/70.0f)*w;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* outerCirclePath = [UIBezierPath bezierPathWithOvalInRect:bounds];
    [outerCirclePath addClip];
    [fadedBlack setFill];
    [outerCirclePath fill];
    
    [white setStroke];
    [outerCirclePath setLineWidth:borderWidth];
    [outerCirclePath stroke];
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    CGPoint triangleOrigin = CGPointMake((w - tw)/2.0f + shift, (h - th)/2.0f);
    [trianglePath moveToPoint:triangleOrigin];
    [trianglePath addLineToPoint:CGPointMake((w + tw)/2.0f + shift, h/2.0f)];
    [trianglePath addLineToPoint:CGPointMake((w - tw)/2.0f + shift, (h + th)/2.0f)];
    [trianglePath addLineToPoint:triangleOrigin];
    [trianglePath closePath];
    
    [white setFill];
    [trianglePath fill];
    
    CGContextRestoreGState(context);
}

@end
