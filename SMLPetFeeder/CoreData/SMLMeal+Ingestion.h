//
//  SMLMeal+Ingestion.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLMeal.h"

@interface SMLMeal (Ingestion)

+ (SMLMeal*)addMealWithText:(NSString*)text context:(NSManagedObjectContext*)context;
+ (NSArray*)allMealsInContext:(NSManagedObjectContext*)context;

@end
