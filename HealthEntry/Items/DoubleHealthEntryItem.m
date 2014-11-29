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
    correlationType:(HKCorrelationType *)correlationType
         dataLabel1:(NSString *)dataLabel1 dataType1:(HKQuantityType *)dataType1 unit1:(HKUnit *)unit1
         dataLabel2:(NSString *)dataLabel2 dataType2:(HKQuantityType *)dataType2 unit2:(HKUnit *)unit2
{
  self = [super initWithLabel:label sortValue:sortValue entryCellReuseId:@"entryDoubleValueCell"];
  if(self) {
    _rowHeight = 84;
    _correlationType = correlationType;
    
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
  UITextField   *txtfld;      // text field reference
  
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
  [lbl setText:[NSString stringWithFormat:@"%@   %@",self.label,self.dataLabel1]];
  txtfld = (UITextField *)[cell viewWithTag:200];
  [txtfld setText:self.userInput1];

  // set data label 2 and text field 2
  lbl = (UILabel *)[cell viewWithTag:300];
  [lbl setText:[NSString stringWithFormat:@"%@",self.dataLabel2]];
  txtfld = (UITextField *)[cell viewWithTag:400];
  [txtfld setText:self.userInput2];
}

- (NSSet *)dataTypes {
  return [NSSet setWithObjects:self.dataType1,self.dataType2,nil];
}

- (void)saveIntoHealthStore:(HKHealthStore *)healthStore onDone:(void(^)(BOOL success))onDone
{
  // convert user inputs to doubles
  double val1 = [self.userInput1 doubleValue];
  double val2 = [self.userInput2 doubleValue];
  
  // create HealthKit quantity objects
  HKQuantity *qnt1 = [HKQuantity quantityWithUnit:self.dataUnit1 doubleValue:val1];
  HKQuantity *qnt2 = [HKQuantity quantityWithUnit:self.dataUnit2 doubleValue:val2];
  
  // get sample date
  NSDate *now = [NSDate date];
  
  // create HealthKit quantity sample objects
  HKQuantitySample *qntsmp1 = [HKQuantitySample quantitySampleWithType:self.dataType1 quantity:qnt1 startDate:now endDate:now];
  HKQuantitySample *qntsmp2 = [HKQuantitySample quantitySampleWithType:self.dataType2 quantity:qnt2 startDate:now endDate:now];

  // create HKCorrelation
  NSSet *objset=[NSSet setWithObjects:qntsmp1,qntsmp2,nil];
  HKCorrelation *crl = [HKCorrelation correlationWithType:self.correlationType startDate:now endDate:now objects:objset];
  
  // write data!
  [healthStore saveObject:crl withCompletion:^(BOOL success, NSError *error) {
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
  // get user text input
  if(textField.tag==200) { _userInput1 = textField.text; }
  if(textField.tag==400) { _userInput2 = textField.text; }
  
  // determine if all input is valid
  _isInputValid = (self.userInput1!=nil && self.userInput1.length>0) &&
                  (self.userInput2!=nil && self.userInput2.length>0);
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
