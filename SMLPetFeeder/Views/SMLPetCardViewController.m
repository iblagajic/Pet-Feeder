//
//  SMLPetCardViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetCardViewController.h"
#import "SMLPetCardViewModel.h"
#import "SMLTableViewDataSource.h"
#import "UIViewController+SML.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTScope.h"

@interface SMLPetCardViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) IBOutlet UIImageView *petImageView;
@property (nonatomic) IBOutlet UILabel *petNameLabel;
@property (nonatomic) IBOutlet UITableView *feedingTableView;
@property (nonatomic) IBOutlet UIButton *feedButton;
@property (nonatomic) SMLTableViewDataSource *tableViewDataSource;

@end

@implementation SMLPetCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - Setup

- (void)setViewModel:(SMLPetCardViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.tableViewDataSource = [[SMLTableViewDataSource alloc] initWithViewModel:viewModel];
    
    @weakify(self);
    [self.viewModel.updatedContent subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self updateView];
    }];
    [self.viewModel.updatedImage subscribeNext:^(id x) {
        @strongify(self);
        [self updateImage];
    }];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    self.petNameLabel.textColor = [UIColor whiteColor];
    
    self.petImageView.backgroundColor = [UIColor whiteColor];
    self.petImageView.layer.cornerRadius = CGRectGetWidth(self.petImageView.frame)/2;
    self.petImageView.layer.masksToBounds = YES;
    self.petImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.petImageView.layer.borderWidth = 1.0;
    
    self.feedButton.layer.cornerRadius = CGRectGetWidth(self.feedButton.frame)/2;
    self.feedButton.layer.masksToBounds = YES;
    self.feedButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.feedButton.layer.borderWidth = 2.0;
    
    self.feedingTableView.dataSource = self.tableViewDataSource;
    self.feedingTableView.delegate = self.tableViewDataSource;
    
    [self addParallaxEffect];
    
    [self updateView];
    [self updateImage];
}

#pragma mark - Update

- (void)updateView {
    self.petNameLabel.text = self.viewModel.petName;
    [self.feedingTableView reloadData];
}

- (void)updateImage {
    self.petImageView.image = self.viewModel.petImage;
}

#pragma mark - Actions

- (IBAction)updateImage:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)updateName:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Add Pet" message:@"Add new pet name." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Selina";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields[0];
        [self.viewModel updateName:textField.text];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)feed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose Food" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in self.viewModel.mealAlertActions) {
        [alertController addAction:action];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"New" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showAddNewMealAlert];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    [self.viewModel updateImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers

- (void)showAddNewMealAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add New Meal" message:@"Please enter meal description (e.g. \"Dry, 20g\")" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dry food, 20g";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields[0];
        if ([textField.text isEqualToString:@""]) {
            [self showErrorAlertWithMessage:@"You didn't enter meal description."];
        } else {
            [self.viewModel addFeedingEventWithMealText:textField.text];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addParallaxEffect {
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.petImageView addMotionEffect:group];
}

@end
