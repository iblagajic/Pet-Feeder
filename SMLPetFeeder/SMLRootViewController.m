//
//
//  SMLRootViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLRootViewController.h"
#import "UIViewController+SML.h"
#import "SMLModelController.h"
#import "SMLPetCardViewModel.h"
#import "SMLPetCardViewController.h"
#import "SMLAddPetViewController.h"

@interface SMLRootViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) SMLModelController *modelController;

@property (nonatomic, readonly) SMLPetCardViewModel *currentViewModel;

@end

@implementation SMLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupModelController];
    [self setupPageViewController];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    [self refreshViewAtIndex:0 animated:NO];
}

#pragma mark - Setup

- (void)setupPageViewController {
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
}

- (void)setupModelController {
    self.modelController = [SMLModelController new];
    @weakify(self);
    [self.modelController.updatedContent subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self refreshViewAtIndex:index.integerValue animated:YES];
    }];
    [self.modelController.updatedImage subscribeNext:^(id x) {
        @strongify(self);
        [self refreshBackground];
    }];
}

#pragma mark - Refresh

- (void)refreshViewAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self refreshPageViewControllerWithIndex:index animated:animated];
    [self refreshBackground];
    [self refreshPageControl];
}

- (void)refreshPageViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated {
    SimpleBlock block = ^(){
        UIViewController *startingViewController = [self viewControllerForViewModel:[self.modelController modelAtIndex:index] storyboard:self.storyboard];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        self.pageControl.numberOfPages = self.modelController.numberOfCards;
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

- (void)refreshBackground {
    UIImage *image = self.currentViewModel.petImage;
    if (image) {
        self.backgroundImageView.image = image;
    }
}

- (void)refreshPageControl {
    self.pageControl.currentPage = [self.modelController indexOfViewModel:self.currentViewModel];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self refreshBackground];
    [self refreshPageControl];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(SMLPetCardViewController*)viewController {
    SMLPetCardViewModel *previousViewModel = [self.modelController modelBeforeViewModel:viewController.viewModel];
    return [self viewControllerForViewModel:previousViewModel storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(SMLPetCardViewController*)viewController {
    SMLPetCardViewModel *nextModel = [self.modelController modelAfterViewModel:viewController.viewModel];
    return [self viewControllerForViewModel:nextModel storyboard:viewController.storyboard];
}

#pragma mark - Helpers

- (UIViewController*)viewControllerForViewModel:(SMLPetCardViewModel*)viewModel storyboard:(UIStoryboard *)storyboard {
    if (viewModel.pet) {
        SMLPetCardViewController *petCardViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMLPetCardViewController"];
        petCardViewController.viewModel = viewModel;
        return petCardViewController;
    } else if (viewModel) {
        SMLAddPetViewController *addPetViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMLAddPetViewController"];
        addPetViewController.modelController = self.modelController;
        addPetViewController.viewModel = viewModel;
        return addPetViewController;
    }
    return nil;
}

- (SMLPetCardViewModel*)currentViewModel {
    return [(UIViewController*)self.pageViewController.viewControllers[0] viewModel];
}

@end
