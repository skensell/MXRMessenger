//
//  Message.h
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MXRMessenger/MXRMessengerMedium.h>

@class MessageMedium;

@interface Message : NSObject

@property (nonatomic, assign) NSInteger senderID;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSArray<MessageMedium*>* media;

+ (instancetype)randomMessage;

@end

@interface MessageMedium : NSObject <MXRMessengerMedium>

@property (nonatomic, strong) NSURL* photoURL;
@property (nonatomic, strong) NSURL* videoURL;

@end
