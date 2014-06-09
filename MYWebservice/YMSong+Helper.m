//
//  Song+Helper.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-19.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSong+Helper.h"

#define debug 1

@implementation YMSong (Helper)
- (void)loadFromDictionary:(NSDictionary *)dictionary {
    
    if (debug == 1) {
        NSLog(@"loadFromDictionary: %@", dictionary);
    }
    self.id = dictionary[@"id"];
    self.title = dictionary[@"title"];
    self.imageMedium = dictionary[@"imageMedium"];
    self.imageBig = dictionary[@"imageBig"];
    self.audio = dictionary[@"audio"];
    self.artist = dictionary[@"artist"];
}

+ (NSArray *)findSongWithIdentifier:(NSString *)id inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    fetchRequest.fetchLimit = 1; // only one is enough
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    return  result;
}
@end
