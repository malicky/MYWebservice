//
//  Video+Helper.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "Video.h"

@interface Video (Helper)
- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (Video *)findOrCreateVideoWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context;
@end
