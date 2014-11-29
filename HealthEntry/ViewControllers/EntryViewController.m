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
      for(NSUInteger xa=0; xa<vlditmarr.count; xa++) {
        HealthEntryItem *itm = (HealthEntryItem *)[vlditmarr objectAtIndex:xa];
        [itm saveIntoHealthStore:_healthStore onDone:^(BOOL success) {
          
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
