//
//  PetFeederTests.m
//  PetFeederTests
//
//  Created by Ivan Blagajić on 05/05/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SMLAppModelController.h"
#import "SMLPetViewModel.h"
#import "SMLPet.h"
#import "SMLDataController.h"

@interface PetFeeder_Tests : XCTestCase

@property (nonatomic) SMLAppModelController *appModelController;

@end

@implementation PetFeeder_Tests

- (void)setUp {
    [super setUp];
    self.appModelController = [[SMLAppModelController alloc] init];
    [self removeAllPets];
}

- (void)tearDown {
    self.appModelController = nil;
    [super tearDown];
}

- (void)testOrdinals {
    [self.appModelController addNewPetWithName:@"Lady"];
    [self.appModelController addNewPetWithName:@"Tramp"];
    [self.appModelController addNewPetWithName:@"Beethoven"];
    [self.appModelController addNewPetWithName:@"Garfield"];
    
    [self ensureOrdinalsUpdated];
    
    [self.appModelController removeObjectAtIndex:0];
    
    [self ensureOrdinalsUpdated];
    
    [self.appModelController addNewPetWithName:@"Lady"];
    [self.appModelController addNewPetWithName:@"Marino"];
    
    [self ensureOrdinalsUpdated];
}

- (void)ensureOrdinalsUpdated {
    for (NSInteger i=0; i<self.appModelController.count; i++) {
        SMLPetViewModel *petViewModel = [self.appModelController modelAtIndex:i];
        XCTAssert(petViewModel.pet.ordinal.integerValue == i, @"Wrong ordinal");
    }
}

- (void)removeAllPets {
    for (NSInteger i=0; i<self.appModelController.count; i++) {
        [self.appModelController removeObjectAtIndex:i];
    }
}

@end
