//
//  UIViewController+SML.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SML)

@property (nonatomic, readonly) id viewModel;

- (void)showErrorAlertWithMessage:(NSString*)message;
- (void)fadeInView:(UIView*)view completion:(SimpleBlock)completion;
- (void)fadeOutView:(UIView*)view completion:(SimpleBlock)completion;

@end
