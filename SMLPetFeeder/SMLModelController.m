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
@property (nonatomic) RACSubject *updatedImage;

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
        self.updatedImage = [[RACSubject subject] setNameWithFormat:@"SMLModelController updatedImage"];
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)numberOfCards {
    return self.cardModels.count;
}

- (SMLPetCardViewController*)modelAtIndex:(NSUInteger)index {
    if (index > self.cardModels.count-1) {
        return nil;
    }
    return self.cardModels[index];
}

- (SMLPetCardViewModel*)modelBeforeViewModel:(SMLPetCardViewModel*)viewModel {
    NSInteger index = [self.cardModels indexOfObject:viewModel];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    return self.cardModels[index-1];
}

- (SMLPetCardViewModel*)modelAfterViewModel:(SMLPetCardViewModel*)viewModel {
    NSInteger index = [self.cardModels indexOfObject:viewModel];
    if (index == NSNotFound || index == self.cardModels.count - 1) {
        return nil;
    }
    return self.cardModels[index+1];
}

- (NSUInteger)indexOfViewModel:(SMLPetCardViewModel*)viewModel {
    return [self.cardModels indexOfObject:viewModel];
}

- (void)addNewPetWithName:(NSString*)name {
    [self.dataController addNewPetWithName:name];
    self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
    [self.updatedContent sendNext:@(self.cardModels.count-2)];
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
        [petCardViewModel.updatedImage subscribeNext:^(id x) {
            [self.updatedImage sendNext:@([self.cardModels indexOfObject:petCardViewModel])];
        }];
        [cardModels addObject:petCardViewModel];
    }
    [cardModels addObject:[SMLPetCardViewModel new]]; // We use empty pet view model for "add pet" card
    return cardModels;
}

@end
