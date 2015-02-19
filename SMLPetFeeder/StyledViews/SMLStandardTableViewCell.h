//
//  SMLStandardTableViewCell.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLBasicCellModel.h"

@interface SMLStandardTableViewCell : UITableViewCell

@property (nonatomic) id<SMLBasicCellModel> cellModel;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *subtitleLabel;

@end
