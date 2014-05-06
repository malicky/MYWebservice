//
//  YMAppDelegate.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

#define appDelegate__ (YMAppDelegate*)[UIApplication sharedApplication].delegate

@class YMiTunesWebservice;
@interface YMAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) YMiTunesWebservice *webservice;
@end
