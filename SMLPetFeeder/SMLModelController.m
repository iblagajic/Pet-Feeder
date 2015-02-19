//
//  SMLModelController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLModelController.h"
#import "SMLDataController.h"
#import "SMLPetCardViewController.h"
#import "SMLPetCardViewModel.h"
#import "SMLPet.h"
#import "SMLFeedingEvent.h"
#import "SMLMeal.h"
#import "SMLAddPetViewController.h"

@interface SMLModelController ()

@property (nonatomic) SMLDataController *dataController;
@property (nonatomic) NSArray *cardModels;
@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) RACSubject *updatedContent;

@end

@implementation SMLModelController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataController = [SMLDataController new];
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"eee, dd'th' hh:mma";
        self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
        
        self.updatedContent = [[RACSubject subject] setNameWithFormat:@"SMLModelController updatedContent"];
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)numberOfCards {
    return self.cardModels.count;
}

- (SMLPetCardViewModel*)viewModelAtIndex:(NSUInteger)index {
    if (self.cardModels.count > index) {
        return self.cardModels[index];
    }
    return nil;
}

- (NSUInteger)indexOfViewModel:(SMLPetCardViewModel*)viewModel {
    return [self.cardModels indexOfObject:viewModel];
}

- (void)addNewPetWithName:(NSString*)name {
    [self.dataController addNewPetWithName:name];
    self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
    [self.updatedContent sendNext:@(self.cardModels.count-1)];
}

- (void)removePetForViewModel:(SMLPetCardViewModel*)viewModel {
    NSInteger index = [self indexOfViewModel:viewModel];
    [self.dataController removePet:viewModel.pet];
    self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
    [self.updatedContent sendNext:@(MIN(self.cardModels.count, index))];
}

#pragma mark - Helpers

- (NSArray*)cardModelsWithPets:(NSArray*)pets {
    NSMutableArray *cardModels = [NSMutableArray new];
    for (SMLPet *pet in pets) {
        SMLPetCardViewModel *petCardViewModel = [[SMLPetCardViewModel alloc] initWithPet:pet dataController:self.dataController dateFormatter:self.dateFormatter];
        [cardModels addObject:petCardViewModel];
    }
    return cardModels;
}

@end
