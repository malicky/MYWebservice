//
//  Song+Helper.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-19.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "Song.h"

@interface Song (Helper)
- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (Song *)findOrCreateSongWithTitle:(NSString *)title inContext:(NSManagedObjectContext *)context;
@end
