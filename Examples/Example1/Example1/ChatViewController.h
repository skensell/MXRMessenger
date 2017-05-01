//
//  MXRExampleViewController.h
//  MXRMessenger
//
//  Created by Scott Kensell on 4/18/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import <MXRMessenger/MXRMessengerViewController.h>

@class Person;

@interface ChatViewController : MXRMessengerViewController

- (instancetype)initWithPerson:(Person*)person;

@end
