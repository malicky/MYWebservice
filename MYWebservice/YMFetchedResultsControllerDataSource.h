//
//  FetchedResultsControllerDataSource.h
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-09.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class  NSFetchedResultsController;

@protocol YMFetchedResultsControllerDataSourceDelegate
- (void)configureCell:(id)cell withObject:(id)object;
@end

@interface YMFetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<YMFetchedResultsControllerDataSourceDelegate> delegate;

- (id)initWithTableView:(UITableView*)tableView;
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;
- (void)reuseIdentifier:(NSString *)reuseIdentifier;
- (void)reloadData;

@end
