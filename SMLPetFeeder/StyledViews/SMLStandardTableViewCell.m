//
//  SMLStandardTableViewCell.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLStandardTableViewCell.h"

@implementation SMLStandardTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

#pragma mark - Setup

- (void)setCellModel:(id<SMLBasicCellModel>)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    if ([self.cellModel respondsToSelector:@selector(subtitle)]) {
        self.subtitleLabel.text = self.cellModel.subtitle;
    }
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.font = [UIFont systemFontOfSize:18.0];
    self.subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
}

@end
