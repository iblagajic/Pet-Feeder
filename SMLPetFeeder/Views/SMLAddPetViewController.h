//
//  SMLAddPetViewController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 17/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMLModelController, SMLPetCardViewModel;

@interface SMLAddPetViewController : UIViewController

@property (nonatomic) SMLModelController *modelController;
@property (nonatomic) SMLPetCardViewModel *viewModel;

@end
