//
//  SongListViewController.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "YMSongListViewController.h"
#import "YMFetchedResultsControllerDataSource.h"
#import "YMSong.h"
#import "YMAppDelegate.h"
#import "YMPersistence.h"
#import "YMTableViewCell.h"
#import "YMViewController.h"
#import "MYCoverView.h"

#define debug 1

@interface YMSongListViewController () <NSXMLParserDelegate ,YMFetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) YMFetchedResultsControllerDataSource *dataSource;
@property (nonatomic, assign) CGRect frame;

@end

@implementation YMSongListViewController {
}

-(id)initWithFrame:(CGRect)rect andContext:(NSManagedObjectContext *)context{
	if (self = [super init]) {
        _frame = rect;
        _managedObjectContext = context;
	}
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.frame = self.frame;
    
    // initialize the datasource property
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YMSong"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];

    self.dataSource = [[YMFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    [self.dataSource reuseIdentifier:@"SongCellIdentifier"];

    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                   managedObjectContext:self.managedObjectContext
                                                                                     sectionNameKeyPath:nil cacheName:nil];
    
    
    // Add self as observer of NSManagedObjectContextDidSaveNotification to fire performFetch and update the tableview
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                          NSManagedObjectContext *moc = self.managedObjectContext;
                                                          if (note.object == moc) {
                                                              [self performSelectorOnMainThread:@selector(performFetch)
                                                                                 withObject:nil
                                                                              waitUntilDone:NO];
                                                          }
                                                      }];
}

#pragma mark - FETCHING
/**
 *  There was a save notification: reload the table, and persist the changes
 */
- (void)performFetch {
    NSError *error;
	if (![ self.dataSource.fetchedResultsController  performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Failed to perform fetch %@, %@", error, [error userInfo]);
    } else {
        NSUInteger count = [self.dataSource.fetchedResultsController.fetchedObjects count];
        [self.tableView reloadData];
        self.title =  [NSString stringWithFormat:@"%lu Songs", (unsigned long)count];
        
        [[YMPersistence sharedInstance] saveContexts];
        
        if (debug == 1) {
            int static k = 0;
            NSLog(@"int static k: %d: %@", ++k, self.title);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // fetch the already imported songs
    [self performFetch];
}

- (void)configureCell:(YMTableViewCell*)cell withObject:(YMSong*)object {
    cell.song = object; // pass the song's data
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)detailViewWithObject:(YMSong *)song {
       YMViewController * zoomVC = [[YMViewController alloc]initWithNibName:@"YMViewController" bundle:nil andSong:song];
    [self.navigationController pushViewController:zoomVC animated:YES];

}
@end
