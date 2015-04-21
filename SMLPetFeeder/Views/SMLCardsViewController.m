//
//
//  SMLCardsViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLCardsViewController.h"
#import "SMLAppModelController.h"
#import "SMLPetViewModel.h"
#import "SMLPetCardViewController.h"

@interface SMLCardsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIView *container;
@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, readonly) SMLPetViewModel *currentViewModel;

@end

@implementation SMLCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageViewController];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    NSUInteger index = [self.viewModel indexOfViewModel:self.viewModel.currentPetModel];
    [self refreshViewAtIndex:index animated:NO];
}

#pragma mark - Setup

- (void)setupPageViewController {
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.view.frame = self.container.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self addChildViewController:self.pageViewController];
    [self.container addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)setViewModel:(SMLAppModelController*)viewModel {
    _viewModel = viewModel;
    @weakify(self);
    [self.viewModel.updatedContent subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self refreshViewAtIndex:index.integerValue animated:YES];
    }];
    [self.viewModel.updatedImage subscribeNext:^(id x) {
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
        UIViewController *startingViewController = [self viewControllerForViewModel:[self.viewModel modelAtIndex:index]
                                                                         storyboard:self.storyboard];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        self.pageControl.numberOfPages = self.viewModel.count;
    };
    
    if (animated) {
        [self fadeOutView:self.pageViewController.view
               completion:^{
                   block();
                   [self fadeInView:self.pageViewController.view];
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
    self.pageControl.currentPage = [self.viewModel indexOfViewModel:self.viewModel.currentPetModel];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    self.viewModel.currentPetModel = self.currentViewModel;
    [self refreshBackground];
    [self refreshPageControl];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController
      viewControllerBeforeViewController:(SMLPetCardViewController*)viewController {
    SMLPetViewModel *previousViewModel = [self.viewModel modelBeforeViewModel:viewController.viewModel];
    return [self viewControllerForViewModel:previousViewModel storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController*)pageViewController
       viewControllerAfterViewController:(SMLPetCardViewController*)viewController {
    SMLPetViewModel *nextModel = [self.viewModel modelAfterViewModel:viewController.viewModel];
    return [self viewControllerForViewModel:nextModel storyboard:viewController.storyboard];
}

#pragma mark - Actions

- (IBAction)edit:(id)sender {
    [self dismissViewControllerAnimated];
}

#pragma mark - Helpers

- (UIViewController*)viewControllerForViewModel:(SMLPetViewModel*)viewModel storyboard:(UIStoryboard *)storyboard {
    if (viewModel) {
        SMLPetCardViewController *petCardViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMLPetCardViewController"];
        petCardViewController.viewModel = viewModel;
        return petCardViewController;
    }
    return nil;
}

- (SMLPetViewModel*)currentViewModel {
    return [(UIViewController*)self.pageViewController.viewControllers[0] viewModel];
}

@end
