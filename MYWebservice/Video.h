//
//  Video.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MYModelObject.h"

@interface Video : MYModelObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoDescription;
@property (nonatomic, retain) NSString * uploadDate;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPortrait;
@property (nonatomic, retain) NSString * thumbnailImage;

@end
