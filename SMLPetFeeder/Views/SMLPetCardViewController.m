//
//  SMLPetCardViewController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetCardViewController.h"
#import "SMLPetCardViewModel.h"

@interface SMLPetCardViewController ()

@property (nonatomic) IBOutlet UIImageView *petImageView;
@property (nonatomic) IBOutlet UILabel *petNameLabel;
@property (nonatomic) IBOutlet UITableView *feedingTableView;
@property (nonatomic) IBOutlet UIButton *feedButton;

@end

@implementation SMLPetCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Setup

- (void)setViewModel:(SMLPetCardViewModel *)viewModel {
    
}

- (void)setupView {
    self.petNameLabel.text = self.viewModel.petName;
}

@end
