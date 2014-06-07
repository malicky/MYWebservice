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

/**
 *  The maximim number of songs to download
 */
const int kMaxSongs = 400;

/**
 *  When importing, the id is used prevent importing a song imported
 */
NSString *kUniqueIdforImport = @"id";


@interface YMImporter ()

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
    // The import moc is local
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    // the parent context is the main context
    [self.context setParentContext:context];
    self.contextParent = context;
    
    self.webservice = webservice;
    
    return self;
}

/**
 *  Before saving into coredata, check that the song was not previously imported (comparing id).
 */
- (void)import {
    NSString *urlString = [NSString stringWithFormat:@"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=%i/xml", kMaxSongs];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.webservice fetchAtURL:url withCompletionBlock:^(NSMutableArray *records) {
        [self.context performBlock:^{
            for (NSDictionary *record in records) {
                NSString *identifier = record[kUniqueIdforImport];
                [[self contextParent] performBlock:^{
                    YMSong *song = nil;
                    NSArray *songs = [YMSong findSongWithIdentifier:identifier inContext:[self contextParent]];
                    if (songs.lastObject) { // already imported
                        if (debug == 1) {
                            song = songs.lastObject;
                            NSLog(@"Already existing song: id = %@, title = %@", song.id, song.title);
                        }
                    } else { // create a new core data entity song
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

/**
 *  Push the imported songs in the parent context (main context).
 */
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
