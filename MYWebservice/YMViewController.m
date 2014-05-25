//
//  YMViewController.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-16.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMViewController.h"
#import "MYCoverView.h"
#import "MyScrollView.h"
#import "YMSong.h"
#import "UIImageView+Network.h"

#define debug 0

@interface YMViewController () {
    BOOL _oldBounces;
}

@property (weak, nonatomic) IBOutlet MyScrollView *sv;
@property (weak, nonatomic) IBOutlet MYCoverView* tv;
@property (strong, nonatomic) YMSong *song;

@end

@implementation YMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSong:(YMSong *)song
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _song = song;
    }
    
     return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *cover = [[UIImageView alloc]initWithFrame:CGRectMake(0., 0., 0, 0)];
    [cover loadImageFromURL:[NSURL URLWithString:_song.imageBig] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] cachingKey:_song.imageBig];
    [self.tv addSubview:cover];
    if (debug == 1) {
        for (UIView *subview in self.tv.subviews) {
            NSLog(@"%@ = %@", [subview class], NSStringFromCGRect(subview.frame));
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView
                           withView:(UIView *)view {
    self->_oldBounces = scrollView.bounces;
    scrollView.bounces = NO;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView
                        withView:(UIView *)view atScale:(float)scale {
    scrollView.bounces = self->_oldBounces;
    view.contentScaleFactor = scale * [UIScreen mainScreen].scale; // *
}

// image view is zoomable

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (debug == 1) {
        UIView *imageView __unused = [scrollView viewWithTag:999];
    }
    return [scrollView viewWithTag:999];
}

// image view is also zoomable by double-tapping

- (IBAction) tapped: (UIGestureRecognizer*) tap {
    UIView* v = tap.view;
    UIScrollView* sv = (UIScrollView*)v.superview;
    if (sv.zoomScale < 1)
        [sv setZoomScale:1 animated:YES];
    else if (sv.zoomScale < sv.maximumZoomScale)
        [sv setZoomScale:sv.maximumZoomScale animated:YES];
    else
        [sv setZoomScale:sv.minimumZoomScale animated:YES];
}



@end
