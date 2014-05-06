//
//  MYImporter.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYImporter.h"
#import "iTunesWebservice.h"
#import "Song.h"
#import "Song+Helper.h"
#import "PersistentStack.h"
#import "MYAppDelegate.h"

#define debug 1

NSString *kUniqueIdforImport = @"id";

@interface MYImporter () {
}
@property (nonatomic, strong) NSManagedObjectContext *contextParent;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic,strong) iTunesWebservice *webservice;

@end
@implementation MYImporter


- (id)initWithParentContext:(NSManagedObjectContext *)context webservice:(iTunesWebservice *)webservice {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.context setParentContext:context];
    self.contextParent = context;
    self.webservice = webservice;
    
    return self;
}

- (id)initWithContext:(NSManagedObjectContext *)context webservice:(iTunesWebservice *)webservice {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.context = context;
    self.webservice = webservice;
    
    return self;
}


- (void)import {

    [self.webservice fetchAllWithCompletionBlock:^(NSMutableArray *records) {
        [self.context performBlock:^{
            for (NSDictionary *record in records) {
                NSString *identifier = record[kUniqueIdforImport];
                [[self contextParent] performBlock:^{
                    Song *song = nil;
                    NSArray *songs = [Song findOrCreateSongWithIdentifier:identifier inContext:[self contextParent]];
                    if (songs.lastObject) {
                        if (debug == 1) {
                            song = songs.lastObject;
                            NSLog(@"Existing song: id = %@, title = %@", song.id, song.title);
                        }
                    } else {
                        song = [Song insertNewObjectIntoContext:[self contextParent]];
                        song.id = identifier;
                        [song loadFromDictionary:record];
                    }
                }];
            }
            [self parentSaveContext];
            
        }];
    }];
}

- (void)saveContext {
    
    
    if ([self.context hasChanges]) {
        if (debug == 1) {
            NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
        
        NSError *error = nil;
        [self.context save:&error];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        [self parentSaveContext];
    }
}

- (void)parentSaveContext {
    [self.contextParent performBlock:^{
        if ([self.contextParent hasChanges]) {
            NSError *error = nil;
            [self.contextParent save:&error];
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            
        }
    }];
}

@end
