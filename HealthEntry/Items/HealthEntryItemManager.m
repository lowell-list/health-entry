//
//  HealthEntryItemManager.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "HealthEntryItemManager.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface HealthEntryItemManager()

@end

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

@implementation HealthEntryItemManager

- (id)init
{
  if(self=[super init]) {
    // init
    [self initSupportedItems];
    [self initSelectedItems];
  }
  return self;
}

- (void)dealloc
{
  // should never be called (Singleton), but just here for clarity
}

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/**
 * Initializes all supported items.  Should be called only once, at Singleton init.
 */
- (void)initSupportedItems
{
  _supportedItems =
    [[NSArray alloc] initWithObjects:

     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage]
      unit:[HKUnit percentUnit]
      label:NSLocalizedString(@"Body Fat Percentage (%)", nil)
      sortValue:10],

     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex]
      unit:[HKUnit countUnit]
      label:NSLocalizedString(@"Body Mass Index", nil)
      sortValue:20],

     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]
      unit:[HKUnit poundUnit]
      label:NSLocalizedString(@"Weight (lbs)", nil)
      sortValue:30],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose]
      unit:[HKUnit unitFromString:@"mg/dL"]
      label:NSLocalizedString(@"Blood Glucose (mg/dL)", nil)
      sortValue:40],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation]
      unit:[HKUnit percentUnit]
      label:NSLocalizedString(@"Oxygen Saturation (%)", nil)
      sortValue:50],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature]
      unit:[HKUnit degreeFahrenheitUnit]
      label:NSLocalizedString(@"Body Temperature (deg F)", nil)
      sortValue:60],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]
      unit:[HKUnit unitFromString:@"count/min"]
      label:NSLocalizedString(@"Heart Rate (beats / min)", nil)
      sortValue:70],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate]
      unit:[HKUnit unitFromString:@"count/min"]
      label:NSLocalizedString(@"Respiratory Rate (count / min)", nil)
      sortValue:80],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]
      unit:[HKUnit calorieUnit]
      label:NSLocalizedString(@"Active Calories (cal)", nil)
      sortValue:90],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling]
      unit:[HKUnit mileUnit]
      label:NSLocalizedString(@"Cycling Distance (miles)", nil)
      sortValue:100],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]
      unit:[HKUnit mileUnit]
      label:NSLocalizedString(@"Walk/Run Distance (miles)", nil)
      sortValue:110],
     
     nil];
}

/**************************************************************************/
#pragma mark INSTANCE METHODS - SELECTED ITEMS
/**************************************************************************/

/**
 * Loads all previously selected items.  Should be called only once, at Singleton init.
 */
- (void)initSelectedItems
{
  // TODO: read from storage instead
  /**/_selectedItems = [[NSMutableArray alloc] init];
  
  // ensure selected items array always starts out properly sorted!
  [self sortSelectedItems];
}

- (void)sortSelectedItems
{
  NSArray *tmparr = [_selectedItems sortedArrayUsingComparator:[HealthEntryItem comparator]];
  _selectedItems = [NSMutableArray arrayWithArray:tmparr];
}

- (void)selectItem:(HealthEntryItem *)item
{
  // get NSMutableArray * reference
  NSMutableArray *selitmarr = (NSMutableArray *)_selectedItems;
  
  // remove all instances to ensure no duplicates
  [selitmarr removeObject:item];
  
  // get insertion index to maintain a sorted array (use binary search)
  NSUInteger srtidx = [selitmarr indexOfObject:item
                                 inSortedRange:(NSRange){0, [selitmarr count]}
                                       options:NSBinarySearchingInsertionIndex
                               usingComparator:[HealthEntryItem comparator]];
  // insert
  [selitmarr insertObject:item atIndex:srtidx];

  // save selected items
  [self saveSelectedItems];
}

- (void)unselectItem:(HealthEntryItem *)item
{
  // update selected items
  NSMutableArray *selitmarr = (NSMutableArray *)_selectedItems;
  [selitmarr removeObject:item];
  
  // save selected items
  [self saveSelectedItems];
}

- (BOOL)isItemSelected:(HealthEntryItem *)item
{
  return NO;
}

- (NSArray *)getSelectedItemsWithValidInput
{
  NSPredicate *prd = [NSPredicate predicateWithFormat:@"(userInput != nil) && (userInput != '')"];
  return [_selectedItems filteredArrayUsingPredicate:prd];
}

- (void)loadSelectedItems
{
  // TODO: load all selected items from storage
}

- (void)saveSelectedItems
{
  // TODO: save all selected items to storage
}

/**************************************************************************/
#pragma mark CLASS METHODS - SINGLETON
/**************************************************************************/

+ (HealthEntryItemManager *)instance
{
  static HealthEntryItemManager *singletonInstance = nil;
  
  // this code will run only once
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    singletonInstance = [[self alloc] init];
  });
  
  return singletonInstance;
}

/**************************************************************************/
#pragma mark CLASS METHODS - UTILITY
/**************************************************************************/

+ (NSSet *)getDataTypesSetFromItems:(NSArray *)healthEntryItems
{
  // create empty set
  NSMutableSet * set = [NSMutableSet set];
  
  // push all HKSampleType objects into the set
  for(NSUInteger xa=0; xa<healthEntryItems.count; xa++) {
    HKSampleType * smptyp = ((HealthEntryItem *)[healthEntryItems objectAtIndex:xa]).dataType;
    [set addObject:smptyp];
  }
  
  // return set
  return set;
}

@end
