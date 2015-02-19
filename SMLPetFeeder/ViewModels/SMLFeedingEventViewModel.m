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
    return [self.dateFormatter stringFromDate:self.feedingEvent.time];
}

@end
