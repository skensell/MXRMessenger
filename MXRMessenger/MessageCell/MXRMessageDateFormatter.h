//
//  MXRMessageDateFormatter.h
//  Mixer
//
//  Created by Scott Kensell on 3/19/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MXRMessageDateFormatter <NSObject>

- (NSAttributedString *)attributedTextForDate:(NSDate *)date;

@end


@interface MXRMessageDateFormatter : NSObject <MXRMessageDateFormatter>

@property (nonatomic, strong) NSDictionary *dateTextAttributes; // for the date portion
@property (nonatomic, strong) NSDictionary *timeTextAttributes; // for the time portion

@end

