//
//  SMLAddPetViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 17/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLAddPetViewController.h"
#import "SMLModelController.h"

@interface SMLAddPetViewController ()

@property (nonatomic) IBOutlet UIButton *plusButton;

@end

@implementation SMLAddPetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buttonSetup];
}

#pragma mark - Views Setup

- (void)buttonSetup {
    self.plusButton.layer.cornerRadius = 10.0;
    self.plusButton.clipsToBounds = YES;
    self.plusButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
}

#pragma mark - Actions

- (IBAction)addPet:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Pet" message:@"Please select name for your pet." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Selina";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (![[(UITextField*)alertController.textFields[0] text] isEqualToString:@""]) {
            [self.modelController addNewPetWithName:[(UITextField*)alertController.textFields[0] text]];
        } else {
            [self showErrorAlertWithMessage:@"You can't create nameless pet!"];
            
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Helpers

- (void)showErrorAlertWithMessage:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
