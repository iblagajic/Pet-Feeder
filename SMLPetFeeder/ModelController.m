//
//  ModelController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "ModelController.h"
#import "SMLDataController.h"
#import "SMLPetCardViewController.h"
#import "SMLPetCardViewModel.h"
#import "SMLPet.h"
#import "SMLFeedingEvent.h"
#import "SMLFood.h"
#import "SMLTime.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface ModelController ()

@property (nonatomic) SMLDataController *dataController;
@property (nonatomic) NSArray *cardModels;

@end

@implementation ModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataController = [SMLDataController new];
        self.cardModels = @[[self newPetCardForPetWithName:@"Marino"],
                            [self newPetCardForPetWithName:@"Micika"]];
    }
    return self;
}

- (SMLPetCardViewModel*)newPetCardForPetWithName:(NSString*)name {
    SMLPet *pet = [NSEntityDescription insertNewObjectForEntityForName:@"SMLPet" inManagedObjectContext:self.dataController.managedObjectContext];
    pet.name = name;
    SMLFeedingEvent *feedingEvent = [NSEntityDescription insertNewObjectForEntityForName:@"SMLFeedingEvent" inManagedObjectContext:self.dataController.managedObjectContext];
    feedingEvent.pet = pet;
    SMLFood *food = [NSEntityDescription insertNewObjectForEntityForName:@"SMLFood" inManagedObjectContext:self.dataController.managedObjectContext];
    food.name = @"Breakfast, 15g";
    feedingEvent.food = food;
    SMLTime *time = [NSEntityDescription insertNewObjectForEntityForName:@"SMLTime" inManagedObjectContext:self.dataController.managedObjectContext];
    time.time = [NSDate new];
    feedingEvent.time = time;
    
    SMLFeedingEvent *feedingEvent2 = [NSEntityDescription insertNewObjectForEntityForName:@"SMLFeedingEvent" inManagedObjectContext:self.dataController.managedObjectContext];
    feedingEvent2.pet = pet;
    feedingEvent2.food = food;
    feedingEvent2.time = time;
    
    SMLPetCardViewModel *petCardViewModel = [[SMLPetCardViewModel alloc] initWithPet:pet dataController:self.dataController];
    return petCardViewModel;
}

- (SMLPetCardViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.cardModels count] == 0) || (index >= [self.cardModels count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    SMLPetCardViewController *SMLPetCardViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMLPetCardViewController"];
    SMLPetCardViewController.viewModel = self.cardModels[index];
    return SMLPetCardViewController;
}

- (NSUInteger)indexOfViewController:(SMLPetCardViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.cardModels indexOfObject:viewController.viewModel];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SMLPetCardViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(SMLPetCardViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.cardModels count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

#pragma mark - Public

- (NSUInteger)numberOfCards {
    return self.cardModels.count;
}

@end
