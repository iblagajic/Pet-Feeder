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
    SMLPet *newPet = [SMLPet newPetInContext:context];
    NSInteger ordinal = [SMLPet allPetsInContext:context].count;
    newPet.name = name;
    newPet.ordinal = @(ordinal);
    return newPet;
}

+ (NSArray*)allPetsInContext:(NSManagedObjectContext*)context {
    return [SMLPet petsWithName:nil context:context];
}

+ (void)updatePet:(SMLPet*)pet withName:(NSString*)name context:(NSManagedObjectContext*)context {
    pet.name = name;
}

+ (BOOL)updatePet:(SMLPet*)pet withImage:(UIImage*)image context:(NSManagedObjectContext*)context {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;;
    NSData * binaryImageData = UIImagePNGRepresentation(image);
    NSString *imageName = [pet.name stringByAppendingString:@".png"];
    BOOL success = [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:imageName] atomically:YES];
    if (success) {
        pet.image = imageName;
    }
    return success;
}

+ (void)updatePet:(SMLPet*)pet withFeedingEvent:(SMLFeedingEvent*)feedingEvent context:(NSManagedObjectContext*)context {
    [pet addFeedingEventsObject:feedingEvent];
}

#pragma mark - Helpers

+ (SMLPet*)newPetInContext:(NSManagedObjectContext*)context {
    return [NSEntityDescription insertNewObjectForEntityForName:SMLEntityName inManagedObjectContext:context];
}

+ (NSArray*)petsWithName:(NSString*)name context:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:SMLEntityName];
    // If name is provided, filter. If not, return all.
    if (name) {
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    }
    NSError *err;
    NSArray *petsWithName = [context executeFetchRequest:request error:&err];
    if (err) {
        NSLog(@"Error fetching pet: %@", err.localizedDescription);
    }
    return petsWithName;
}

@end
