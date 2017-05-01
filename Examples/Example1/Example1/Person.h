//
//  Person.h
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSURL* avatarURL;

+ (NSArray*)someRandomPeople;

@end
