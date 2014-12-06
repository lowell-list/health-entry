//
//  SimpleHealthEntryItem.m
//  HealthEntry
//
//  Created by Lowell List on 11/26/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "SimpleHealthEntryItem.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface SimpleHealthEntryItem()

@end

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

@implementation SimpleHealthEntryItem

- (id)initWithIdentifier:(NSString *)identifier label:(NSString *)label sortValue:(NSInteger)sortValue
                dataType:(HKQuantityType *)dataType unit:(HKUnit *)unit
{
  self = [super initWithIdentifier:identifier label:label sortValue:sortValue entryCellReuseId:@"entrySingleValueCell"];
  if(self) {
    _dataType = dataType;
    _dataUnit = unit;
    _userInput = @"";
  }
  return self;
}

- (void)dealloc
{
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
  [lbl setText:_label];
  
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
  if([[_dataUnit unitString] isEqualToString:@"%"]) {
    val = [self clampDouble:(val/100) max:1.0 min:0.0];
  }
  
  // create HealthKit quantity object
  HKQuantity *qnt = [HKQuantity quantityWithUnit:_dataUnit doubleValue:val];
  
  // create HealthKit quantity sample object
  HKQuantitySample *qntsmp = [HKQuantitySample quantitySampleWithType:_dataType quantity:qnt startDate:entryDate endDate:entryDate];
  
  // write data!
  [healthStore saveObject:qntsmp withCompletion:^(BOOL success, NSError *error) {
    // report write status
    if(success) { NSLog(@"success for item %@",self);                                             }
    else        { NSLog(@"An error occured saving the item %@. The error was: %@.", self, error); }
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
  /**/NSLog(@"set userInput text to [%@] for item %@",_userInput,self);
}

- (double)clampDouble:(double)value max:(double)max min:(double)min
{
  if(value<min) { return min; }
  if(value>max) { return max; }
  return value;
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
