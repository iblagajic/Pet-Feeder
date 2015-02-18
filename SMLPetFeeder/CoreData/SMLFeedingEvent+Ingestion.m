//
//  SMLFeedingEvent+Ingestion.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLFeedingEvent+Ingestion.h"

static NSString * const SMLEntityName = @"SMLFeedingEvent";

@implementation SMLFeedingEvent (Ingestion)

+ (SMLFeedingEvent*)addFeedingEventForPet:(SMLPet*)pet meal:(SMLMeal*)meal context:(NSManagedObjectContext*)context {
    SMLFeedingEvent *newFeedingEvent = [SMLFeedingEvent newFeedingEventInContext:context];
    newFeedingEvent.pet = pet;
    newFeedingEvent.meal = meal;
    newFeedingEvent.time = [NSDate new];
    return newFeedingEvent;
}

+ (NSArray*)feedingEventsForPet:(SMLPet*)pet inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:SMLEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"pet = %@", pet];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    NSError *err;
    NSArray *allFeedingEvents = [context executeFetchRequest:request error:&err];
    if (err) {
        NSLog(@"Error fetching pet: %@", err.localizedDescription);
    }
    return allFeedingEvents;
}

#pragma mark - Helpers

+ (SMLFeedingEvent*)newFeedingEventInContext:(NSManagedObjectContext*)context {
    return [NSEntityDescription insertNewObjectForEntityForName:SMLEntityName inManagedObjectContext:context];
}

@end
