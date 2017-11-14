//
//  MXRMessengerViewController.h
//  Mixer
//
//  Created by Scott Kensell on 2/22/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import <MXRMessenger/MXRMessengerNode.h>
#import <MXRMessenger/MXRMessengerInputToolbar.h>


@interface MXRMessengerViewController : ASViewController <MXRMessengerNode*> <ASTableDelegate>

@property (nonatomic, strong, readonly) MXRMessengerInputToolbar* toolbar;

- (instancetype)initWithNode:(MXRMessengerNode *)node toolbar:(MXRMessengerInputToolbar*)toolbar NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithToolbar:(MXRMessengerInputToolbar*)toolbar;

/**
 * Override to provide custom top inset if the content spills under some view at the top.
 * This may need some playing with because of iOS 11 and iPhone X.
 * Defaults to calculating the height of status and nav bars + 6.
 */
- (CGFloat)calculateTopInset;

- (void)dismissKeyboard;


@end
