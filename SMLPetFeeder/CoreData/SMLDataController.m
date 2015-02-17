//
//  SMLDataController.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 10/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLDataController.h"
#import <CoreData/CoreData.h>

#import "SMLPet+Ingestion.h"

@interface SMLDataController ()

@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SMLDataController

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PetFeeder" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Test.sqlite"];
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (!coordinator) {
            return nil;
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext {
    NSError *err;
    if ([self.managedObjectContext hasChanges]
        && [self.managedObjectContext save:&err]) {
        NSLog(@"Error saving context: %@", err.localizedDescription);
        return NO;
    }
    return YES;
}

#pragma mark - Pet
#pragma mark Fetch

- (NSArray*)allPets {
    return [SMLPet allPetsInContext:self.managedObjectContext];
}

#pragma mark Add

- (SMLPet*)addNewPetWithName:(NSString*)petName {
    SMLPet *pet = [SMLPet addPetWithName:petName context:self.managedObjectContext];
    if ([self saveContext]) {
        return pet;
    }
    return nil;
}

#pragma mark Update

- (BOOL)updatePet:(SMLPet*)pet withImage:(UIImage*)image {
    return [SMLPet updatePet:pet withImage:image context:self.managedObjectContext];
}

- (void)updatePet:(SMLPet*)pet withName:(NSString*)name {
    [SMLPet updatePet:pet withName:name context:self.managedObjectContext];
}

@end
