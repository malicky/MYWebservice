//
//  SongListViewController.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMFetchedResultsControllerDataSource, YMSong;

@interface YMSongListViewController : UITableViewController

/**
 *  NSManagedObjectContext object bound to the datasource.
 */
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

/**
 *  <#Description#>
 *
 *  @param rect    <#rect description#>
 *  @param context managed object context that will be passed to the datasource
 *
 *  @return an instance of the class
 */
-(instancetype)initWithFrame:(CGRect)rect
        andContext:(NSManagedObjectContext*)context;

@end
