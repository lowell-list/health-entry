//
//  EntryViewController.h
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

@import UIKit;
@import HealthKit;

@interface EntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/
{
  IBOutlet UIButton *mDateButton;
  IBOutlet UIButton *mTimeButton;
}

@property (nonatomic) HKHealthStore * healthStore;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/// Date button handler
- (IBAction)onDateButton;

/// Time button handler
- (IBAction)onTimeButton;

/// Record button handler
- (IBAction)onRecordButton;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
