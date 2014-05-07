
#import <CoreData/CoreData.h>
#import "YMFetchedResultsControllerDataSource.h"
#import "YMTableViewCell.h"

extern const NSInteger kRowHeight;


@interface YMFetchedResultsControllerDataSource ()
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic,copy) NSString *reuseIdentifier;
@end

@implementation YMFetchedResultsControllerDataSource

- (id)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        [self.tableView setRowHeight:kRowHeight];

    }
    return self;
}

- (void)reloadData {
    [self.tableView reloadData];
}

-(void)reuseIdentifier:(NSString *)reuseIdentifier {
    if (!self.reuseIdentifier) {
        self.reuseIdentifier = reuseIdentifier;
        [self.tableView registerClass:[YMTableViewCell class] forCellReuseIdentifier:self.reuseIdentifier];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    return NO;
}

- (id)selectedItem {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}

@end