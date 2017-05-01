//
//  Person.m
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (NSArray *)someRandomPeople {
    NSArray* peopleData = @[@[@"Keanu Reeves", @"https://scontent.fbud1-1.fna.fbcdn.net/v/t1.0-1/c29.29.365.365/s50x50/557324_445453635499514_1953039798_n.jpg?oh=4cecc009902b6a7d9e4f66fb5799969a&oe=59C233CE"],
                            @[@"Barack Obama", @"https://scontent.fbud1-1.fna.fbcdn.net/v/t1.0-1/p50x50/1376580_10151878817796749_162570700_n.png?oh=35359e5fc67a52756fc8b58cf6da4007&oe=59915D2B"],
                            @[@"Donald Trump", @"https://scontent.fbud1-1.fna.fbcdn.net/v/t1.0-1/p50x50/17903454_10158949965035725_3181251005684687258_n.jpg?oh=7a12392608fa82f76fd0d126ef2b9766&oe=597EDEA1"]];
    NSMutableArray* allPeople = [[NSMutableArray alloc] init];
    for (int i = 0; i < peopleData.count; i++) {
        Person* p = [[Person alloc] init];
        p.name = peopleData[i][0];
        p.avatarURL = [NSURL URLWithString:peopleData[i][1]];
        [allPeople addObject:p];
    }
    return allPeople;
}

@end
