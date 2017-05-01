//
//  MXRMessengerMedium.h
//  Mixer
//
//  Created by Scott Kensell on 4/4/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#ifndef MXRMessengerMedium_h
#define MXRMessengerMedium_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MXRMessengerMedium <NSObject>

- (NSURL*)mxr_messenger_imageURLForSize:(CGSize)renderedSizeInPoints;
- (NSURL*)mxr_messenger_videoURLForSize:(CGSize)renderedSizeInPoints;

@end

#endif /* MXRMessengerMedium_h */
