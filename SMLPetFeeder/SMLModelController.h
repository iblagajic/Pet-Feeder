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

- (NSUInteger)numberOfCards;
- (SMLPetCardViewModel*)viewModelAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewModel:(SMLPetCardViewModel*)viewController;
- (void)addNewPetWithName:(NSString*)name;

@end

