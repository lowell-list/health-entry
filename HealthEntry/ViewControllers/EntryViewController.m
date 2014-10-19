#import "EntryViewController.h"
#import "HealthEntryItem.h"

@interface EntryViewController()

// an array of the selected types that will be used for data entry
@property (nonatomic) NSMutableArray *selectedTypes;

@end


@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // TODO: make this array global
    _selectedTypes = [[NSMutableArray alloc] initWithObjects:
        [[HealthEntryItem alloc] initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] label:NSLocalizedString(@"Energy Burned", nil)],
        [[HealthEntryItem alloc] initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight] label:NSLocalizedString(@"Height", nil)],
        [[HealthEntryItem alloc] initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] label:NSLocalizedString(@"Weight", nil)],
        nil];
}

- (void)dealloc {
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _selectedTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthEntryItem *itm = [_selectedTypes objectAtIndex:[indexPath row]];
    return [tableView dequeueReusableCellWithIdentifier:itm.entryCellReuseId forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEntryItem *itm = [_selectedTypes objectAtIndex:[indexPath row]];
    
    // set label text
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    [lbl setText:itm.label];

    // set textfield text
    UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
    [txtfld setText:@"blank"];
}

@end
