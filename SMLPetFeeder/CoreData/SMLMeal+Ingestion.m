//
//  SMLMeal+Ingestion.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLMeal+Ingestion.h"

static NSString * const SMLEntityName = @"SMLMeal";

@implementation SMLMeal (Ingestion)

+ (SMLMeal*)addMealWithText:(NSString*)text context:(NSManagedObjectContext*)context {
    SMLMeal *newMeal = [SMLMeal newMealInContext:context];
    NSInteger ordinal = [SMLMeal allMealsInContext:context].count;
    newMeal.text = text;
    newMeal.ordinal = @(ordinal);
    return newMeal;
}

+ (NSArray*)allMealsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:SMLEntityName];
    NSError *err;
    NSArray *allMeals = [context executeFetchRequest:request error:&err];
    if (err) {
        NSLog(@"Error fetching meal: %@", err.localizedDescription);
    }
    return allMeals;
}

#pragma mark - Helpers

+ (SMLMeal*)newMealInContext:(NSManagedObjectContext*)context {
    return [NSEntityDescription insertNewObjectForEntityForName:SMLEntityName inManagedObjectContext:context];
}

@end
