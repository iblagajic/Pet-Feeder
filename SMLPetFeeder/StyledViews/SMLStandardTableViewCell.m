//
//  SMLStandardTableViewCell.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLStandardTableViewCell.h"

@implementation SMLStandardTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.roundImageView.layer.cornerRadius = CGRectGetHeight(self.roundImageView.bounds)/2;
    self.roundImageView.clipsToBounds = YES;
}

#pragma mark - Setup

- (void)setCellModel:(id<SMLBasicCellModel>)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.title;
    if ([self.cellModel respondsToSelector:@selector(subtitle)]) {
        self.subtitleLabel.text = self.cellModel.subtitle;
    }
    if ([self.cellModel respondsToSelector:@selector(image)]) {
        if (self.cellModel.image) {
            self.roundImageView.image = self.cellModel.image;
        }
    }
}

@end
