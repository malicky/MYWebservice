
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

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL {
    self = [super init];
    if (self) {
        _storeURL = storeURL;
        _modelURL = modelURL;
        [self setupManagedObjectContexts];
    }
    return self;
}

- (void)setupManagedObjectContexts {
    _backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundManagedObjectContext.undoManager = [[NSUndoManager alloc] init];

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.undoManager = nil;

    [_managedObjectContext setParentContext:_backgroundManagedObjectContext];
    
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
                abort();
            }
        }];
    }
}

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
