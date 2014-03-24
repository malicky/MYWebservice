//
//  SongListViewController.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FetchedResultsControllerDataSource;

@interface SongListViewController : UITableViewController

@property ( nonatomic,strong) NSManagedObjectContext *managedObjectContext;
-(id)initWithFrame:(CGRect)rect andContext:(NSManagedObjectContext*)context;
@end