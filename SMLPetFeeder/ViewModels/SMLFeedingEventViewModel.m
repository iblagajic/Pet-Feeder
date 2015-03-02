//
//  SMLFeedingEventViewModel.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLFeedingEventViewModel.h"
#import "SMLFeedingEvent.h"
#import "SMLMeal.h"

@interface SMLFeedingEventViewModel ()

@property (nonatomic) SMLFeedingEvent *feedingEvent;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation SMLFeedingEventViewModel

- (instancetype)initWithFeedingEvent:(SMLFeedingEvent*)feedingEvent dateFormatter:(NSDateFormatter*)dateFormatter {
    self = [super init];
    if (self) {
        self.feedingEvent = feedingEvent;
        self.dateFormatter = dateFormatter;
    }
    return self;
}

- (NSString*)title {
    return self.feedingEvent.meal.text;
}

- (NSString*)subtitle {
    NSDate *time = self.feedingEvent.time;
    NSInteger dayOfMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:time].day;
    NSString *dateString = [self.dateFormatter stringFromDate:time];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31:
            return [dateString stringByAppendingString:@"st"];
        case 2:
        case 22:
            return [dateString stringByAppendingString:@"nd"];
        case 3:
        case 23:
            return [dateString stringByAppendingString:@"rd"];
        default:
            return [dateString stringByAppendingString:@"th"];
    }
}

@end
