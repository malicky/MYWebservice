//
//  MYAppDelegate.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PersistentStack;
@class MYWebservice;

@interface MYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) PersistentStack *persistentStack;
@property (nonatomic, strong) MYWebservice *webservice;
@end
