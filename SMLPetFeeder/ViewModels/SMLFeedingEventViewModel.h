//
//  SMLFeedingEventViewModel.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMLBasicCellModel.h"

@class SMLFeedingEvent;

@interface SMLFeedingEventViewModel : NSObject <SMLBasicCellModel>

- (instancetype)initWithFeedingEvent:(SMLFeedingEvent*)feedingEvent;

@end
