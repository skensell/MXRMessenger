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

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 * Defaults to calculating the height of status and nav bars + 6.
 * Called in `viewDidLoad`.
 */
- (CGFloat)calculateTopInset;

- (void)dismissKeyboard;


@end
