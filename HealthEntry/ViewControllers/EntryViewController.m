#import "EntryViewController.h"

@interface EntryViewController()

@property (nonatomic) NSMutableArray *selectedTypes;

@end


NSString *const AAPLJournalViewControllerTableViewCellReuseIdentifier = @"cell";


@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedTypes = [NSMutableArray array];
}

- (void)dealloc {
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3; //self.selectedTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:AAPLJournalViewControllerTableViewCellReuseIdentifier forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = @"text";
    cell.detailTextLabel.text = @"detail text";
}

@end
