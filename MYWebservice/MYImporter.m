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
                NSString *identifier = record[@"id"];
                Song *song = [Song findOrCreateSongWithIdentifier:identifier inContext:[self contextParent]];
                [song loadFromDictionary:record];
            }
            
            NSError *error = nil;
            [self.context save:&error];
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            
            
            [self.contextParent performBlock:^{
                
                NSError *error = nil;
                [self.contextParent save:&error];
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    return;
                }
                
                MYAppDelegate *theAppDelegate = (MYAppDelegate*) [UIApplication sharedApplication].delegate;
                [theAppDelegate saveContext];
                
            }];
            
         }];
    }];
}

@end
