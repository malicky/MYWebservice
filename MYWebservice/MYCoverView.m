//
//  MYCoverView.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-13.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYCoverView.h"
#import "YMSong.h"


@interface MYCoverView ()
@property (nonatomic, strong) YMSong *song;
@end

@implementation MYCoverView 

- (id)initWithFrame:(CGRect)frame andSong:(YMSong *)song
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _song = song;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    for (UIView *subview in self.subviews)
//    {
//        NSLog(@"%@ = %@", [subview class], NSStringFromCGRect(subview.frame));
//    }
//    [self drawCoverImage];
//}

- (void)drawCoverImage {
    //CGRect imageframe = CGRectMake(0, 0, 170, 170);
    //[self setFrame:imageframe];
    
}
@end
