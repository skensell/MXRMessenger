//
//  MXRMessageNodeConfiguration.m
//  Mixer
//
//  Created by Scott Kensell on 3/31/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageNodeConfiguration.h"

#import "UIColor+MXRMessenger.h"

@implementation MXRMessageNodeConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        // MXRMessageTextConfiguration calculates the maxCornerRadius based on the provided font
        // to create a perfect semicircle on edge. You can apply that cornerRadius to other configurations
        // like MXRMessageImageConfiguration so that it matches better.
        _maxCornerRadius = 18.0f;
        _minCornerRadius = 5.0f;
    }
    return self;
}

@end
