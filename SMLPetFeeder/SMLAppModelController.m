//
//  SMLAppModelController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLAppModelController.h"
#import "SMLDataController.h"
#import "SMLPetViewModel.h"

@class SMLPet;

@interface SMLAppModelController ()

@property (nonatomic) SMLDataController *dataController;
@property (nonatomic) NSArray *cardModels;
@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) RACSubject *updatedContent;
@property (nonatomic) RACSubject *addedPet;
@property (nonatomic) RACSubject *removedPet;
@property (nonatomic) RACSubject *updatedImage;

@end

@implementation SMLAppModelController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataController = [SMLDataController new];
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"eee, dd";
        self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
        
        self.updatedContent = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController updatedContent"];
        self.addedPet = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController addedPet"];
        [self.addedPet subscribeNext:^(id x) {
            [self.updatedContent sendNext:x];
        }];
        self.removedPet = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController removedPet"];
        [self.removedPet subscribeNext:^(id x) {
            [self.updatedContent sendNext:x];
        }];
        self.updatedImage = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController updatedImage"];
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)count {
    return self.cardModels.count;
}

- (SMLPetViewModel*)modelAtIndex:(NSUInteger)index {
    if (index > self.cardModels.count-1) {
        return nil;
    }
    return self.cardModels[index];
}

- (SMLPetViewModel*)modelBeforeViewModel:(SMLPetViewModel*)viewModel {
    NSInteger index = [self.cardModels indexOfObject:viewModel];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    return self.cardModels[index-1];
}

- (SMLPetViewModel*)modelAfterViewModel:(SMLPetViewModel*)viewModel {
    NSInteger index = [self.cardModels indexOfObject:viewModel];
    if (index == NSNotFound || index == self.cardModels.count - 1) {
        return nil;
    }
    return self.cardModels[index+1];
}

- (NSUInteger)indexOfViewModel:(SMLPetViewModel*)viewModel {
    return [self.cardModels indexOfObject:viewModel];
}

- (void)addNewPetWithName:(NSString*)name {
    [self.dataController addNewPetWithName:name];
    self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
    [self.addedPet sendNext:@(self.cardModels.count-1)];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    SMLPetViewModel *petModel = [self modelAtIndex:index];
    [self.dataController removePet:petModel.pet];
    self.cardModels = [self cardModelsWithPets:[self.dataController allPets]];
    [self.removedPet sendNext:@(MIN(self.cardModels.count, index))];
}

#pragma mark - Helpers

- (NSArray*)cardModelsWithPets:(NSArray*)pets {
    NSMutableArray *cardModels = [NSMutableArray new];
    for (SMLPet *pet in pets) {
        SMLPetViewModel *petCardViewModel = [[SMLPetViewModel alloc] initWithPet:pet
                                                                  dataController:self.dataController
                                                                   dateFormatter:self.dateFormatter];
        [petCardViewModel.updatedImage subscribeNext:^(id x) {
            [self.updatedImage sendNext:@([self.cardModels indexOfObject:petCardViewModel])];
        }];
        [cardModels addObject:petCardViewModel];
    }
    return cardModels;
}

@end
