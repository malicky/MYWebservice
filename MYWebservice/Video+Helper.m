//
//  Video+Helper.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "Video+Helper.h"

@implementation Video (Helper)

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    self.id = dictionary[@"id"];
    self.title = dictionary[@"title"];
    self.videoDescription = dictionary[@"description"];
    self.uploadDate = dictionary[@"upload_date"] ;
    self.userName = dictionary[@"user_name"];
    self.userPortrait = dictionary[@"user_portrait_medium"];
    self.thumbnailImage = dictionary[@"thumbnail_medium"];
}

+ (Video *)findOrCreateVideoWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", identifier];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    if (result.lastObject) {
        return result.lastObject;
    } else {
        Video *video = [self insertNewObjectIntoContext:context];
        video.id = identifier;
        
        NSError *error = nil;
        NSAssert([context save:&error], @"Error saving import context: %@\n%@", [error localizedDescription], [error userInfo]);
        return video;
    }
}

@end
