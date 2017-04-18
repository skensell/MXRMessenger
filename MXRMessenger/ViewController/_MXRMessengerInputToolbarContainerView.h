//
//  _MXRMessengerInputToolbarContainerView.h
//  Mixer
//
//  Created by Scott Kensell on 3/18/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MXRMessenger/MXRMessengerInputToolbar.h>

/**
 * This container view is meant to be returned as an inputAccessoryView
 * http://stackoverflow.com/questions/25816994/changing-the-frame-of-an-inputaccessoryview-in-ios-8
 */
@interface MXRMessengerInputToolbarContainerView : UIView

@property (nonatomic, strong, readonly) MXRMessengerInputToolbar* toolbarNode;

- (instancetype)initWithMessengerInputToolbar:(MXRMessengerInputToolbar *)toolbarNode constrainedSize:(ASSizeRange)constrainedSize;

@end
