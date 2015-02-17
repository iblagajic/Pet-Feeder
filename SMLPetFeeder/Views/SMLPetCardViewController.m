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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - Setup

- (void)setViewModel:(SMLPetCardViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.tableViewDataSource = [SMLTableViewDataSource new];
    self.tableViewDataSource.cellModels = self.viewModel.cellModels;
}

- (void)setupView {
    self.view.backgroundColor = [UIColor clearColor];
    
    self.petNameLabel.text = self.viewModel.petName;
    
    self.petImageView.backgroundColor = [UIColor whiteColor];
    self.petImageView.layer.cornerRadius = CGRectGetWidth(self.petImageView.frame)/2;
    self.petImageView.layer.masksToBounds = YES;
    self.petImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.petImageView.layer.borderWidth = 1.0;
    
    self.feedButton.layer.cornerRadius = CGRectGetWidth(self.feedButton.frame)/2;
    self.feedButton.layer.masksToBounds = YES;
    self.feedButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.feedButton.layer.borderWidth = 2.0;
    
    self.feedingTableView.dataSource = self.tableViewDataSource;
    self.feedingTableView.delegate = self.tableViewDataSource;
}

#pragma mark - Actions

- (IBAction)updateImage:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    self.petImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
