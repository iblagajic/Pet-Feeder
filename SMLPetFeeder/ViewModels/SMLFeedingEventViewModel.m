//
//  SMLFeedingEventViewModel.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLFeedingEventViewModel.h"
#import "SMLFeedingEvent.h"
#import "SMLFood.h"

@interface SMLFeedingEventViewModel ()

@property (nonatomic) SMLFeedingEvent *feedingEvent;

@end

@implementation SMLFeedingEventViewModel

- (instancetype)initWithFeedingEvent:(SMLFeedingEvent*)feedingEvent {
    self = [super init];
    if (self) {
        self.feedingEvent = feedingEvent;
    }
    return self;
}

- (NSString*)title {
    return self.feedingEvent.food.name;
}

- (NSString*)subtitle {
    return [self.feedingEvent.time descriptionWithLocale:[NSLocale currentLocale]];
}

@end
