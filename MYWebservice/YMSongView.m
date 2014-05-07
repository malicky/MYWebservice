//
//  YMSongView.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-06.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSongView.h"
#import "YMSong.h"

static const NSUInteger kLeftColumnOffset = 10;
//static const NSUInteger  MIDDLE_COLUMN_OFFSET = 170;
//static const NSUInteger  RIGHT_COLUMN_OFFSET = 270;
static const NSUInteger  kUpperRowTop = 12;
static const NSUInteger kLowerRowTop = 44;

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
    
     // Draw the title string
    NSAttributedString *songTitleAttributedString = [[NSAttributedString alloc] initWithString:self.song.title attributes:mainTextAttributes];
    point = CGPointMake(kLeftColumnOffset, kUpperRowTop);
    [songTitleAttributedString drawAtPoint:point];

    // Draw the artist string.
    NSAttributedString *artistTitleAttributedString = [[NSAttributedString alloc] initWithString:self.song.id attributes:secondaryTextAttributes];
    point = CGPointMake(kLeftColumnOffset, kLowerRowTop);
    [artistTitleAttributedString drawAtPoint:point];

}


@end
