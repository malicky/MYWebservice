//
//  Song+Helper.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-19.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSong.h"

@interface YMSong (Helper)

- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)findOrCreateSongWithIdentifier:(NSString *)title inContext:(NSManagedObjectContext *)context;
@end
