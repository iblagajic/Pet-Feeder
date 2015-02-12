//
//  SMLStandardTableViewCell.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLStandardLabel.h"
#import "SMLBasicCellModel.h"

@interface SMLStandardTableViewCell : UITableViewCell

@property (nonatomic) id<SMLBasicCellModel> cellModel;
@property (nonatomic) IBOutlet SMLStandardLabel *titleLabel;
@property (nonatomic) IBOutlet SMLStandardLabel *subtitleLabel;

@end
