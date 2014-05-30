//
//  MYCoverView.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-13.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYCoverView.h"

NSInteger kCoverViewTag = 999;

@interface MYCoverView ()
@end

@implementation MYCoverView 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTag:kCoverViewTag]; // so we can find it from the scroll view
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}

@end
