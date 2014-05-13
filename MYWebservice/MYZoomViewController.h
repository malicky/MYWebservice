//
//  MYZoomViewController.h
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-10.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYZoomViewController : UIViewController
//

// The scroll view used for zooming.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// The image view that displays the image.
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

// The image that will be shown.
@property (strong, nonatomic, readonly) UIImage *image;
- (id)initWithImage:(UIImage *)image;


@end
