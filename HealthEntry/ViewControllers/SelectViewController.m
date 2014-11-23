//
//  SelectViewController.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "SelectViewController.h"
#import "HealthEntryItemManager.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface SelectViewController()

/// An array of all supported items.
@property (nonatomic) NSArray * supportedItems;

@end

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

@implementation SelectViewController

- (void)dealloc
{
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - ViewController
/**************************************************************************/

- (void)viewDidLoad
{
  [super viewDidLoad];

  _supportedItems = [HealthEntryItemManager instance].supportedItems;
  /**/NSLog(@"Supported Items: %@",_supportedItems);
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UITableViewDelegate
/**************************************************************************/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  // lookup corresponding item
  HealthEntryItem *itm = [_supportedItems objectAtIndex:[indexPath row]];

  // set cell label
  [cell textLabel].text = itm.label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // lookup corresponding item
  HealthEntryItem *itm = [_supportedItems objectAtIndex:[indexPath row]];

  // UI deselect
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  // toggle checkmark; select/deselect item
  UITableViewCell *cll = [tableView cellForRowAtIndexPath:indexPath];
  if(cll.accessoryType == UITableViewCellAccessoryCheckmark) {
    cll.accessoryType = UITableViewCellAccessoryNone;
    [[HealthEntryItemManager instance] unselectItem:itm];
  }
  else {
    cll.accessoryType = UITableViewCellAccessoryCheckmark;
    [[HealthEntryItemManager instance] selectItem:itm];
  }
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UITableViewDataSource
/**************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _supportedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [tableView dequeueReusableCellWithIdentifier:@"selectSimpleCell" forIndexPath:indexPath];
}

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end