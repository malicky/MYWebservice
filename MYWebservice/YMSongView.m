//
//  YMSongView.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-06.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSongView.h"
#import "YMSong.h"

#define debug 0

static const NSUInteger kLeftColumnOffset = 5;
static const NSUInteger  __unused kMiddleColumnOffset = 170;
static const NSUInteger __unused  kRightColumnOffset = 250;
static const NSUInteger  kUpperRowTop = 5;
static const NSUInteger kLowerRowTop = 50;
static const NSUInteger kCoverImageHeight = 60;
static const NSUInteger kSongTitleAttributedStringRectWidth = 260;
static const NSUInteger kSongTitleAttributedStringRectHeigth = 30;


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
    
    [self drawArtist];
    [self drawTitle];
    [self drawCoverImage];
}

- (void)drawTitle {
    UIColor *secondaryTextColor = [UIColor darkGrayColor];
    UIFont *secondaryFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    NSDictionary *secondaryTextAttributes = @{ NSFontAttributeName :secondaryFont, NSForegroundColorAttributeName : secondaryTextColor };

    CGPoint point = CGPointMake(2*kLeftColumnOffset + kCoverImageHeight, kLowerRowTop);
    CGRect r = CGRectMake(point.x, point.y, kSongTitleAttributedStringRectWidth, kSongTitleAttributedStringRectHeigth);
    // Draw the title string
    NSAttributedString *songTitleAttributedString = [[NSAttributedString alloc] initWithString:self.song.title attributes:secondaryTextAttributes];
    [songTitleAttributedString drawWithRect:r
                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    
    
    
}
- (void)drawArtist {
    UIColor *mainTextColor = [UIColor blackColor];
    UIFont *mainFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSDictionary *mainTextAttributes = @{ NSFontAttributeName :mainFont, NSForegroundColorAttributeName : mainTextColor };
    
    CGPoint point = CGPointMake(2*kLeftColumnOffset + kCoverImageHeight, kUpperRowTop);

    NSAttributedString *artistString = [[NSAttributedString alloc] initWithString:self.song.artist attributes:mainTextAttributes];
     [artistString drawAtPoint:point];
    
    if (debug == 1) {
        // Draw the id string.
        NSAttributedString *idString = [[NSAttributedString alloc] initWithString:self.song.id attributes:mainTextAttributes];
        point = CGPointMake(kRightColumnOffset, kUpperRowTop);
        [idString drawAtPoint:point];
    }

}

- (void)drawCoverImage {
    CGRect imageframe = CGRectMake(kLeftColumnOffset, kUpperRowTop, kCoverImageHeight, kCoverImageHeight);
    [self.coverImage setFrame:imageframe];
}

@end
