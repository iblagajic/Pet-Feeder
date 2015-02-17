//
//  SMLPet+Ingestion.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 16/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPet.h"
#import <UIKit/UIKit.h>

@class SMLFeedingEvent;

@interface SMLPet (Ingestion)

+ (SMLPet*)addPetWithName:(NSString*)name context:(NSManagedObjectContext*)context;
+ (NSArray*)allPetsInContext:(NSManagedObjectContext*)context;
+ (void)updatePet:(SMLPet*)pet withName:(NSString*)name context:(NSManagedObjectContext*)context;
+ (BOOL)updatePet:(SMLPet*)pet withImage:(UIImage*)image context:(NSManagedObjectContext*)context;
+ (void)updatePet:(SMLPet *)pet withFeedingEvent:(SMLFeedingEvent*)feedingEvent context:(NSManagedObjectContext*)context;

@end
