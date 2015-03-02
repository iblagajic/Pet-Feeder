//
//  SMLAppModelController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SMLStandardTableViewModel.h"

@class SMLPetViewModel;

@interface SMLAppModelController : NSObject <SMLStandardTableViewModel>

@property (nonatomic) SMLPetViewModel *currentPetModel;

@property (nonatomic, readonly) RACSubject *updatedContent;
@property (nonatomic, readonly) RACSubject *addedPet;
@property (nonatomic, readonly) RACSubject *removedPet;
@property (nonatomic, readonly) RACSubject *updatedImage;

- (NSUInteger)count;
- (SMLPetViewModel*)modelAtIndex:(NSUInteger)index;
- (SMLPetViewModel*)modelBeforeViewModel:(SMLPetViewModel*)viewModel;
- (SMLPetViewModel*)modelAfterViewModel:(SMLPetViewModel*)viewModel;
- (NSUInteger)indexOfViewModel:(SMLPetViewModel*)viewModel;
- (void)addNewPetWithName:(NSString*)name;
- (void)removeObjectAtIndex:(NSUInteger)index;

@end

