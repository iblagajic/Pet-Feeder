//
//  SMLStandardTableViewModel.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 02/03/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMLBasicCellModel.h"

@protocol SMLStandardTableViewModel <NSObject>

@required
- (NSUInteger)count;
- (id<SMLBasicCellModel>)modelAtIndex:(NSUInteger)index;

@optional
- (void)removeObjectAtIndex:(NSUInteger)index;

@end
