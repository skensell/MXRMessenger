//
//  MXRMessageDateFormatter.m
//  Mixer
//
//  Created by Scott Kensell on 3/19/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageDateFormatter.h"

#import "UIColor+MXRMessenger.h"

@implementation MXRMessageDateFormatter {
    NSDateFormatter* _dateFormatter;
    NSDateFormatter* _todayOrYesterdayFormatter;
    NSDateFormatter* _thisWeekFormatter;
    NSDateFormatter* _timestampFormatter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setLocalizedDateFormatFromTemplate:@"MMMd"]; // see https://waracle.net/iphone-nsdateformatter-date-formatting-table/
        
        _todayOrYesterdayFormatter = [[NSDateFormatter alloc] init];
        [_todayOrYesterdayFormatter setLocale:[NSLocale currentLocale]];
        [_todayOrYesterdayFormatter setDoesRelativeDateFormatting:YES];
        [_todayOrYesterdayFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_todayOrYesterdayFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        _thisWeekFormatter = [[NSDateFormatter alloc] init];
        [_thisWeekFormatter setLocale:[NSLocale currentLocale]];
        [_thisWeekFormatter setLocalizedDateFormatFromTemplate:@"EEE"];
        
        _timestampFormatter = [[NSDateFormatter alloc] init];
        [_timestampFormatter setLocale:[NSLocale currentLocale]];
        [_timestampFormatter setLocalizedDateFormatFromTemplate:@"Hmm"];
        
        UIColor *color = [[UIColor mxr_bubbleLightGrayColor] mxr_darkerColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        _dateTextAttributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : paragraphStyle };
        
        _timeTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : paragraphStyle };
    }
    return self;
}

#pragma mark - MXRMessageDateFormatter

- (NSAttributedString *)attributedTextForDate:(NSDate *)date {
    if (!date) return nil;
    NSDateFormatter* dateFormatter = _dateFormatter;
    NSTimeInterval secondsAgo = [NSDate timeIntervalSinceReferenceDate] - date.timeIntervalSinceReferenceDate;
    if (secondsAgo < 86400) {
        dateFormatter = _todayOrYesterdayFormatter;
    } else if (secondsAgo < 518400) {
        dateFormatter = _thisWeekFormatter;
    }
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] initWithString:[dateFormatter stringFromDate:date] attributes:_dateTextAttributes];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:[_timestampFormatter stringFromDate:date] attributes:_timeTextAttributes]];
    return result;
}

@end
