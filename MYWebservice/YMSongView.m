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
static const NSUInteger kSongArtistAttributedStringRectWidth = 150;


NSUInteger DeviceSystemMajorVersion();

@interface YMSongView ()

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, strong) YMSong *song;
@property (nonatomic, assign) NSUInteger songIndex;

@end


@implementation YMSongView {
}
/**
 *  <#Description#>
 *
 *  @param frame <#frame description#>
 *  @param song  <#song description#>
 *
 *  @return <#return value description#>
 */
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


/**
 *  <#Description#>
 *
 *  @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect {
    
    // Artist name's string
    [self drawArtist];
    
    // song's title string
    [self drawTitle];
    
    // song's cover image
    [self drawCoverImage];
}

#pragma draw methods

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
    CGRect r = CGRectMake(point.x, point.y, kSongArtistAttributedStringRectWidth, kSongTitleAttributedStringRectHeigth);

    NSAttributedString *artistString = [[NSAttributedString alloc] initWithString:self.song.artist attributes:mainTextAttributes];

    [artistString drawWithRect:r options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    
}
/**
 *  set the frame of the cover view
 */
- (void)drawCoverImage {
    CGRect imageframe = CGRectMake(kLeftColumnOffset, kUpperRowTop, kCoverImageHeight, kCoverImageHeight);
    [self.coverImage setFrame:imageframe];
}

@end
