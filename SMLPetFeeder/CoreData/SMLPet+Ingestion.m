//
//  SMLPet+Ingestion.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 16/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLPet+Ingestion.h"

static NSString * const SMLEntityName = @"SMLPet";

@implementation SMLPet (Ingestion)

+ (SMLPet*)addPetWithName:(NSString*)name context:(NSManagedObjectContext*)context {
    NSInteger ordinal = [SMLPet allPetsInContext:context].count;
    SMLPet *newPet = [SMLPet newPetInContext:context];
    newPet.name = name;
    newPet.ordinal = @(ordinal);
    return newPet;
}

+ (NSArray*)allPetsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:SMLEntityName];
    NSError *err;
    NSArray *allPets = [context executeFetchRequest:request error:&err];
    if (err) {
        NSLog(@"Error fetching pets: %@", err.localizedDescription);
    }
    return [allPets sortedArrayUsingComparator:^NSComparisonResult(SMLPet *obj1, SMLPet *obj2) {
        return obj1.ordinal > obj2.ordinal;
    }];
}

+ (void)updatePet:(SMLPet*)pet withName:(NSString*)name context:(NSManagedObjectContext*)context {
    pet.name = name;
}

+ (BOOL)updatePet:(SMLPet*)pet withImage:(UIImage*)image context:(NSManagedObjectContext*)context {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSData * binaryImageData = UIImagePNGRepresentation(image);
    NSString *imageName = [pet.name stringByAppendingString:@".png"];
    NSString *path = [basePath stringByAppendingPathComponent:imageName];
    BOOL success = [binaryImageData writeToFile:path atomically:YES];
    if (success) {
        pet.image = imageName;
    }
    return success;
}

+ (void)updatePet:(SMLPet*)pet withFeedingEvent:(SMLFeedingEvent*)feedingEvent context:(NSManagedObjectContext*)context {
    [pet addFeedingEventsObject:feedingEvent];
}

#pragma mark - Remove

+ (void)removePet:(SMLPet*)petToRemove context:(NSManagedObjectContext*)context {
    [[NSFileManager defaultManager] removeItemAtPath:[SMLPet imagePathForPet:petToRemove] error:nil];
    [context deleteObject:petToRemove];
    NSArray *pets = [self allPetsInContext:context];
    for (SMLPet *pet in pets) {
        if (pet.ordinal > petToRemove.ordinal) {
            pet.ordinal = @(pet.ordinal.integerValue - 1);
        }
    }
}

#pragma mark - Helpers

+ (SMLPet*)newPetInContext:(NSManagedObjectContext*)context {
    return [NSEntityDescription insertNewObjectForEntityForName:SMLEntityName inManagedObjectContext:context];
}

+ (NSString*)imagePathForPet:(SMLPet*)pet {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *imageName = [pet.name stringByAppendingString:@".png"];
    NSString *path = [basePath stringByAppendingPathComponent:imageName];
    return path;
}

@end
