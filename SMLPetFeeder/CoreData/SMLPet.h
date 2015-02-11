//
//  SMLPet.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMLPet : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *feedingEvents;
@end

@interface SMLPet (CoreDataGeneratedAccessors)

- (void)addFeedingEventsObject:(NSManagedObject *)value;
- (void)removeFeedingEventsObject:(NSManagedObject *)value;
- (void)addFeedingEvents:(NSSet *)values;
- (void)removeFeedingEvents:(NSSet *)values;

@end
