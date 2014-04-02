
#import <CoreData/CoreData.h>
#import "FetchedResultsControllerDataSource.h"


@interface FetchedResultsControllerDataSource ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic,copy) NSString *reuseIdentifier;

@end

@implementation FetchedResultsControllerDataSource


- (id)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)reloadData {
    [self.tableView reloadData];
}
-(void)reuseIdentifier:(NSString *)reuseIdentifier {
    if (!self.reuseIdentifier) {
        self.reuseIdentifier = reuseIdentifier;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.reuseIdentifier];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%@", @(self.fetchedResultsController.sections.count));
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

- (UITableView*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    [self.delegate configureCell:cell withObject:object];
    return cell;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeUpdate) {
        if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        NSAssert(NO,@"");
    }
}

- (void)setFetchResultsController:(NSFetchedResultsController *)fetchedResultsController {static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fetchedResultsController = fetchedResultsController;
        fetchedResultsController.delegate = self;
        [fetchedResultsController performFetch:NULL];
    });
}

- (id)selectedItem {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}

- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}

@end