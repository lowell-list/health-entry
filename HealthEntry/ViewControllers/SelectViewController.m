//
//  SelectViewController.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "SelectViewController.h"
#import "HealthEntryItemManager.h"
#import "SimpleHealthEntryItem.h" /**/

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
  /**/
  UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
  if([itm isMemberOfClass:[SimpleHealthEntryItem class]]) {
    SimpleHealthEntryItem *smpitm = (SimpleHealthEntryItem *)itm;
    txtfld.text = [NSString stringWithFormat:@"%@ (%@)",smpitm.label,[smpitm.selectedDataUnit unitString]];
  }
  else {
    txtfld.text = itm.label;
  }
  
  // set initial checkmark state
  BOOL slt = [[HealthEntryItemManager instance] isItemSelected:itm];
  [self setCheckmark:slt forCell:cell inTable:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // lookup corresponding item
  HealthEntryItem *itm = [_supportedItems objectAtIndex:[indexPath row]];

  // UI deselect
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
  // toggle checkmark; select/deselect item
  UITableViewCell *cll = [tableView cellForRowAtIndexPath:indexPath];
  if([[HealthEntryItemManager instance] isItemSelected:itm]) {
    [self setCheckmark:NO forCell:cll inTable:tableView];
    [[HealthEntryItemManager instance] unselectItem:itm];
  }
  else {
    [self setCheckmark:YES forCell:cll inTable:tableView];
    [[HealthEntryItemManager instance] selectItem:itm];
  }
}

- (void)setCheckmark:(BOOL)checked forCell:(UITableViewCell *)cell inTable:(UITableView *)table
{
  UIImageView *imgvue = (UIImageView *)[cell viewWithTag:100];
  if(checked) {
    imgvue.image = [UIImage imageNamed:@"icon_checkmark"];
    imgvue.image = [imgvue.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgvue.tintColor = table.tintColor;
  }
  else {
    imgvue.image = nil;
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