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



@interface MYImporter () {
}
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic,strong) iTunesWebservice *webservice;

@end
@implementation MYImporter

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
                Song *song = [Song findOrCreateSongWithIdentifier:identifier inContext:[self context]];
                [song loadFromDictionary:record];
            }
            
            NSError *error = nil;
            [self.context save:&error];
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
         }];
    }];
}

@end
