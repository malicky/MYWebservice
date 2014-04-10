
//
//  PersistentStack.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "PersistentStack.h"


@interface PersistentStack ()

@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic) NSURL *modelURL;
@property (nonatomic) NSURL *storeURL;

@end

@implementation PersistentStack

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL {
    self = [super init];
    if (self) {
        self.storeURL = storeURL;
        self.modelURL = modelURL;
        [self setupManagedObjectContexts];
    }
    return self;
}



- (void)setupManagedObjectContexts {
    
    self.backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.backgroundManagedObjectContext.undoManager = [[NSUndoManager alloc] init];

    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.undoManager = nil;

    [self.managedObjectContext setParentContext:self.backgroundManagedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                          NSManagedObjectContext *moc = self.backgroundManagedObjectContext;
                                                          if (note.object != moc) {
                                                              [moc performBlockAndWait:^{
                                                                  [moc mergeChangesFromContextDidSaveNotification:note];
                                                              }];
                                                          }
                                                      }];
}


- (NSManagedObjectContext *)setupManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error;
    [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                  configuration:nil
                                                                            URL:self.storeURL
                                                                        options:nil
                                                                          error:&error];
    if( error ) {
        NSLog(@"error: %@a", error.localizedDescription);
        NSLog(@"rm \"%@\"", self.storeURL.path);
    }
    return managedObjectContext;
}

- (NSManagedObjectModel*)managedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

- (void)saveContexts {
    [self saveManagedObjectContext:self.managedObjectContext];
    [self saveManagedObjectContext:self.backgroundManagedObjectContext];
}

- (void)saveManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if (context && [context hasChanges]) {
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
