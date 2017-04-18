//
//  UIBezierPath+MXRMessenger.m
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/UIBezierPath+MXRMessenger.h>

@implementation UIBezierPath (MXRMessenger)

+ (UIBezierPath *)mxr_bezierPathForRoundedRectWithCorners:(UIRectCorner)roundedCorners radius:(CGFloat)cornerRadius size:(CGSize)size {
    static NSCache *__pathCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __pathCache = [[NSCache alloc] init];
        // Comment from ASDK file:
        // UIBezierPath objects are fairly small and these are equally sized. 20 should be plenty for many different parameters.
        __pathCache.countLimit = 20;
    });
    typedef struct {
        UIRectCorner corners;
        CGFloat radius;
        CGSize size;
    } PathKey;
    PathKey key = { roundedCorners, cornerRadius, size };
    NSValue *pathKeyObject = [[NSValue alloc] initWithBytes:&key objCType:@encode(PathKey)];
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *path = [__pathCache objectForKey:pathKeyObject];
    if (path == nil) {
        path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} byRoundingCorners:roundedCorners cornerRadii:cornerRadii];
        [__pathCache setObject:path forKey:pathKeyObject];
    }
    return path;
}

@end
