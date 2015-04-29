//
//  SMLBasicCellModel.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

@protocol SMLBasicCellModel <NSObject>

@required

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) RACSubject *updatedTitle;

@optional

@property (nonatomic, readonly) NSString *subtitle;
@property (nonatomic, readonly) RACSubject *updatedSubtitle;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) RACSubject *updatedImage;

@end
