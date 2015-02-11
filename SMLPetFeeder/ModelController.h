//
//  ModelController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMLPetCardViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (SMLPetCardViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(SMLPetCardViewController *)viewController;

@end

