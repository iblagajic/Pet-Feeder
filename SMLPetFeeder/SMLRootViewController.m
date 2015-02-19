//
//  SMLRootViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLRootViewController.h"
#import "SMLModelController.h"
#import "SMLPetCardViewModel.h"
#import "SMLPetCardViewController.h"
#import "SMLAddPetViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTScope.h"

typedef void(^SimpleBlock)();

@interface SMLRootViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) SMLModelController *modelController;
@end

@implementation SMLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self setupModelController];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self refreshPageViewControllerWithViewControllerAtIndex:0 animated:NO];
    UIImage *image = [self.modelController viewModelAtIndex:0].petImage;
    if (image) {
        self.backgroundImageView.image = image;
    }

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    [self.pageViewController didMoveToParentViewController:self];

    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

#pragma mark - Setup

- (void)setupModelController {
    self.modelController = [SMLModelController new];
    @weakify(self);
    [self.modelController.updatedContent subscribeNext:^(NSNumber *index) {
        @strongify(self);
        if (index) {
            [self refreshPageViewControllerWithViewControllerAtIndex:index.integerValue animated:YES];
        } else {
            UIViewController *currentViewController = self.pageViewController.viewControllers[0];
            [self refreshBackgroundForViewModelAtIndex:[self.modelController indexOfViewModel:[(SMLPetCardViewController*)currentViewController viewModel]]];
        }
    }];
}

#pragma mark - Refresh

- (void)refreshPageViewControllerWithViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated {
    SimpleBlock block = ^(){
        UIViewController *startingViewController = [self viewControllerAtIndex:index storyboard:self.storyboard];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        self.pageControl.numberOfPages = self.modelController.numberOfCards+1;
    };
    
    if (animated) {
        [self fadeOutView:self.pageViewController.view
               completion:^{
                   block();
                   [self fadeInView:self.pageViewController.view
                         completion:nil];
               }];
    } else {
        block();
    }
}

- (void)refreshBackgroundForViewModelAtIndex:(NSInteger)index {
//    [self fadeOutView:self.backgroundImageView completion:^{
        UIImage *image = [self.modelController viewModelAtIndex:index].petImage;
        if (image) {
            self.backgroundImageView.image = image;
        }
//        [self fadeInView:self.backgroundImageView completion:nil];
//    }];
}

- (void)fadeOutView:(UIView*)view completion:(SimpleBlock)completion {
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)fadeInView:(UIView*)view completion:(SimpleBlock)completion {
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

#pragma mark - UIPageViewControllerDelegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    if ([currentViewController isKindOfClass:[SMLAddPetViewController class]]) {
        self.pageControl.currentPage = self.modelController.numberOfCards;
        return;
    }
    NSInteger index = [self.modelController indexOfViewModel:[(SMLPetCardViewController*)currentViewController viewModel]];
    self.pageControl.currentPage = index;
    [self refreshBackgroundForViewModelAtIndex:index];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(SMLPetCardViewController*)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

#pragma mark - Helpers

- (UIViewController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    if (index == self.modelController.numberOfCards) {
        SMLAddPetViewController *addPetViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMLAddPetViewController"];
        addPetViewController.modelController = self.modelController;
        return addPetViewController;
    }
    if (index > self.modelController.numberOfCards) {
        return nil;
    }
    SMLPetCardViewController *petCardViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMLPetCardViewController"];
    petCardViewController.viewModel = [self.modelController viewModelAtIndex:index];
    return petCardViewController;
}

- (NSUInteger)indexOfViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[SMLAddPetViewController class]]) {
        return self.modelController.numberOfCards;
    }
    return [self.modelController indexOfViewModel:[(SMLPetCardViewController*)viewController viewModel]];
}

@end
