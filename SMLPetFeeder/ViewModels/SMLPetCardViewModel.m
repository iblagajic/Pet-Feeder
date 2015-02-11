//
//  SMLPetCardViewModel.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetCardViewModel.h"
#import "SMLPet.h"

@interface SMLPetCardViewModel ()

@property (nonatomic) SMLPet *pet;

@end

@implementation SMLPetCardViewModel

- (instancetype)initWithPet:(SMLPet*)pet {
    self = [super init];
    if (self) {
        self.pet = pet;
    }
    return self;
}

- (NSString*)petName {
    return self.pet.name;
}

- (UIImage*)petImage {
    return [UIImage imageWithContentsOfFile:self.pet.image];
}

@end
