//
//  SMLFeedingEvent+Ingestion.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLFeedingEvent.h"

@interface SMLFeedingEvent (Ingestion)

+ (SMLFeedingEvent*)addFeedingEventForPet:(SMLPet*)pet meal:(SMLMeal*)meal context:(NSManagedObjectContext*)context;
+ (NSArray*)feedingEventsForPet:(SMLPet*)pet inContext:(NSManagedObjectContext*)context;

@end
