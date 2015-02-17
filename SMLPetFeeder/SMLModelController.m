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
#import "SMLFood.h"
#import "SMLAddPetViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface SMLModelController ()

@property (nonatomic) SMLDataController *dataController;
@property (nonatomic) NSArray *cardModels;

@end

@implementation SMLModelController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataController = [SMLDataController new];
        self.cardModels = [self.dataController allPets];
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)numberOfCards {
    return self.cardModels.count;
}

- (SMLPetCardViewModel*)viewModelAtIndex:(NSUInteger)index {
    return self.cardModels[index];
}

- (NSUInteger)indexOfViewModel:(SMLPetCardViewModel*)viewModel {
    return [self.cardModels indexOfObject:viewModel];
}

- (void)addNewPetWithName:(NSString*)name {
    [self.dataController addNewPetWithName:name];
    self.cardModels = [self.dataController allPets];
}

@end
