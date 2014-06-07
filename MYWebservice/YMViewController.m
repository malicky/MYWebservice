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

extern NSInteger kCoverViewTag;

#define debug 0

@interface YMViewController ()

@property (weak, nonatomic) IBOutlet MyScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MYCoverView* coverView;
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
    
    [self loadCoverViewImage];
}

/**
 *  Load asynchronously the big image (170x170)
 */
-(void)loadCoverViewImage {
    UIImageView *cover = [[UIImageView alloc]initWithFrame:CGRectMake(0., 0., 0., 0.)];
    [cover loadImageFromURL:[NSURL URLWithString:_song.imageBig]
           placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] cachingKey:_song.imageBig];
    
    [self.coverView addSubview:cover];
    if (debug == 1) {
        for (UIView *subview in self.coverView.subviews) {
            NSLog(@"%@ = %@", [subview class], NSStringFromCGRect(subview.frame));
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate Protocol for zooming

- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView
                           withView:(UIView *)view {
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView
                        withView:(UIView *)view atScale:(float)scale {
    view.contentScaleFactor = scale * [UIScreen mainScreen].scale; // *
}

// image view is zoomable
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:kCoverViewTag];
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
