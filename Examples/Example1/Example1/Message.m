//
//  Message.m
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import "Message.h"

#import <UIKit/UIKit.h>

@implementation Message

+ (instancetype)randomMessage {
    static dispatch_once_t onceToken;
    static NSArray* texts = nil;
    static NSArray* linkTexts = nil;
    static NSArray* photoCategories = nil;
    dispatch_once(&onceToken, ^{
        texts = @[@"You ever have the feeling that you're not sure if you're awake or still dreaming?",
                  @"All the time. It's called mescaline and it is the only way to fly.",
                  @"It sounds to me like you need to unplug, man. A little R&R. What do you think, Dujour, should we take him with us?",
                  @"Definitely.",
                  @"Frankly, my dear, I don't give a damn.",
                  @"I'm gonna make him an offer he can't refuse.",
                  @"Here's looking at you, kid.",
                  @"May the Force be with you.",
                  @"Bond. James Bond.",
                  @"Show me the money!",
                  @"My mama always said life was like a box of chocolates. You never know what you're gonna get.",
                  @"Are you sure this line is clean?",
                  @"Yeah, 'course I'm sure.",
                  @"I'd better go.",
                  @"Lieutenant...",
                  @"You got the money?",
                  @"Two grand.",
                  @"Something wrong, man? You look a little whiter than usual.",
                  @"My computer....it..you ever have that feeling where you don't know if you're awake or still dreaming?",
                  @"Trinity..._The_ Trinity? The one the cracked the IRS d-base?",
                  @"Please, just listen. I know why you're here, Neo. I know what you've been doing. I know why you hardly sleep, and why night after night you sit at your computer. You're looking for him. I know, because I was once looking for the same thing. And when he found me, he told me I wasn't really looking for him, I was looking for an answer. It's the question that drives us, Neo. It's the question that brought you here. You know the question, just as I did...",
                  @"What is the Matrix?",
                  @"The answer is out there, Neo. It's looking for you...and it will find you...if you want it to....",
                  @"You have a problem with authority, Mr. Anderson.",
                  @"Yeah, that's me.",
                  @"Hello, Neo. Do you know who this is?",
                  @"Morpheus?",
                  @"Yes...I've been looking for you, Neo. I don't know if you're ready to see what I want to show you, but unfortunately you and I have run out of time. They're coming for you, Neo, and I don't know what they're going to do.",
                  ];
        linkTexts = @[@"Hey, here's that link to google: http://www.google.com. It's just the search engine.",
                      @"Here's a long link to Mount hood: https://www.google.com/maps/place/Mt+Hood/@45.3736131,-121.704706,15z/data=!4m5!3m4!1s0x54be1c5501719a05:0x831d76c0b7aea9ea!8m2!3d45.373615!4d-121.6959511 and a little text after it.",
                      @"facebook.com",
                      @"www.facebook.com",
                      @"https://www.nytimes.com/2017/12/06/upshot/what-happened-to-the-american-boomtown.html?hp&action=click&pgtype=Homepage&clickSource=story-heading&module=second-column-region&region=top-news&WT.nav=top-news is a nytimes article. You should check it out.",
                      @"Check out that NYTimes article again: https://www.nytimes.com/2017/12/06/upshot/what-happened-to-the-american-boomtown.html?hp&action=click&pgtype=Homepage&clickSource=story-heading&module=second-column-region&region=top-news&WT.nav=top-news",
                      @"Check out facebook.com and http://www.google.com and https://www.instagram.com"];
        photoCategories = @[@"abstract", @"city", @"people", @"transport", @"animals", @"food", @"nature", @"business", @"nightlife", @"sports", @"cats", @"fashion", @"technics"];
    });
    Message* m = [[Message alloc] init];
    m.senderID = arc4random_uniform(2);
    if (arc4random_uniform(100) < 10) {
        NSUInteger numberOfMedia = arc4random_uniform(100) < 50 ? 1 : (arc4random_uniform(9) + 1);
        NSMutableArray* media = [[NSMutableArray alloc] init];
        for (int i = 0; i < numberOfMedia; i++) {
            MessageMedium* medium = [[MessageMedium alloc] init];
            medium.photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lorempixel.com/%@/%@", (arc4random_uniform(2) > 0 ? @"320/180" : @"180/320"), photoCategories[arc4random_uniform((uint32_t)photoCategories.count)]]];
            [media addObject:medium];
        }
        m.media = media;
    } else {
//        m.text = linkTexts[arc4random_uniform((uint32_t)linkTexts.count)];
        m.text = texts[arc4random_uniform((uint32_t)texts.count)];
    }
    return m;
}

@end


@implementation MessageMedium

- (NSURL *)mxr_messenger_imageURLForSize:(CGSize)renderedSizeInPoints {
    return self.photoURL;
}

- (NSURL *)mxr_messenger_videoURLForSize:(CGSize)renderedSizeInPoints {
    return self.videoURL;
}

@end
