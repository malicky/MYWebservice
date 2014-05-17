//
//  MYZoomViewController.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-10.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYZoomViewController.h"
#import "MYCoverView.h"
#import "UIImageView+Network.h"
#import "YMSong.h"

@interface MYZoomViewController ()
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;
@end

@implementation MYZoomViewController


- (void)setSong:(YMSong *)song {
    
    MYCoverView *songView = [[MYCoverView alloc]initWithFrame:CGRectMake(0., 0., 170, 170)  andSong:song];
    UIImageView *cover = [[UIImageView alloc]init];
    [cover loadImageFromURL:[NSURL URLWithString:song.imageBig] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] cachingKey:nil];
    [songView addSubview:cover];
    songView.coverImage = cover;
    
//[self.contentView addSubview:songView];
    
    
    
    
    
    
    return;
    

}

- (id)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    self.imageView.image = self.image;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private methods

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:self.scrollView];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

@end
