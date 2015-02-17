//
//  SMLFood.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 17/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLFeedingEvent;

@interface SMLFood : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@end

@interface SMLFood (CoreDataGeneratedAccessors)

- (void)addEventsObject:(SMLFeedingEvent *)value;
- (void)removeEventsObject:(SMLFeedingEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
