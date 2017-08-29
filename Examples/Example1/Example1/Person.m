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
    NSArray* peopleData = @[@[@"Keanu Reeves", @"http://vignette2.wikia.nocookie.net/mst3k/images/0/0c/RiffTrax-_Keanu_Reeves_in_The_Matrix.jpg/revision/latest?cb=20140609075119"],
                            @[@"Barack Obama", @"https://vignette4.wikia.nocookie.net/thefutureofeuropes/images/a/ae/Obama-head.png/revision/latest?cb=20140629212721"],
                            @[@"Donald Trump", @"https://upload.wikimedia.org/wikipedia/commons/9/9e/Donald_Trump_crop_2015.jpeg"]];
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
