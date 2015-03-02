//
//  SMLPetsTableViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 01/03/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetsTableViewController.h"
#import "SMLAppModelController.h"
#import "SMLStandardTableViewCell.h"
#import "SMLPetViewModel.h"
#import "UIViewController+SML.h"
#import "SMLCardsViewController.h"
#import "SMLTableViewDataSource.h"

@interface SMLPetsTableViewController ()

@property (nonatomic) SMLAppModelController *viewModel;
@property (nonatomic) SMLTableViewDataSource *tableViewDataSource;

@end

@implementation SMLPetsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModelController];
}

#pragma mark - Setup

- (void)setupModelController {
    self.viewModel = [SMLAppModelController new];
    self.tableViewDataSource = [[SMLTableViewDataSource alloc] initWithViewModel:self.viewModel];
    self.tableView.dataSource = self.tableViewDataSource;
    @weakify(self);
    [self.viewModel.addedPet subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.unsignedIntegerValue inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.viewModel.removedPet subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.unsignedIntegerValue inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath]+20;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Actions

- (IBAction)addPet:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Pet" message:@"Please select name for your pet." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Selina";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([[(UITextField*)alertController.textFields[0] text] isEqualToString:@""]) {
            [self showErrorAlertWithMessage:@"Don't leave your pet nameless :("];
        } else {
            [self.viewModel addNewPetWithName:[(UITextField*)alertController.textFields[0] text]];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(SMLStandardTableViewCell*)senderCell {
    if ([segue.identifier isEqualToString:@"ShowPet"]) {
        SMLCardsViewController *destinationViewControlller = segue.destinationViewController;
        self.viewModel.currentPetModel = (SMLPetViewModel*)senderCell.cellModel;
        destinationViewControlller.viewModel = self.viewModel;
    }
}

#pragma mark - Overrides

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.viewModel.count == 0) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

@end
