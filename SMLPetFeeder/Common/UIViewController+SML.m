//
//  UIViewController+SML.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "UIViewController+SML.h"

@implementation UIViewController (SML)

@dynamic viewModel;

- (void)showErrorAlertWithMessage:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)fadeInView:(UIView*)view {
    [self fadeInView:view completion:nil];
}

- (void)fadeInView:(UIView*)view completion:(SimpleBlock)completion {
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)fadeOutView:(UIView*)view {
    [self fadeOutView:view completion:nil];
}

- (void)fadeOutView:(UIView*)view completion:(SimpleBlock)completion {
    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)presentViewControllerAnimated:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)dismissViewControllerAnimated {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
