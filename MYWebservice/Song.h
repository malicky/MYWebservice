//
//  Song.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-18.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MYModelObject.h"


@interface Song : MYModelObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * artiste;
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * category;

@end
