//
//  SMLDataController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMLPet, SMLMeal, SMLFeedingEvent;

@interface SMLDataController : NSObject

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray*)allPets;
- (SMLPet*)addNewPetWithName:(NSString*)petName;
- (void)removePet:(SMLPet*)pet;
- (BOOL)updatePet:(SMLPet*)pet withImage:(UIImage*)image;
- (void)updatePet:(SMLPet*)pet withName:(NSString*)name;
- (NSArray*)allMeals;
- (SMLMeal*)addNewMealWithText:(NSString*)text;
- (NSArray*)feedingEventsForPet:(SMLPet*)pet count:(NSInteger)count;
- (SMLFeedingEvent*)addNewFeedingEventWithMeal:(SMLMeal*)meal forPet:(SMLPet*)pet;

@end
