//
//  SMLRootViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLRootViewController.h"
#import "SMLModelController.h"
#import "SMLPetCardViewController.h"
#import "SMLAddPetViewController.h"

@interface SMLRootViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) SMLModelController *modelController;
@end

@implementation SMLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    UIViewController *startingViewController = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    self.pageControl.numberOfPages = self.modelController.numberOfCards;
}

- (SMLModelController*)modelController {
    if (!_modelController) {
        _modelController = [SMLModelController new];
    }
    return _modelController;
}

#pragma mark - UIPageViewControllerDelegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    SMLPetCardViewController *currentViewController = self.pageViewController.viewControllers[0];
    self.pageControl.currentPage = [self.modelController indexOfViewModel:currentViewController.viewModel];
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
    return [self viewControllerAtIndex:index++ storyboard:viewController.storyboard];
}

#pragma mark - Helpers

- (UIViewController*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    if (index == self.modelController.numberOfCards) {
        return [storyboard instantiateViewControllerWithIdentifier:@"SMLAddPetViewController"];
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
