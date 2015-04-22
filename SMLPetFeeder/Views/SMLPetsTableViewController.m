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
#import "SMLCardsViewController.h"
#import "SMLTableViewDataSource.h"
#import "SMLPetViewModel.h"

@interface SMLPetsTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) SMLAppModelController *viewModel;
@property (nonatomic) SMLTableViewDataSource *tableViewDataSource;
@property (nonatomic) NSInteger editingIndex;

@end

@implementation SMLPetsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModelController];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Setup

- (void)setupModelController {
    self.viewModel = [[SMLAppModelController alloc] init];
    self.tableViewDataSource = [[SMLTableViewDataSource alloc] initWithViewModel:self.viewModel];
    self.tableView.dataSource = self.tableViewDataSource;
    @weakify(self);
    [self.viewModel.addedPet subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.unsignedIntegerValue inSection:0]]
                              withRowAnimation:UITableViewRowAnimationMiddle];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.viewModel.removedPet subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.unsignedIntegerValue inSection:0]]
                              withRowAnimation:UITableViewRowAnimationMiddle];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.viewModel.updatedContent subscribeNext:^(NSNumber *index) {
        @strongify(self);
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.unsignedIntegerValue inSection:0]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath]+20; // Status bar height
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                title:@"Delete"
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  [self.viewModel removeObjectAtIndex:indexPath.row];
                                              }],
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                title:@"Edit"
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  [self edit:indexPath.row];
                                              }]
             ];
}

#pragma mark - Actions

- (IBAction)addPet:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Pet"
                                                                             message:@"Please select name for your pet."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Selina";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          NSString *name = [(UITextField*)alertController.textFields[0] text];
                                                          if (name.isEmpty) {
                                                              [self showErrorAlertWithMessage:@"Don't leave your pet nameless :("];
                                                          } else {
                                                              [self.viewModel addNewPetWithName:name];
                                                          }
                                                      }]];
    [self presentViewControllerAnimated:alertController];
}

#pragma mark - Edit

- (void)edit:(NSUInteger)index {
    UIAlertController *editAlertController = [UIAlertController alertControllerWithTitle:@"Edit Pet"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    [editAlertController addAction:[UIAlertAction actionWithTitle:@"Rename"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self renamePetAtIndex:index];
                                                          }]];
    [editAlertController addAction:[UIAlertAction actionWithTitle:@"Change Image"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self updateImageForPetAtIndex:index];
                                                          }]];
    [editAlertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              [self dismissViewControllerAnimated];
                                                          }]];
    [self presentViewControllerAnimated:editAlertController];
}

- (void)updateImageForPetAtIndex:(NSInteger)index {
    self.editingIndex = index;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewControllerAnimated:imagePicker];
}

- (void)renamePetAtIndex:(NSInteger)index {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Rename Pet"
                                                                              message:@"Set new pet name."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Selina";
        textField.text = [self.viewModel modelAtIndex:index].petName;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          UITextField *textField = alertController.textFields[0];
                                                          [self.viewModel updateName:textField.text forPetAtIndex:index];
                                                      }]];
    [self presentViewControllerAnimated:alertController];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    [self.viewModel updateImage:[info objectForKey:UIImagePickerControllerEditedImage] forPetAtIndex:self.editingIndex];
    [self dismissViewControllerAnimated];
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
