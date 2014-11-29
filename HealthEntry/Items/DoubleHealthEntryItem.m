//
//  CorrelationHealthEntryItem.m
//  HealthEntry
//
//  Created by Lowell List on 11/28/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "DoubleHealthEntryItem.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface DoubleHealthEntryItem()

@end

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

@implementation DoubleHealthEntryItem

- (id)initWithLabel:(NSString *)label sortValue:(NSInteger)sortValue
         dataLabel1:(NSString *)dataLabel1 dataType1:(HKQuantityType *)dataType1 unit1:(HKUnit *)unit1
         dataLabel2:(NSString *)dataLabel2 dataType2:(HKQuantityType *)dataType2 unit2:(HKUnit *)unit2 {
  self = [super initWithLabel:label sortValue:sortValue entryCellReuseId:@"entryDoubleValueCell"];
  if(self) {
    _rowHeight = 84;
    
    _dataLabel1 = dataLabel1;
    _dataType1 = dataType1;
    _dataUnit1 = unit1;
    _userInput1 = @"";
    
    _dataLabel2 = dataLabel2;
    _dataType2 = dataType2;
    _dataUnit2 = unit2;
    _userInput2 = @"";
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
  UITextField *txtfld;        // text field reference
  
  // setup text field 1
  txtfld = (UITextField *)[cell viewWithTag:200];
  txtfld.delegate = self; // assign delegate (for keyboard 'Return key' handling)
  [txtfld removeTarget:nil action:NULL forControlEvents:UIControlEventEditingDidEnd];
  [txtfld addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];

  // setup text field 2
  txtfld = (UITextField *)[cell viewWithTag:400];
  txtfld.delegate = self; // assign delegate (for keyboard 'Return key' handling)
  [txtfld removeTarget:nil action:NULL forControlEvents:UIControlEventEditingDidEnd];
  [txtfld addTarget:self action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)updateTableCell:(UITableViewCell *)cell
{
  UILabel       *lbl;         // label reference
  UITextField   *txtfld;      // text field reference
  
  // set data label 1 and text field 1
  lbl = (UILabel *)[cell viewWithTag:100];
  [lbl setText:[NSString stringWithFormat:@"%@ %@",_label,_dataLabel1]];
  txtfld = (UITextField *)[cell viewWithTag:200];
  [txtfld setText:_userInput1];

  // set data label 2 and text field 2
  lbl = (UILabel *)[cell viewWithTag:300];
  [lbl setText:[NSString stringWithFormat:@"%@",_dataLabel2]];
  txtfld = (UITextField *)[cell viewWithTag:400];
  [txtfld setText:_userInput2];
}

- (void)textFieldEditingDidEnd:(UITextField *)textField
{
  // get user text input
  if(textField.tag==200) { _userInput1 = textField.text; /**/NSLog(@"set userInput1 text to [%@] for item %@",_userInput1,self); }
  if(textField.tag==400) { _userInput2 = textField.text; /**/NSLog(@"set userInput2 text to [%@] for item %@",_userInput2,self); }
  
  // determine if all input is valid
  _isInputValid = (_userInput1!=nil && _userInput1.length>0) &&
                  (_userInput2!=nil && _userInput2.length>0);
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
