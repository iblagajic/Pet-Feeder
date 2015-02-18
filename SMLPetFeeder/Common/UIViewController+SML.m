//
//  UIViewController+SML.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 18/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "UIViewController+SML.h"

@implementation UIViewController (SML)

- (void)showErrorAlertWithMessage:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
