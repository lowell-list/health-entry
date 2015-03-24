//
//  SelectViewController.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "SelectViewController.h"
#import "HealthEntryItemManager.h"
#import "SimpleHealthEntryItem.h"
#import "UnitSelectTextField.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface SelectViewController()
{
@private
  UIPickerView *            mPicker;
  UnitSelectTextField *     mSelectedTextField;
  SimpleHealthEntryItem *   mSelectedItem;
  UIGestureRecognizer *     mTapGestureRecognizer;
}
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
  [self initPickerView];
  mSelectedItem = nil;
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

  // set label text
  UILabel *lbl = (UILabel *)[cell viewWithTag:200];
  lbl.text = itm.label;

  // set and prepare unit text field
  UnitSelectTextField *unttxtfld = (UnitSelectTextField *)[cell viewWithTag:300];
  if([itm isMemberOfClass:[SimpleHealthEntryItem class]])
  {
    // get current item as a SimpleHealthEntryItem
    SimpleHealthEntryItem *smpitm = (SimpleHealthEntryItem *)itm;
    
    // setup unit text field
    unttxtfld.text = [smpitm.selectedDataUnit unitString];
    unttxtfld.enabled = (smpitm.dataUnits.count > 1);
    if(unttxtfld.enabled) {
      unttxtfld.inputView = unttxtfld.enabled ? mPicker : nil;        // the picker view will display when this text field is edited
      unttxtfld.delegate = self;                                      // this UIViewController is the delegate
      unttxtfld.textColor = tableView.tintColor;
      unttxtfld.itemIndex = [indexPath row];                          // associate the current row index with this text field;
    }                                                                 // this is the index of the item in the _supportedItems array
    else {
      unttxtfld.inputView = nil;
      unttxtfld.delegate = nil;
      unttxtfld.textColor = [UIColor blackColor];
    }
  }
  else {
    unttxtfld.text = @"";                                             // text field is unused for other
    unttxtfld.enabled = NO;
    unttxtfld.delegate = nil;
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
#pragma mark INSTANCE METHODS - User Interaction
/**************************************************************************/

/**
 * Any tap gesture on the view will dismiss the picker (if visible)
 */
- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
  [self stopEditing];
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UITextFieldDelegate
/**************************************************************************/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  // save selected text field
  mSelectedTextField = (UnitSelectTextField *)textField;

  // determine selected item
  mSelectedItem = [_supportedItems objectAtIndex:mSelectedTextField.itemIndex];
  
  // reload picker view, set selected row
  [mPicker reloadAllComponents];
  [mPicker selectRow:mSelectedItem.selectedDataUnitIndex inComponent:0 animated:NO];
  
  // add tap gesture recognizer to auto dismiss picker by tapping somewhere else
  if(mTapGestureRecognizer) { [self.view removeGestureRecognizer:mTapGestureRecognizer]; }
  mTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
  [self.view addGestureRecognizer:mTapGestureRecognizer];

  return YES; // YES to allow editing, NO to disallow
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UIPickerView Delegate / Data Source for unit selection
/**************************************************************************/

- (void)initPickerView
{
  if(mPicker) { return; } // already initialized!
  
  mPicker = [[UIPickerView alloc] init];
  mPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  mPicker.backgroundColor = [UIColor whiteColor];
  mPicker.delegate = self;
  mPicker.dataSource = self;
}

// returns the number of columns to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

// returns the number of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if(!mSelectedItem) { return 1; }
  return mSelectedItem.dataUnits.count;
}

// returns the text to be displayed on each row of the picker
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if(!mSelectedItem) { return @""; }
  HKUnit *unt = [mSelectedItem.dataUnits objectAtIndex:row];
  return unt.unitString;
}

// called when the user selects a row of the picker view
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  if(mSelectedItem && mSelectedTextField) {
    mSelectedItem.selectedDataUnitIndex = row;
    mSelectedTextField.text = mSelectedItem.selectedDataUnit.unitString;
    [[HealthEntryItemManager instance] saveSelectedItems];
  }
  [self stopEditing];
}

- (void)stopEditing
{
  // resign first responder (which hides the picker)
  if(mSelectedTextField) { [mSelectedTextField resignFirstResponder]; }
  
  // remove references to selected item / text field
  mSelectedTextField = nil;
  mSelectedItem = nil;
  
  // remove tap gesture recognizer
  if(mTapGestureRecognizer) {
    [self.view removeGestureRecognizer:mTapGestureRecognizer];
    mTapGestureRecognizer = nil;
  }
}

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end