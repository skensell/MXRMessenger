//
//  UIColor+MXRMessenger.m
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/UIColor+MXRMessenger.h>

@implementation UIColor (MXRMessenger)

+ (UIColor *)mxr_bubbleLightGrayColor {
    return [UIColor colorWithHue:0.6666f saturation:0.02f brightness:0.92f alpha:1.0f];
}

+ (UIColor *)mxr_fbMessengerBlue {
    return [UIColor colorWithRed:0.00 green:0.52 blue:1.00 alpha:1.0];
}

- (UIColor *)mxr_lighterColor {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h saturation:s brightness:MIN(b * 1.3, 1.0) alpha:a];
    return nil;
}

- (UIColor *)mxr_darkerColor {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h saturation:s brightness:(b * 0.75) alpha:a];
    return nil;
}

@end
