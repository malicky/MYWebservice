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
#import "MYConstants.h"
#import "YMAppDelegate.h"
#import "YMPersistence.h"
#import "YMTableViewCell.h"
#import "MYZoomViewController.h"

#define debug 1

@interface YMSongListViewController () <NSXMLParserDelegate , YMFetchedResultsControllerDataSourceDelegate>
@property (nonatomic, strong) YMFetchedResultsControllerDataSource *dataSource;
@property (nonatomic, assign) CGRect frame;
@end

@implementation YMSongListViewController {
}

-(id)initWithFrame:(CGRect)rect andContext:(NSManagedObjectContext *)context{
	if (self = [super init]) {
        _frame = rect;
        self.managedObjectContext = context;
	}
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.frame = self.frame;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YMSong"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.dataSource = [[YMFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    [self.dataSource reuseIdentifier:@"SongCellIdentifier"];

    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                   managedObjectContext:self.managedObjectContext
                                                                                     sectionNameKeyPath:nil cacheName:nil];
    
    
    // Respond to changes
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
- (void)performFetch {
    int static k = 0;
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
            NSLog(@"int static k: %d: %@", ++k, self.title);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performFetch];
}

- (void)configureCell:(YMTableViewCell*)cell withObject:(YMSong*)object {
    cell.song = object;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)detailViewWithObject:(YMSong *)song {
//    UINavigationController *navController =  self.navigationController;
    MYZoomViewController * zoomVC = [[MYZoomViewController alloc]initWithNibName:@"MYZoomViewController" bundle:nil];
    [self.navigationController pushViewController:zoomVC animated:YES];

}
@end
