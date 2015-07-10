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
@property (nonatomic) NSMutableArray *petModels;
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
        self.dateFormatter.dateFormat = @"eee dd hh:mm";
        self.petModels = [self petModelsForPets:[self.dataController allPets]];
        
        self.updatedContent = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController updatedContent"];
        self.addedPet = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController addedPet"];
        self.removedPet = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController removedPet"];
        self.updatedImage = [[RACSubject subject] setNameWithFormat:@"SMLAppModelController updatedImage"];
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)count {
    return self.petModels.count;
}

- (SMLPetViewModel*)modelAtIndex:(NSUInteger)index {
    if (index > self.petModels.count-1) {
        return nil;
    }
    return self.petModels[index];
}

- (SMLPetViewModel*)modelBeforeViewModel:(SMLPetViewModel*)viewModel {
    NSInteger index = [self.petModels indexOfObject:viewModel];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    return self.petModels[index-1];
}

- (SMLPetViewModel*)modelAfterViewModel:(SMLPetViewModel*)viewModel {
    NSInteger index = [self.petModels indexOfObject:viewModel];
    if (index == NSNotFound || index == self.petModels.count - 1) {
        return nil;
    }
    return self.petModels[index+1];
}

- (NSUInteger)indexOfViewModel:(SMLPetViewModel*)viewModel {
    return [self.petModels indexOfObject:viewModel];
}

- (void)addNewPetWithName:(NSString*)name {
    SMLPet *pet = [self.dataController addNewPetWithName:name];
    SMLPetViewModel *petViewModel = [self petViewModelForPet:pet];
    [self.petModels addObject:petViewModel];
    [self.addedPet sendNext:@(self.petModels.count-1)];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    SMLPetViewModel *petModel = [self modelAtIndex:index];
    if (!petModel) {
        NSLog(@"Error: no pet at index %zd", index);
    }
    [self.petModels removeObject:petModel];
    [self.dataController removePet:petModel.pet];
    [self.removedPet sendNext:@(index)];
}

- (void)updateName:(NSString*)name forPetAtIndex:(NSInteger)index {
    SMLPetViewModel *petModel = [self modelAtIndex:index];
    [petModel updateName:name];
    [self.updatedContent sendNext:@(index)];
}

- (void)updateImage:(UIImage*)image forPetAtIndex:(NSInteger)index {
    SMLPetViewModel *petModel = [self modelAtIndex:index];
    [petModel updateImage:image];
    [self.updatedContent sendNext:@(index)];
}

#pragma mark - Helpers

- (NSMutableArray*)petModelsForPets:(NSArray*)pets {
    NSMutableArray *cardModels = [NSMutableArray new];
    for (SMLPet *pet in pets) {
        SMLPetViewModel *petViewModel = [self petViewModelForPet:pet];
        [cardModels addObject:petViewModel];
    }
    return cardModels;
}

- (SMLPetViewModel*)petViewModelForPet:(SMLPet*)pet {
    SMLPetViewModel *petViewModel = [[SMLPetViewModel alloc] initWithPet:pet
                                                          dataController:self.dataController
                                                           dateFormatter:self.dateFormatter];
    [petViewModel.updatedImage subscribeNext:^(id x) {
        [self.updatedImage sendNext:@([self.petModels indexOfObject:petViewModel])];
    }];
    return petViewModel;
}

@end
