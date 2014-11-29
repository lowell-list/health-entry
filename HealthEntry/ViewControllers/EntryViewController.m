//
//  EntryViewController.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "EntryViewController.h"
#import "HealthEntryItemManager.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface EntryViewController()
{
@private
  NSInteger       mWriteSuccessCount;
  NSInteger       mWriteFailCount;
  NSInteger       mWriteTotalExpectedCount;
  UIDatePicker *  mDatePicker;
  UIDatePicker *  mTimePicker;
  NSDate *        mEntryDate;
}

/// UITableView on this ViewController
@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

@implementation EntryViewController

- (void)dealloc
{
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - ViewController
/**************************************************************************/

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // init
  mDatePicker = nil;
  mTimePicker = nil;
  mEntryDate = nil;

  // tap gesture recognizer to auto dismiss keyboard by tapping somewhere else
  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // reset date/time to now
  [self updateEntryDate:[NSDate date]];

  // remove date/time pickers if either happens to be showing
  [self disposeDatePicker];
  [self disposeTimePicker];
  
  // reload table view data every time this view appears
  [_tableView reloadData];
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - User Interaction
/**************************************************************************/

/**
 * Any tap gesture on the view will dismiss the keyboard (if visible)
 */
- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
  [self.view endEditing:YES];
  [self disposeDatePicker];
  [self disposeTimePicker];
}

- (IBAction)onDateButton
{
  // toggle picker
  if(mDatePicker) { [self disposeDatePicker]; }
  else            { [self showDatePicker];    }
}

- (IBAction)onTimeButton
{
  // toggle picker
  if(mTimePicker) { [self disposeTimePicker]; }
  else            { [self showTimePicker];    }
}

- (IBAction)onRecordButton
{
  // remove date/time pickers if either happens to be showing
  [self disposeDatePicker];
  [self disposeTimePicker];
  
  // get items with valid user input
  NSArray * vlditmarr = [[HealthEntryItemManager instance] getSelectedItemsWithValidInput];
  /**/NSLog(@"Valid item array: %@",vlditmarr);
  
  // if no valid items, cannot continue!
  if(vlditmarr.count==0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Items"
                                                    message:@"You must enter at least one item."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return;
  }
  
  // get set of HKSampleType objects
  NSSet * smptypset = [HealthEntryItemManager getDataTypesSetFromItems:vlditmarr];
  /**/NSLog(@"set of types: %@",smptypset);
  
  // request permissions for all types we want to write
  if([HKHealthStore isHealthDataAvailable])
  {
    [self.healthStore requestAuthorizationToShareTypes:smptypset readTypes:nil completion:^(BOOL success, NSError *error) {
      if(!success) {
        NSLog(@"You didn't allow this app to share data types. The error was: %@.", error);
        return;
      }
      NSLog(@"Successfully received permissions!");
      
      // init write counters
      mWriteSuccessCount = 0;
      mWriteFailCount = 0;
      mWriteTotalExpectedCount = vlditmarr.count;
      
      // write data to HealthKit
      for(NSUInteger xa=0; xa<vlditmarr.count; xa++) {
        HealthEntryItem *itm = (HealthEntryItem *)[vlditmarr objectAtIndex:xa];
        [itm saveIntoHealthStore:_healthStore entryDate:mEntryDate onDone:^(BOOL success) {
          
          // update counters
          if(success) { mWriteSuccessCount++; }
          else        { mWriteFailCount++;    }
          
          // show message if this is the last item
          if((mWriteFailCount+mWriteSuccessCount)==mWriteTotalExpectedCount)
          {
            dispatch_async(dispatch_get_main_queue(), ^{
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record Complete"
                                                              message:[NSString stringWithFormat:@"Successfully recorded %ld/%ld items",(long)mWriteSuccessCount,(long)mWriteTotalExpectedCount]
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
              [alert show];
            });
          }
        }];
      }
    }];
  }
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UITableViewDelegate
/**************************************************************************/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  HealthEntryItem *itm = [[self selectedItems] objectAtIndex:[indexPath row]]; // get item associated with current row
  return itm.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  // get item associated with current row
  HealthEntryItem *itm = [[self selectedItems] objectAtIndex:[indexPath row]];
  
  // let the item update the current cell
  [itm updateTableCell:cell];
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - UITableViewDataSource
/**************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self selectedItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // get item associated with current row
  HealthEntryItem *itm = [[self selectedItems] objectAtIndex:[indexPath row]];
  
  // get cell to use for this item
  UITableViewCell *cll = [tableView dequeueReusableCellWithIdentifier:itm.entryCellReuseId forIndexPath:indexPath];
  
  // let the item setup the cell
  [itm setupTableCell:cll];
  
  // return cell
  return cll;
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - Entry Date
/**************************************************************************/

- (void)updateEntryDate:(NSDate *)date
{
  mEntryDate = date;
  [self refreshDateButtonTitle];
  [self refreshTimeButtonTitle];
}

- (void)refreshDateButtonTitle
{
  if(!mEntryDate) { return; } // nothing to do!

  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterLongStyle];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [mDateButton setTitle:[dateFormatter stringFromDate:mEntryDate] forState:UIControlStateNormal];
}

- (void)refreshTimeButtonTitle
{
  if(!mEntryDate) { return; } // nothing to do!
  
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterNoStyle];
  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  [mTimeButton setTitle:[dateFormatter stringFromDate:mEntryDate] forState:UIControlStateNormal];
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - Date / Time Pickers
/**************************************************************************/

- (void)showDatePicker
{
  // do nothing if a date picker is already showing
  if(mDatePicker) { return; }
  
  // dispose any time picker that may be showing
  [self disposeTimePicker];
  
  // create and show new date picker
  mDatePicker = [[UIDatePicker alloc] init];
  mDatePicker.date = mEntryDate;
  mDatePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  mDatePicker.datePickerMode = UIDatePickerModeDate;
  [mDatePicker addTarget:self action:@selector(onDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
  CGSize pkrsiz = [mDatePicker sizeThatFits:CGSizeZero];
  mDatePicker.frame = CGRectMake(0.0, 100.0, pkrsiz.width, 460);
  mDatePicker.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:mDatePicker];
}

- (void)onDatePickerChanged:(UIDatePicker *)sender
{
  [self updateEntryDate:[sender date]];
}

- (void)disposeDatePicker
{
  if(mDatePicker) {
    [mDatePicker removeFromSuperview];
    mDatePicker = nil;
  }
}

- (void)showTimePicker
{
  // do nothing if a time picker is already showing
  if(mTimePicker) { return; }
  
  // dispose any date picker that may be showing
  [self disposeDatePicker];

  // create and show new time picker
  mTimePicker = [[UIDatePicker alloc] init];
  mTimePicker.date = mEntryDate;
  mTimePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  mTimePicker.datePickerMode = UIDatePickerModeTime;
  [mTimePicker addTarget:self action:@selector(onTimePickerChanged:) forControlEvents:UIControlEventValueChanged];
  CGSize pkrsiz = [mTimePicker sizeThatFits:CGSizeZero];
  mTimePicker.frame = CGRectMake(0.0, 100.0, pkrsiz.width, 460);
  mTimePicker.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:mTimePicker];
}

- (void)onTimePickerChanged:(UIDatePicker *)sender
{
  [self updateEntryDate:[sender date]];
}

- (void)disposeTimePicker
{
  if(mTimePicker) {
    [mTimePicker removeFromSuperview];
    mTimePicker = nil;
  }
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - Utility
/**************************************************************************/

- (NSArray *)selectedItems
{
  return [HealthEntryItemManager instance].selectedItems;
}

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
