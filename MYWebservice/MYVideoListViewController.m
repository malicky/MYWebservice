//
//  MYVideoListViewController.m
//  MYWebservice
//
//  Created by Malick Youla on 2014-03-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "MYVideoListViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Video.h"
#import "MYConstants.h"

@interface MYVideoListViewController () <FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource *dataSource;

@end


@implementation MYVideoListViewController {
    CGRect _frame;
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
    
    self.view.frame = _frame;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.dataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    [self.dataSource reuseIdentifier:@"VideoCellIdentifier"];

    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                   managedObjectContext:self.managedObjectContext
                                                                                     sectionNameKeyPath:nil cacheName:nil];
    
    
    // Respond to changes
    [[NSNotificationCenter defaultCenter] addObserverForName:kDidImportNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                              NSError *error;
                                                              if (![ self.dataSource.fetchedResultsController  performFetch:&error]) {
                                                                  // Update to handle the error appropriately.
                                                                  NSLog(@"Failed to perform fetch %@, %@", error, [error userInfo]);
                                                              } else {
                                                                  [self.dataSource reloadData];
                                                              }
                                                      }];


}

#pragma mark - FETCHING
- (void)performFetch {
    
    NSError *error;
	if (![ self.dataSource.fetchedResultsController  performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Failed to perform fetch %@, %@", error, [error userInfo]);
    } else {
        [self.tableView reloadData];

    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performFetch];

     self.title = @"Videos";
    
}

- (void)configureCell:(UITableViewCell*)cell withObject:(Video*)object {
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.videoDescription;
}

- (void)deleteObject:(id)object {
    
}

@end
