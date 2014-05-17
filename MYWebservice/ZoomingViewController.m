//
//  ZoomingViewController.m
//  TapZoomRotate
//
//  Created by Matt Gallagher on 2010/09/27.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "ZoomingViewController.h"
#import "YMSong.h"
#import "MYCoverView.h"
#import "UIImageView+Network.h"

@interface ZoomingViewController ()
@property (nonatomic,strong) YMSong *song;
@end


@implementation ZoomingViewController {
}

@synthesize proxyView;
@synthesize view;

- (id)initWithSong:(YMSong *)selectedSong {
    self = [self init];
    if (self) {
        _song = selectedSong;
        MYCoverView *songView = [[MYCoverView alloc]initWithFrame:CGRectMake(0., 0., 170, 170)  andSong:selectedSong];
        UIImageView *cover = [[UIImageView alloc]init];
        [cover loadImageFromURL:[NSURL URLWithString:selectedSong.imageBig] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] cachingKey:nil];
        [songView addSubview:cover];
        songView.coverImage = cover;
        self.view = songView;

    }
    
      return self;
}

- (CGAffineTransform)orientationTransformFromSourceBounds:(CGRect)sourceBounds
{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	if (orientation == UIDeviceOrientationFaceUp ||
		orientation == UIDeviceOrientationFaceDown)
	{
		;//orientation = [UIApplication sharedApplication].statusBarOrientation;
	}
	
	if (orientation == UIDeviceOrientationPortraitUpsideDown)
	{
		return CGAffineTransformMakeRotation(M_PI);
	}
	else if (orientation == UIDeviceOrientationLandscapeLeft)
	{
		CGRect windowBounds = self.view.window.bounds;
		CGAffineTransform result = CGAffineTransformMakeRotation(0.5 * M_PI);
		result = CGAffineTransformTranslate(result,
			0.5 * (windowBounds.size.height - sourceBounds.size.width),
			0.5 * (windowBounds.size.height - sourceBounds.size.width));
		return result;
	}
	else if (orientation == UIDeviceOrientationLandscapeRight)
	{
		CGRect windowBounds = self.view.window.bounds;
		CGAffineTransform result = CGAffineTransformMakeRotation(-0.5 * M_PI);
		result = CGAffineTransformTranslate(result,
			0.5 * (windowBounds.size.width - sourceBounds.size.height),
			0.5 * (windowBounds.size.width - sourceBounds.size.height));
		return result;
	}

	return CGAffineTransformIdentity;
}

- (CGRect)rotatedWindowBounds
{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	if (orientation == UIDeviceOrientationFaceUp ||
		orientation == UIDeviceOrientationFaceDown)
	{
		;//orientation = [UIApplication sharedApplication].statusBarOrientation;
	}
	
	if (orientation == UIDeviceOrientationLandscapeLeft ||
		orientation == UIDeviceOrientationLandscapeRight)
	{
		CGRect windowBounds = self.view.window.bounds;
		return CGRectMake(0, 0, windowBounds.size.height, windowBounds.size.width);
	}

	return self.view.window.bounds;
}

- (void)deviceRotated:(NSNotification *)aNotification
{
	if (proxyView)
	{
		if (aNotification)
		{
			CGRect windowBounds = self.view.window.bounds;
			UIView *blankingView =
				[[UIView alloc] initWithFrame:
					CGRectMake(-0.5 * (windowBounds.size.height - windowBounds.size.width),
						0, windowBounds.size.height, windowBounds.size.height)];
			blankingView.backgroundColor = [UIColor blackColor];
			[self.view.superview insertSubview:blankingView belowSubview:self.view];
			
			[UIView animateWithDuration:0.25 animations:^{
				self.view.bounds = [self rotatedWindowBounds];
				self.view.transform = [self orientationTransformFromSourceBounds:self.view.bounds];
			} completion:^(BOOL complete){
				[blankingView removeFromSuperview];
			}];
		}
		else
		{
			self.view.bounds = [self rotatedWindowBounds];
			self.view.transform = [self orientationTransformFromSourceBounds:self.view.bounds];
		}
	}
	else
	{
		self.view.transform = CGAffineTransformIdentity;
	}
}

- (void)toggleZoom:(UITapGestureRecognizer *)gestureRecognizer
{
	if (proxyView)
	{
		CGRect frame =
			[proxyView.superview
				convertRect:self.view.frame
				fromView:self.view.window];
		self.view.frame = frame;
		
		CGRect proxyViewFrame = proxyView.frame;

		[proxyView.superview addSubview:self.view];
		[proxyView removeFromSuperview];
		proxyView = nil;

		[UIView
			animateWithDuration:0.2
			animations:^{
				self.view.frame = proxyViewFrame;
			}];
		[[UIApplication sharedApplication]
			setStatusBarHidden:NO
			withAnimation:UIStatusBarAnimationFade];
		
		[[NSNotificationCenter defaultCenter]
			removeObserver:self
			name:UIDeviceOrientationDidChangeNotification
			object:[UIDevice currentDevice]];
	}
	else
	{
		proxyView = [[UIView alloc] initWithFrame:self.view.frame];
		proxyView.hidden = YES;
		proxyView.autoresizingMask = self.view.autoresizingMask;
		[self.view.superview addSubview:proxyView];
		
		CGRect frame =
			[self.view.window
				convertRect:self.view.frame
				fromView:proxyView.superview];
		[self.view.window addSubview:self.view];
		self.view.frame = frame;

		[UIView
			animateWithDuration:0.2
			animations:^{
				self.view.frame = self.view.window.bounds;
			}];
		[[UIApplication sharedApplication]
			setStatusBarHidden:YES
			withAnimation:UIStatusBarAnimationFade];

		[[NSNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(deviceRotated:)
			name:UIDeviceOrientationDidChangeNotification
			object:[UIDevice currentDevice]];
	}
	
	[self deviceRotated:nil];
}

- (void)dismissFullscreenView
{
	if (proxyView)
	{
		[self toggleZoom:nil];
	}
}

- (void)setView:(UIView *)newView
{
	if (view)
	{
		[self toggleZoom:nil];
		[view removeGestureRecognizer:singleTapGestureRecognizer];
		singleTapGestureRecognizer = nil;
	}
	
	view = newView;
	
	singleTapGestureRecognizer =
		[[UITapGestureRecognizer alloc]
			initWithTarget:self action:@selector(toggleZoom:)];
	singleTapGestureRecognizer.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)dealloc
{
	[proxyView removeFromSuperview];
	proxyView = nil;
	
	singleTapGestureRecognizer = nil;

	view = nil;

	proxyView = nil;

}

@end

