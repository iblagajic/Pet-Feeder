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

@interface SMLPetCardViewController ()

@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) IBOutlet UIImageView *backgroundBlurredImageView;
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
    self.containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.containerView.layer.cornerRadius = 5.0;
    self.petImageView.backgroundColor = [UIColor whiteColor];
    self.petImageView.layer.cornerRadius = CGRectGetWidth(self.petImageView.frame)/2;
    self.petImageView.layer.masksToBounds = YES;
    self.petImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.petImageView.layer.borderWidth = 1.0;
    
    self.petNameLabel.text = self.viewModel.petName;
    
    self.feedingTableView.dataSource = self.tableViewDataSource;
    self.feedingTableView.delegate = self.tableViewDataSource;
}

@end
