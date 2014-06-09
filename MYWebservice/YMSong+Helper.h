//
//  Song+Helper.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-19.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSong.h"

@interface YMSong (Helper)

/**
 *  Set the properties of song using dictionary
 *
 *  @param dictionary <#dictionary description#>
 */
- (void)loadFromDictionary:(NSDictionary *)dictionary;

/**
 *  <#Description#>
 *
 *  @param id      id was saved from the server
 *  @param context moc
 *
 *  @return an array of songs (one song)
 */
+ (NSArray *)findSongWithIdentifier:(NSString *)id inContext:(NSManagedObjectContext *)context;
@end
