//
//  SMLPetViewModel.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMLBasicCellModel.h"
#import "SMLStandardTableViewModel.h"

@class SMLPet;
@class SMLDataController;
@class SMLFeedingEventViewModel;

@interface SMLPetViewModel : NSObject <SMLBasicCellModel, SMLStandardTableViewModel>

@property (nonatomic, readonly) RACSubject *updatedFeedingEvents;

@property (nonatomic, readonly) SMLPet *pet;
@property (nonatomic, readonly) NSString *petName;
@property (nonatomic, readonly) UIImage *petImage;
@property (nonatomic, readonly) NSArray *mealAlertActions;

- (instancetype)initWithPet:(SMLPet*)pet dataController:(SMLDataController*)dataController dateFormatter:(NSDateFormatter*)dateFormatter;

- (NSUInteger)count;
- (SMLFeedingEventViewModel*)modelAtIndex:(NSUInteger)index;

- (NSString*)lastFeedingEventString;
- (void)addFeedingEventWithMealText:(NSString*)mealText;

- (void)updateName:(NSString*)name;
- (void)updateImage:(UIImage*)image;

@end
