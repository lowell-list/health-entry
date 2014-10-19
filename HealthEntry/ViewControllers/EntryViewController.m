#import "EntryViewController.h"

@interface EntryViewController()

// an array of the selected types that will be used for data entry
@property (nonatomic) NSMutableArray *selectedTypes;

@end


NSString *const EntryViewControllerTableViewCellReuseIdentifier = @"singleEntryCell";


@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedTypes = [[NSMutableArray alloc] initWithObjects:@"Weight", @"Height", @"Blood Pressure", nil];
}

- (void)dealloc {
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:EntryViewControllerTableViewCellReuseIdentifier forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set label text
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    [lbl setText:[self.selectedTypes objectAtIndex:[indexPath row]]];

    // set textfield text
    UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
    [txtfld setText:[self.selectedTypes objectAtIndex:[indexPath row]]];
}

@end
