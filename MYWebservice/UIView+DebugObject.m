//
//  UIView+DebugObject.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "UIView+DebugObject.h"

@implementation UIView (DebugObject)

- (id)debugQuickLookObject {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end