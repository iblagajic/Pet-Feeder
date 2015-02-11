//
//  SMLFeedingEvent.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMLPet;

@interface SMLFeedingEvent : NSManagedObject

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) SMLPet *pet;

@end
