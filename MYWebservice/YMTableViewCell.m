//
//  YMTableViewCell.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-05-06.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMTableViewCell.h"
#import "YMSong.h"
#import "YMSongView.h"
#import "UIImageView+Network.h"

NSUInteger kRowHeight = 70;
NSUInteger kSongViewTag = 1950;

@implementation YMTableViewCell {
}

-  (void)setSong:(YMSong *)song {
    
    _song = song;
    
        // the cell may have been reused, remove the song's view with the kSongViewTag
    UIView *v = [self.contentView viewWithTag:kSongViewTag];
    if (v) {
        [v removeFromSuperview];
    }
    
    // create a song's view
    YMSongView *songView = [[YMSongView alloc]initWithFrame:CGRectMake(0., 0., 480., kRowHeight)  andSong:song];
    
    // load (asynchronously) the image of the song's cover view
    UIImageView *cover = [[UIImageView alloc]init];
    [cover loadImageFromURL:[NSURL URLWithString:_song.imageMedium]
           placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                 cachingKey:_song.imageMedium];
    
    // add song's cover view to song' view
    [songView addSubview:cover];
    songView.coverImage = cover;
    
    // add songView as subview of this custom cell and set the tag
    songView.tag = kSongViewTag;
    [self.contentView addSubview:songView];

    return;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
