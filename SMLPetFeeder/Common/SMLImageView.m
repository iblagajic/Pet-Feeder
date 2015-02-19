//
//  SMLImageView.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 19/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLImageView.h"

@implementation SMLImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

#pragma mark - Setup

- (void)setupView {
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)setImage:(UIImage *)image {
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [super setImage:image];
    } completion:nil];
}

@end
