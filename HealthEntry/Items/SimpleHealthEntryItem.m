//
//  SimpleHealthEntryItem.m
//  HealthEntry
//
//  Created by Lowell List on 11/26/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "SimpleHealthEntryItem.h"
#import "HealthEntryItemManager.h"
#import "Util.h"

@interface SimpleHealthEntryItem()

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/
{
@private
}

@end

@implementation SimpleHealthEntryItem

@synthesize selectedDataUnitIndex = _selectedDataUnitIndex;

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

- (id)initWithIdentifier:(NSString *)identifier label:(NSString *)label sortValue:(NSInteger)sortValue
                dataType:(HKQuantityType *)dataType units:(NSArray *)units
{
  self = [super initWithIdentifier:identifier label:label sortValue:sortValue entryCellReuseId:@"entrySingleValueCell"];
  if(self) {
    _dataType = dataType;
    _dataUnits = units;
    _userInput = @"";
    self.selectedDataUnitIndex = 0;
  }
  return self;
}

- (void)dealloc
{
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UNIT SELECTION
/**************************************************************************/

- (void)setSelectedDataUnitIndex:(NSInteger)index
{
  _selectedDataUnitIndex = [Util clampNSInteger:index max:_dataUnits.count-1 min:0];
  _selectedDataUnit = [_dataUnits objectAtIndex:_selectedDataUnitIndex];
}

- (NSInteger)selectedDataUnitIndex
{
  return _selectedDataUnitIndex;
}

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

- (void)setupTableCell:(UITableViewCell *)cell
{
  // assign delegate (for keyboard 'Return key' handling)
  UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
  txtfld.delegate = self;
  
  // add UIControlEventEditingDidEnd handler
  [txtfld removeTarget:nil action:NULL forControlEvents:UIControlEventEditingDidEnd];
  [txtfld addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)updateTableCell:(UITableViewCell *)cell
{
  // set primary label text
  UILabel *lbl = (UILabel *)[cell viewWithTag:100];
  [lbl setText:[NSString stringWithFormat:@"%@ (%@)",_label,[[HealthEntryItemManager instance] unitDisplayString:self.selectedDataUnit]]];
  
  // set textfield text
  UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
  [txtfld setText:_userInput];
}

- (NSSet *)dataTypes {
  return [NSSet setWithObject:_dataType]; // SimpleHealthEntryItems have only one data type
}

- (void)saveIntoHealthStore:(HKHealthStore *)healthStore entryDate:(NSDate *)entryDate onDone:(void(^)(BOOL success))onDone
{
  // convert single value to double
  double val = [_userInput doubleValue];
  
  // deal with percent values as appropriate
  if([[self.selectedDataUnit unitString] isEqualToString:@"%"]) {
    val = [Util clampDouble:(val/100) max:1.0 min:0.0];
  }
  
  // create HealthKit quantity object
  HKQuantity *qnt = [HKQuantity quantityWithUnit:self.selectedDataUnit doubleValue:val];
  
  // create HealthKit quantity sample object
  HKQuantitySample *qntsmp = [HKQuantitySample quantitySampleWithType:_dataType quantity:qnt startDate:entryDate endDate:entryDate];
  
  // write data!
  [healthStore saveObject:qntsmp withCompletion:^(BOOL success, NSError *error) {
    // report write status
    if(success) { NSLog(@"success for item %@",self);                                             }
    else        { NSLog(@"An error occured saving the item %@. The error was: %@.", self, error); }
    // clear user input on success
    if(success) { _userInput = @""; _isInputValid=NO; }
    // call onDone handler
    onDone(success);
  }];
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - Utility
/**************************************************************************/

- (void)textFieldEditingDidEnd:(UITextField *)textField
{
  _userInput = textField.text;
  _isInputValid = (_userInput!=nil && _userInput.length>0);
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UITextFieldDelegate
/**************************************************************************/

/**
 * UITextField delegate: dismiss keyboard when Return is pressed
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
