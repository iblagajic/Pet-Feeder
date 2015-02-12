//
//  SMLStandardLabel.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLStandardLabel.h"

@implementation SMLStandardLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Setup

- (void)setup {
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:self.font.pointSize];
}

@end
