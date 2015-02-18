//
//  SMLFeedingEvent.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLMeal, SMLPet;

@interface SMLFeedingEvent : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) SMLMeal *meal;
@property (nonatomic, retain) SMLPet *pet;

@end
