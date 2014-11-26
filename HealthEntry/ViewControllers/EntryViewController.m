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
  NSInteger     mWriteSuccessCount;
  NSInteger     mWriteFailCount;
  NSInteger     mWriteTotalExpectedCount;
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

  // tap gesture recognizer to auto dismiss keyboard by tapping somewhere else
  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
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
}

- (IBAction)onRecordButton
{
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
      for(NSUInteger xa=0; xa<vlditmarr.count; xa++) { [self saveItemIntoHealthStore:[vlditmarr objectAtIndex:xa]]; }
    }];
  }
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
  // get item associated with current row
  HealthEntryItem *itm = [[self selectedItems] objectAtIndex:[indexPath row]];
  
  // set label text
  UILabel *lbl = (UILabel *)[cell viewWithTag:100];
  [lbl setText:itm.label];
  
  // set textfield text
  UITextField *txtfld = (UITextField *)[cell viewWithTag:200];
  [txtfld setText:itm.userInput];
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
  
  // assign delegate
  UITextField *txtfld = (UITextField *)[cll viewWithTag:200];
  txtfld.delegate = self;
  
  // add UIControlEventEditingDidEnd handler
  [txtfld removeTarget:itm action:NULL forControlEvents:UIControlEventEditingDidEnd];
  [txtfld addTarget:itm action:@selector(textFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];

  // return cell
  return cll;
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - HealthKit
/**************************************************************************/

- (void)saveItemIntoHealthStore:(HealthEntryItem *)item
{
  // convert value to double
  double val = [item.userInput doubleValue];
  if(val==0.0) { NSLog(@"warning: invalid value? %@ is 0.0",item.label); }
  
  // create HealthKit quantity object
  HKQuantity *qnt = [HKQuantity quantityWithUnit:item.dataUnit doubleValue:val];
  
  // get sample date
  NSDate *now = [NSDate date];
  
  // create HealthKit quantity sample object
  // TODO: improve so no (HKQuantityType *) cast is needed
  HKQuantitySample *qntsmp = [HKQuantitySample quantitySampleWithType:(HKQuantityType *)item.dataType quantity:qnt startDate:now endDate:now];

  // write data!
  [self.healthStore saveObject:qntsmp withCompletion:^(BOOL success, NSError *error) {
    
    // increment success/fail counters
    if(success) {
      NSLog(@"success for %@ item",item.label);
      mWriteSuccessCount++;
    }
    else {
      NSLog(@"An error occured saving the %@ item. The error was: %@.", item.label, error);
      mWriteFailCount++;
    }
    
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
