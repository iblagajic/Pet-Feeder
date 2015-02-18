//
//  SMLPetCardViewModel.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class SMLPet;
@class SMLDataController;

@interface SMLPetCardViewModel : NSObject

@property (nonatomic, readonly) RACSubject *updatedContent;

@property (nonatomic, readonly) SMLPet *pet;
@property (nonatomic, readonly) NSString *petName;
@property (nonatomic, readonly) UIImage *petImage;
@property (nonatomic, readonly) NSArray *cellModels;
@property (nonatomic, readonly) NSArray *mealAlertActions;

- (instancetype)initWithPet:(SMLPet*)pet dataController:(SMLDataController*)dataController;

- (void)addFeedingEventWithMealText:(NSString*)mealText;
- (void)updateName:(NSString*)name;
- (void)updateImage:(UIImage*)image;

@end
