//
//  SMLPetCardViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetCardViewController.h"
#import "SMLPetViewModel.h"
#import "SMLTableViewDataSource.h"

@interface SMLPetCardViewController ()

@property (nonatomic) IBOutlet UIView *petImageContainer;
@property (nonatomic) IBOutlet UIImageView *petImageView;
@property (nonatomic) IBOutlet UILabel *petNameLabel;
@property (nonatomic) IBOutlet UILabel *lastFedLabel;
@property (nonatomic) IBOutlet UIButton *feedButton;

@end

@implementation SMLPetCardViewController

#pragma mark - Setup

- (void)setViewModel:(SMLPetViewModel *)viewModel {
    _viewModel = viewModel;
    
    @weakify(self);
    [self.viewModel.updatedContent subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self updateView];
    }];
    [self.viewModel.updatedImage subscribeNext:^(id x) {
        @strongify(self);
        [self updateImage];
    }];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    self.petImageContainer.layer.masksToBounds = YES;
    self.petImageContainer.layer.borderColor = [UIColor blackColor].CGColor;
    self.petImageContainer.layer.borderWidth = 1.0;
    
    [self addParallaxEffect];
    
    [self updateView];
    [self updateImage];
}

#pragma mark - Update

- (void)updateView {
    self.petNameLabel.text = self.viewModel.petName;
    self.lastFedLabel.text = self.viewModel.lastFeedingEventString;
}

- (void)updateImage {
    if (self.viewModel.petImage) {
        self.petImageView.image = self.viewModel.petImage;
    }
}

#pragma mark - Actions

- (IBAction)feed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose Food"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in self.viewModel.mealAlertActions) {
        [alertController addAction:action];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"New"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        [self showAddNewMealAlert];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [self presentViewControllerAnimated:alertController];
}

#pragma mark - Helpers

- (void)showAddNewMealAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add New Meal"
                                                                             message:@"Please enter meal description (e.g. \"Dry, 20g\")"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dry food, 20g";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields[0];
        if ([textField.text isEqualToString:@""]) {
            [self showErrorAlertWithMessage:@"You didn't enter meal description."];
        } else {
            [self.viewModel addFeedingEventWithMealText:textField.text];
        }
    }]];
    [self presentViewControllerAnimated:alertController];
}

- (void)addParallaxEffect {
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.petImageView addMotionEffect:group];
}

@end
