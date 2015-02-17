//
//  SMLTime.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 17/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLFeedingEvent;

@interface SMLTime : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSSet *events;
@end

@interface SMLTime (CoreDataGeneratedAccessors)

- (void)addEventsObject:(SMLFeedingEvent *)value;
- (void)removeEventsObject:(SMLFeedingEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
