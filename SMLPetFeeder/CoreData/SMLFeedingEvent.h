//
//  SMLFeedingEvent.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 17/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLFood, SMLPet, SMLTime;

@interface SMLFeedingEvent : NSManagedObject

@property (nonatomic, retain) SMLPet *pet;
@property (nonatomic, retain) SMLTime *time;
@property (nonatomic, retain) SMLFood *food;

@end
