//
//  YMSongView.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-06.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YMSong;

@interface YMSongView : UIView

@property (nonatomic, strong) UIImageView *coverImage;
- (id)initWithFrame:(CGRect)frame andSong:(YMSong *)song;

@end
