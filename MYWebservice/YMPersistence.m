
//
//  Persistence.m
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMPersistence.h"


@interface YMPersistence ()
@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic) NSURL *modelURL;
@property (nonatomic) NSURL *storeURL;
@end

@implementation YMPersistence

/**
 *  Description
 *
 *  @param storeURL location of persistent store
 *  @param modelURL location of mom file
 *
 *  @return return an instance of YMPersistence
 */
- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL {
    self = [super init];
    if (self) {
        _storeURL = storeURL;
        _modelURL = modelURL;
        [self setupManagedObjectContexts];
    }
    return self;
}
// Core data stack with a parent/child context set up
// with the main context is a child of the parent writer context
- (void)setupManagedObjectContexts {
    
    _backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType]; // for background save
    _backgroundManagedObjectContext.undoManager = [[NSUndoManager alloc] init];

    // main context for the ui
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.undoManager = nil;

    // save from _managedObjectContext will be pushed in the _backgroundManagedObjectContext
    [_managedObjectContext setParentContext:_backgroundManagedObjectContext];
    
    // Observe the NSManagedObjectContextDidSaveNotification to merge changes if necessary
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                          NSManagedObjectContext *moc = _backgroundManagedObjectContext;
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

/**
 *  Save main context and background contextes
 */
- (void)saveContexts {
    [self saveManagedObjectContext:self.managedObjectContext];
    [self saveManagedObjectContext:self.backgroundManagedObjectContext];
}

- (void)saveManagedObjectContext:(NSManagedObjectContext *)context {
    if (context && [context hasChanges]) {
        [context performBlockAndWait:^{
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(1);
            }
        }];
    }
}

/**
 *  Singleton of YMPersistence
 *
 *  @return a singse instance
 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    return [super init];
}
@end
