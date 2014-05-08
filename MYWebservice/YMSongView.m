//
//  YMSongView.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-06.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSongView.h"
#import "YMSong.h"

static const NSUInteger kLeftColumnOffset = 5;
//static const NSUInteger  kMiddleColumnOffset = 170;
static const NSUInteger  kRightColumnOffset = 270;
static const NSUInteger  kUpperRowTop = 5;
static const NSUInteger kLowerRowTop = 50;
static const NSUInteger kCoverImageHeight = 60;


NSUInteger DeviceSystemMajorVersion();

@interface YMSongView ()
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, strong) YMSong *song;
@property (nonatomic, assign) NSUInteger songIndex;

@end


@implementation YMSongView {
}

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

NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
    });
    return _deviceSystemMajorVersion;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
   
    // Drawing code
	UIColor *mainTextColor;
	UIColor *secondaryTextColor;
    UIFont *mainFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFont *secondaryFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];

    {
		mainTextColor = [UIColor blackColor];
		secondaryTextColor = [UIColor darkGrayColor];
	}
	
    
    NSDictionary *mainTextAttributes = @{ NSFontAttributeName :mainFont, NSForegroundColorAttributeName : mainTextColor };
    NSDictionary *secondaryTextAttributes = @{ NSFontAttributeName :secondaryFont, NSForegroundColorAttributeName : secondaryTextColor };

    CGPoint point;
    CGRect r;
     // Draw the title string
    NSAttributedString *songTitleAttributedString = [[NSAttributedString alloc] initWithString:self.song.title attributes:mainTextAttributes];
    point = CGPointMake(2*kLeftColumnOffset + kCoverImageHeight, kUpperRowTop);
    r = CGRectMake(point.x, point.y, 260, 44);
    //[songTitleAttributedString drawAtPoint:point];
    
    [songTitleAttributedString drawWithRect:r
                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                              context:nil];


    // Draw the artist string.
    NSAttributedString *artistString = [[NSAttributedString alloc] initWithString:self.song.artist attributes:secondaryTextAttributes];
    point = CGPointMake(2*kLeftColumnOffset + kCoverImageHeight, kLowerRowTop);
    [artistString drawAtPoint:point];
    // Draw the id string.
    NSAttributedString *idString = [[NSAttributedString alloc] initWithString:self.song.id attributes:secondaryTextAttributes];
    point = CGPointMake(kRightColumnOffset, kLowerRowTop);
    [idString drawAtPoint:point];

    
    //
    CGRect imageframe = CGRectMake(kLeftColumnOffset, kUpperRowTop, kCoverImageHeight, kCoverImageHeight);
    [[UIColor redColor] set];
    UIRectFill(imageframe); // this will fill the upper rect all red,


}


@end
