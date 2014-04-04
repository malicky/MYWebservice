//
//  SongListViewController.m
//  iTunesWebservice
//
//  Created by Malick Youla on 2014-03-11.
//  Copyright (c) 2014 Malick Youla. All rights reserved.
//

#import "SongListViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Song.h"
#import "MYConstants.h"

@interface SongListViewController () <NSXMLParserDelegate , FetchedResultsControllerDataSourceDelegate>
@property (nonatomic, strong) FetchedResultsControllerDataSource *dataSource;
@property (nonatomic, assign) CGRect frame;
@end


@implementation SongListViewController {
    
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
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.dataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    [self.dataSource reuseIdentifier:@"SongCellIdentifier"];

    self.dataSource.delegate = self;
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                   managedObjectContext:self.managedObjectContext
                                                                                     sectionNameKeyPath:nil cacheName:nil];
    
    
    // Respond to changes
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                          [self performSelectorOnMainThread:@selector(performFetch)
                                                                                 withObject:nil
                                                                              waitUntilDone:NO];
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
        self.title =  [NSString stringWithFormat:@"%lu Songs", (unsigned long)[self.dataSource.fetchedResultsController.fetchedObjects count]];

    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performFetch];
    self.title = @"Songs";
}

- (void)configureCell:(UITableViewCell*)cell withObject:(Song*)object {
    cell.textLabel.text = object.title;
    NSLog(@"cell.textLabel.text: %@", cell.textLabel.text);

    //cell.detailTextLabel.text = object.videoDescription;
}

- (void)deleteObject:(id)object {
    
}

@end
