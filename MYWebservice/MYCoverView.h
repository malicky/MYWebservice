//
//  MYCoverView.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-13.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScalableView.h"

@class YMSong;
@interface MYCoverView : UIView
@property (nonatomic, strong) UIImageView *coverImage;
- (id)initWithFrame:(CGRect)frame andSong:(YMSong *)song;
@end
