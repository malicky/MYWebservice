//
//  YMTableViewCell.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-06.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMSong;

@interface YMTableViewCell : UITableViewCell

@property (nonatomic,strong) YMSong *song;

@end
