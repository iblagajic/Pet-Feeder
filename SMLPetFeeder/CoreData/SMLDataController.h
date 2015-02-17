//
//  SMLDataController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class SMLPet;

@interface SMLDataController : NSObject

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray*)allPets;
- (SMLPet*)addNewPetWithName:(NSString*)petName;
- (BOOL)updatePet:(SMLPet*)pet withImage:(UIImage*)image;
- (void)updatePet:(SMLPet*)pet withName:(NSString*)name;

@end
