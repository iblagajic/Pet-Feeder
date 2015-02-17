//
//  SMLPet.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 17/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLFeedingEvent;

@interface SMLPet : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ordinal;
@property (nonatomic, retain) NSSet *feedingEvents;
@end

@interface SMLPet (CoreDataGeneratedAccessors)

- (void)addFeedingEventsObject:(SMLFeedingEvent *)value;
- (void)removeFeedingEventsObject:(SMLFeedingEvent *)value;
- (void)addFeedingEvents:(NSSet *)values;
- (void)removeFeedingEvents:(NSSet *)values;

@end
