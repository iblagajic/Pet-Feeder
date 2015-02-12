//
//  RootViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "SMLPetCardViewController.h"

@interface RootViewController () <UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) ModelController *modelController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    SMLPetCardViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self.modelController;

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

- (ModelController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
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
    self.pageControl.currentPage = [self.modelController indexOfViewController:currentViewController];
}

//#pragma mark - UIPageViewControllerDataSource
//
//- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(SMLPetCardViewController*)viewController {
//    NSInteger index = [self.modelController indexOfViewController:viewController];
//    return [self.modelController viewControllerAtIndex:index+1 storyboard:self.storyboard];
//}
//
//- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(SMLPetCardViewController*)viewController {
//    NSInteger index = [self.modelController indexOfViewController:viewController];
//    return [self.modelController viewControllerAtIndex:index-1 storyboard:self.storyboard];
//}

@end
