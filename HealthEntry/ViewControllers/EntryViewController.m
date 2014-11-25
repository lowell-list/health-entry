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
  
/*
  // Set up an HKHealthStore, asking the user for read/write permissions. The profile view controller is the
  // first view controller that's shown to the user, so we'll ask for all of the desired HealthKit permissions now.
  // In your own app, you should consider requesting permissions the first time a user wants to interact with
  // HealthKit data.
  if ([HKHealthStore isHealthDataAvailable]) {
    NSSet *writeDataTypes = [self dataTypesToWrite];
    
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:nil completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
        
        return;
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        // Update the user interface based on the current user's health information.
        //[self updateUsersAgeLabel];
        //[self updateUsersHeightLabel];
        //[self updateUsersWeightLabel];
      });
    }];
  }
*/
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
  
  // TODO: request permissions for all items that have data (non blank)
  
  // TODO: if permissions successful; write to HealthKit!
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

/// HealthKit Permissions
- (NSSet *)dataTypesToWrite
{
  HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
  HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
  HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
  
  return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, nil];
}

- (void)saveHeightIntoHealthStore:(double)height
{
  // Save the user's height into HealthKit.
  HKUnit *inchUnit = [HKUnit inchUnit];
  HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:inchUnit doubleValue:height];
  
  HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
  NSDate *now = [NSDate date];
  
  HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:now endDate:now];
  
  [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the height sample %@. In your app, try to handle this gracefully. The error was: %@.", heightSample, error);
      abort();
    }
    
    NSLog(@"success height");
  }];
}

- (void)saveWeightIntoHealthStore:(double)weight
{
  // Save the user's weight into HealthKit.
  HKUnit *poundUnit = [HKUnit poundUnit];
  HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:poundUnit doubleValue:weight];
  
  HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
  NSDate *now = [NSDate date];
  
  HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
  
  [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the weight sample %@. In your app, try to handle this gracefully. The error was: %@.", weightSample, error);
      abort();
    }
    
    NSLog(@"success weight");
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
