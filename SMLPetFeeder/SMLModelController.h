//
//  SMLModelController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class SMLPetCardViewModel;

@interface SMLModelController : NSObject

@property (nonatomic, readonly) RACSubject *updatedContent;
@property (nonatomic, readonly) RACSubject *updatedImage;

@property (nonatomic, readonly) NSUInteger numberOfCards;

- (SMLPetCardViewModel*)modelAtIndex:(NSUInteger)index;
- (SMLPetCardViewModel*)modelBeforeViewModel:(SMLPetCardViewModel*)viewModel;
- (SMLPetCardViewModel*)modelAfterViewModel:(SMLPetCardViewModel*)viewModel;
- (NSUInteger)indexOfViewModel:(SMLPetCardViewModel*)viewModel;
- (void)addNewPetWithName:(NSString*)name;

@end

