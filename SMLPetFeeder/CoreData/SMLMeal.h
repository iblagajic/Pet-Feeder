//
//  SMLMeal.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLFeedingEvent;

@interface SMLMeal : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) NSSet *feedingEvents;
@end

@interface SMLMeal (CoreDataGeneratedAccessors)

- (void)addFeedingEventsObject:(SMLFeedingEvent *)value;
- (void)removeFeedingEventsObject:(SMLFeedingEvent *)value;
- (void)addFeedingEvents:(NSSet *)values;
- (void)removeFeedingEvents:(NSSet *)values;

@end
