//
//  EntryViewController.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "EntryViewController.h"
#import "HealthEntryItemManager.h"

@interface EntryViewController()

// an array of the selected items that will be used for data entry
@property (nonatomic) NSArray *selectedItems;

@end

@implementation EntryViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _selectedItems = [HealthEntryItemManager instance].selectedItems;
  /**/NSLog(@"%@",_selectedItems);
}

- (void)dealloc {
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _selectedItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthEntryItem *itm = [_selectedItems objectAtIndex:[indexPath row]];
    return [tableView dequeueReusableCellWithIdentifier:itm.entryCellReuseId forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEntryItem *itm = [_selectedItems objectAtIndex:[indexPath row]];
    
    // set label text
    UILabel *lbl = (UILabel *)[cell viewWithTag:100];
    [lbl setText:itm.label];

    // set textfield text
    UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
    [txtfld setText:@"blank"];
}

@end
