//
//  UIBezierPath+MXRMessenger.h
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (MXRMessenger)

// Uses a cache to prevent creating tons of UIBezierPath objects.
// Adapted from ASDK method of similar name
+ (UIBezierPath*)mxr_bezierPathForRoundedRectWithCorners:(UIRectCorner)roundedCorners radius:(CGFloat)cornerRadius size:(CGSize)size;

@end
