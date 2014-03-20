//
//  MYImporter.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYImporter.h"
#import "MYWebservice.h"
#import "Song.h"
#import "Song+Helper.h"


NSString *kDidImportNotification = @"kDidImportNotification";

@interface MYImporter () {
}
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic,strong) MYWebservice *webservice;
@property (nonatomic) int batchCount;

@end
@implementation MYImporter

- (id)initWithContext:(NSManagedObjectContext *)context webservice:(MYWebservice *)webservice {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.context = context;
    self.webservice = webservice;
    
    return self;
}

- (void)import {
    self.batchCount = 0;

    [self.webservice fetchAll:^(NSArray *records) {
        [self.context performBlock:^{
            
            for (NSDictionary *record in records) {
                NSString *identifier = record[@"title"];
                Song *song = [Song findOrCreateSongWithIdentifier:identifier inContext:[self context]];
                [song loadFromDictionary:record];
                
                self.batchCount++;
                if (self.batchCount % 10 == 0) {
                    NSError *error = nil;
                    [self.context save:&error];
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                    } else{
                        [self somethingChanged];
                    }
                }
            }
            

            
         }];
    }];
}

- (void)somethingChanged {
    // send a notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidImportNotification object:nil];
}
@end
