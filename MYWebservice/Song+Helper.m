//
//  Song+Helper.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-19.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "Song+Helper.h"

@implementation Song (Helper)
- (void)loadFromDictionary:(NSDictionary *)dictionary {
    self.id = dictionary[@"id"];
    self.title = dictionary[@"title"];
    self.image = dictionary[@"image"];
    self.audio = dictionary[@"audio"];
}

+ (Song *)findOrCreateSongWithIdentifier:(NSString *)id inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        Song *song = [self insertNewObjectIntoContext:context];
        song.id = id;
        return song;
    }
}

@end
