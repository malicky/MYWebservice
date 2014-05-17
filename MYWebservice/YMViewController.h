//
//  YMViewController.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-16.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMSong;
@interface YMViewController : UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSong:(YMSong *)song;
@end
