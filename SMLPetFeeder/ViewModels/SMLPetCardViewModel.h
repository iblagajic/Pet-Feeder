//
//  SMLPetCardViewModel.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SMLPet;
@class SMLDataController;

@interface SMLPetCardViewModel : NSObject

@property (nonatomic, readonly) NSString *petName;
@property (nonatomic, readonly) UIImage *petImage;
@property (nonatomic, readonly) NSArray *cellModels;

- (instancetype)initWithPet:(SMLPet*)pet dataController:(SMLDataController*)dataController;

- (void)updateName:(NSString*)name;
- (void)updateImage:(UIImage*)image;

@end
