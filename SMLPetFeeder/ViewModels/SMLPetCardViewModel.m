//
//  SMLPetCardViewModel.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetCardViewModel.h"
#import "SMLPet+Ingestion.h"
#import "SMLFeedingEvent.h"
#import "SMLFeedingEventViewModel.h"
#import "SMLDataController.h"
#import "SMLMeal.h"

@interface SMLPetCardViewModel ()

@property (nonatomic) SMLPet *pet;
@property (nonatomic) SMLDataController *dataController;
@property (nonatomic) NSArray *cellModels;
@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) RACSubject *updatedContent;

@end

@implementation SMLPetCardViewModel

- (instancetype)initWithPet:(SMLPet*)pet dataController:(SMLDataController*)dataController dateFormatter:(NSDateFormatter*)dateFormatter {
    self = [super init];
    if (self) {
        self.pet = pet;
        self.dataController = dataController;
        self.updatedContent = [[RACSubject subject] setNameWithFormat:@"SMLPetCardViewModel updatedContent"];
        self.dateFormatter = dateFormatter;
        [self loadCellModels];
    }
    return self;
}

#pragma mark - Model
#pragma mark Pet

- (NSString*)petName {
    return self.pet.name;
}

- (UIImage*)petImage {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;;
    if (!basePath) {
        return nil;
    }
    NSString *path = [basePath stringByAppendingPathComponent:self.pet.image];
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark Feeding Events

- (NSArray*)feedingEvents {
    NSArray *feedingEvents = [self.pet.feedingEvents.allObjects sortedArrayUsingComparator:^NSComparisonResult(SMLFeedingEvent *obj1, SMLFeedingEvent *obj2) {
        return [obj1.time timeIntervalSinceReferenceDate] < [obj2.time timeIntervalSinceReferenceDate];
    }];
    return feedingEvents;
}

- (void)loadCellModels {
    NSMutableArray *array = [NSMutableArray new];
    for (SMLFeedingEvent *feedingEvent in self.feedingEvents) {
        SMLFeedingEventViewModel *viewModel = [[SMLFeedingEventViewModel alloc] initWithFeedingEvent:feedingEvent dateFormatter:self.dateFormatter];
        [array addObject:viewModel];
    }
    self.cellModels = array;
    [self.updatedContent sendNext:nil];
}

- (void)addFeedingEventWithMealText:(NSString*)mealText {
    SMLMeal *meal = [self.dataController addNewMealWithText:mealText];
    [self addFeedingEventWithMeal:meal];
}

- (void)addFeedingEventWithMeal:(SMLMeal*)meal {
    [self.dataController addNewFeedingEventWithMeal:meal forPet:self.pet];
    [self loadCellModels];
}

#pragma mark Meals

- (NSArray*)mealAlertActions {
    NSMutableArray *actions = [NSMutableArray new];
    for (SMLMeal *meal in self.dataController.allMeals) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:meal.text style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self addFeedingEventWithMeal:meal];
        }];
        [actions addObject:action];
    }
    return actions;
}

#pragma mark - Updates

- (void)updateName:(NSString*)name {
    [self.dataController updatePet:self.pet withName:name];
    [self.updatedContent sendNext:nil];
}

- (void)updateImage:(UIImage*)image {
    [self.dataController updatePet:self.pet withImage:image];
    [self.updatedContent sendNext:nil];
}

@end
