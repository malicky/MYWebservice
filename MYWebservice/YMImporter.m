//
//  MYImporter.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMImporter.h"
#import "YMiTunesWebservice.h"
#import "YMSong.h"
#import "YMSong+Helper.h"
#import "YMPersistence.h"
#import "YMAppDelegate.h"

#define debug 1

NSString *kUniqueIdforImport = @"id";

@interface YMImporter () {
}
@property (nonatomic, strong) NSManagedObjectContext *contextParent;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic,strong) YMiTunesWebservice *webservice;
@end

@implementation YMImporter
- (id)initWithParentContext:(NSManagedObjectContext *)context webservice:(YMiTunesWebservice *)webservice {
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

- (id)initWithContext:(NSManagedObjectContext *)context webservice:(YMiTunesWebservice *)webservice {
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
                    YMSong *song = nil;
                    NSArray *songs = [YMSong findOrCreateSongWithIdentifier:identifier inContext:[self contextParent]];
                    if (songs.lastObject) {
                        if (debug == 1) {
                            song = songs.lastObject;
                            NSLog(@"Already existing song: id = %@, title = %@", song.id, song.title);
                        }
                    } else {
                        song = [YMSong insertNewObjectIntoContext:[self contextParent]];
                        song.id = identifier;
                        [song loadFromDictionary:record];
                    }
                }];
            }
            [self saveInParentContext];
        }];
    }];
}

- (void)saveInParentContext {
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