//
//  Song+Helper.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-19.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "Song+Helper.h"

@implementation Song (Helper)
- (void)loadFromDictionary:(NSDictionary *)dictionary {

    self.title = dictionary[@"title"];
    self.artiste = dictionary[@"artiste"];
    self.album = dictionary[@"album"];
    self.releaseDate = dictionary[@"releaseDate"];
    self.category = dictionary[@"category"];
}

+ (Song *)findOrCreateSongWithTitle:(NSString *)title inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        Song *song = [self insertNewObjectIntoContext:context];
        song.title = title;
        return song;
    }
}

@end
