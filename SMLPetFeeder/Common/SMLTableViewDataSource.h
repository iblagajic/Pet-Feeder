//
//  SMLTableViewDataSource.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SMLPetCardViewModel;

@interface SMLTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithViewModel:(SMLPetCardViewModel*)viewModel;

@end
