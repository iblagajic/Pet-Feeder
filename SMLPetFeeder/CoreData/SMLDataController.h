//
//  SMLDataController.h
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SMLDataController : NSObject

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end
