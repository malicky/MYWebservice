//
//  YMSong.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-07.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "YMModelObject.h"


@interface YMSong : YMModelObject

@property (nonatomic, retain) NSString * audio;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * artist;

@end
