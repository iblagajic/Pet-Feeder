//
//  SMLPetCardViewModel.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPetCardViewModel.h"
#import "SMLPet+Ingestion.h"
#import "SMLFeedingEvent.h"
#import "SMLFeedingEventViewModel.h"
#import "SMLDataController.h"

@interface SMLPetCardViewModel ()

@property (nonatomic) SMLPet *pet;
@property (nonatomic) SMLDataController *dataController;

@end

@implementation SMLPetCardViewModel

- (instancetype)initWithPet:(SMLPet*)pet dataController:(SMLDataController*)dataController {
    self = [super init];
    if (self) {
        self.pet = pet;
        self.dataController = dataController;
    }
    return self;
}

#pragma mark - Model

- (NSString*)petName {
    return self.pet.name;
}

- (UIImage*)petImage {
    return [UIImage imageWithContentsOfFile:self.pet.image];
}

- (NSArray*)feedingEvents {
    return [self.pet.feedingEvents.allObjects sortedArrayUsingComparator:^NSComparisonResult(SMLFeedingEvent *obj1, SMLFeedingEvent *obj2) {
        return obj1.time > obj2.time;
    }];
}

- (NSArray*)cellModels {
    NSMutableArray *array = [NSMutableArray new];
    for (SMLFeedingEvent *feedingEvent in self.feedingEvents) {
        SMLFeedingEventViewModel *viewModel = [[SMLFeedingEventViewModel alloc] initWithFeedingEvent:feedingEvent];
        [array addObject:viewModel];
    }
    return array;
}

#pragma mark - Updates

- (void)updateName:(NSString*)name {
    [self.dataController updatePet:self.pet withName:name];
}

- (void)updateImage:(UIImage*)image {
    [self.dataController updatePet:self.pet withImage:image];
}

@end
