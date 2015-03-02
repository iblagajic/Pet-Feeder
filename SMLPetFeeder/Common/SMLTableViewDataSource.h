//
//  SMLTableViewDataSource.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMLStandardTableViewModel.h"

@class SMLPetViewModel;

@interface SMLTableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithViewModel:(id<SMLStandardTableViewModel>)viewModel;

@end
