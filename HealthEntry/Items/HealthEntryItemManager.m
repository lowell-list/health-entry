//
//  HealthEntryItemManager.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "HealthEntryItemManager.h"
#import "SimpleHealthEntryItem.h"
#import "DoubleHealthEntryItem.h"

/**************************************************************************/
#pragma mark CONSTANTS
/**************************************************************************/

// NSUserDefaults keys
static NSString * const kSelectedHealthEntryItems = @"SelectedHealthEntryItems";

// selected items data
static NSString * const kSelectedHealthEntryItemsVersionKey     = @"version";
static NSInteger  const kSelectedHealthEntryItemsDataVersion    = 1;              // the data version expected by the app
static NSString * const kSelectedHealthEntryItemsUnitIndexKey   = @"unitIndex";

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

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"BodyFatPercentage"
      label:NSLocalizedString(@"Body Fat Percentage", nil)
      sortValue:10
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage]
      units:[NSArray arrayWithObjects:[HKUnit percentUnit], nil]
      ],

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"BodyMassIndex"
      label:NSLocalizedString(@"Body Mass Index", nil)
      sortValue:20
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex]
      units:[NSArray arrayWithObjects:[HKUnit countUnit], nil]
      ],

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"BodyMass"
      label:NSLocalizedString(@"Weight", nil)
      sortValue:30
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]
      units:[NSArray arrayWithObjects:[HKUnit poundUnit], [HKUnit unitFromString:@"kg"], [HKUnit stoneUnit], nil]
      ],

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"BloodGlucose"
      label:NSLocalizedString(@"Blood Glucose", nil)
      sortValue:40
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose]
      units:[NSArray arrayWithObjects:
             [HKUnit unitFromString:@"mg/dL"],
             [[HKUnit moleUnitWithMetricPrefix:HKMetricPrefixMilli molarMass:HKUnitMolarMassBloodGlucose] unitDividedByUnit:[HKUnit literUnit]],
             nil]
      ],

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"OxygenSaturation"
      label:NSLocalizedString(@"Oxygen Saturation", nil)
      sortValue:50
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation]
      units:[NSArray arrayWithObjects:[HKUnit percentUnit], nil]
      ],
     
     [[DoubleHealthEntryItem alloc]
      initWithIdentifier:@"BloodPressure"
      label:NSLocalizedString(@"Blood Pressure", nil) sortValue:55
      correlationType:[HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure]
      dataLabel1:@"Systolic" dataType1:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic] unit1:[HKUnit millimeterOfMercuryUnit]
      dataLabel2:@"Diastolic" dataType2:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic] unit2:[HKUnit millimeterOfMercuryUnit]
      ],
     
     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"BodyTemperature"
      label:NSLocalizedString(@"Body Temperature", nil)
      sortValue:60
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature]
      units:[NSArray arrayWithObjects:[HKUnit degreeFahrenheitUnit], [HKUnit degreeCelsiusUnit], [HKUnit unitFromString:@"K"], nil]
      ],

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"HeartRate"
      label:NSLocalizedString(@"Heart Rate", nil)
      sortValue:70
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]
      units:[NSArray arrayWithObjects:[HKUnit unitFromString:@"count/min"], nil]
      ],
     
     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"RespiratoryRate"
      label:NSLocalizedString(@"Respiratory Rate", nil)
      sortValue:80
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate]
      units:[NSArray arrayWithObjects:[HKUnit unitFromString:@"count/min"], nil]
      ],

     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"ActiveEnergyBurned"
      label:NSLocalizedString(@"Active Calories", nil)
      sortValue:90
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]
      units:[NSArray arrayWithObjects:[HKUnit kilocalorieUnit], [HKUnit unitFromString:@"kJ"], nil]
      ],
     
     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"DistanceCycling"
      label:NSLocalizedString(@"Cycling Distance", nil)
      sortValue:100
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling]
      units:[NSArray arrayWithObjects:[HKUnit mileUnit], [HKUnit unitFromString:@"km"], nil]
      ],
     
     [[SimpleHealthEntryItem alloc]
      initWithIdentifier:@"DistanceWalkingRunning"
      label:NSLocalizedString(@"Walk/Run Distance", nil)
      sortValue:110
      dataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]
      units:[NSArray arrayWithObjects:[HKUnit mileUnit], [HKUnit unitFromString:@"km"], nil]
      ],

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
  // upgrade as necessary
  [self upgradeStoredSelectedItems];
  
  // load selected items from storage
  _selectedItems = [self loadSelectedItems];
  
  // ensure selected items array always starts out properly sorted!
  [self sortSelectedItems];
}

- (void)sortSelectedItems
{
  NSArray *tmparr = [_selectedItems sortedArrayUsingComparator:[HealthEntryItem comparator]];
  _selectedItems = [NSMutableArray arrayWithArray:tmparr];
}

- (NSUInteger)countOfSelectedItems
{
  return _selectedItems.count;
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

- (BOOL)isItemSelected:(HealthEntryItem *)item {
  if(!_selectedItems) { return NO; }
  return [_selectedItems containsObject:item];
}

- (NSArray *)getSelectedItemsWithValidInput
{
  NSPredicate *prd = [NSPredicate predicateWithFormat:@"isInputValid == YES"];
  return [_selectedItems filteredArrayUsingPredicate:prd];
}

/**
 * Loads previously saved item selections.
 * @return A new selected items array; empty if there were no previously saved item selections.
 */
- (NSMutableArray *)loadSelectedItems
{
  // create selected items array
  NSMutableArray *selitmarr = [[NSMutableArray alloc] init];

  // load dictionary of selected items (may be nil)
  // see the upgradeStoredSelectedItems method for details about dictionary contents
  NSUserDefaults *usrdft = [NSUserDefaults standardUserDefaults];
  NSDictionary *itmidsdct = [usrdft objectForKey:kSelectedHealthEntryItems];
  
  // no dictionary set means nothing selected!
  if(!itmidsdct) { return selitmarr; }
    
  // do not continue if data version is unexpected
  NSNumber *dtaver = [itmidsdct objectForKey:kSelectedHealthEntryItemsVersionKey];
  if(dtaver.integerValue!=kSelectedHealthEntryItemsDataVersion) { return selitmarr; }

  // iterate through dictionary
  for(NSString* key in itmidsdct)
  {
    // ignore the version key
    if([key isEqualToString:kSelectedHealthEntryItemsVersionKey]) { continue; }

    // key is now item identifier string, value is dictionary of key/value pairs for this selected item
    NSDictionary *val = [itmidsdct objectForKey:key];
    
    // key is present, so select item;
    // find corresponding item in supported items array
    for(HealthEntryItem *itm in _supportedItems)
    {
      // ignore non-matches
      if(![key isEqualToString:itm.uniqueIdentifier]) { continue; }
      
      // a match was found! add it to the selected items array
      [selitmarr addObject:itm];
      
      // if item is SimpleHealthEntryItem, check if selected unit was also saved
      if([itm isMemberOfClass:[SimpleHealthEntryItem class]]) {
        NSNumber *untidx = [val objectForKey:kSelectedHealthEntryItemsUnitIndexKey];
        if(untidx) {
          ((SimpleHealthEntryItem *)itm).selectedDataUnitIndex = untidx.integerValue;
          /**/NSLog(@"applied selected unit index [%i] to item [%@]",untidx.integerValue,itm.label);
        }
      }
      
      break; // stop loop now that match was found
    }
  }
  return selitmarr;
}

/**
 * Saves all current item selections.
 */
- (void)saveSelectedItems
{
  // create array of selected item identifier strings
  NSMutableArray *itmidsarr = [[NSMutableArray alloc] init];
  for(NSUInteger xa=0; xa<_selectedItems.count; xa++) {
    HealthEntryItem *itm = ((HealthEntryItem *)[_selectedItems objectAtIndex:xa]);
    [itmidsarr addObject:itm.uniqueIdentifier];
  }
  
  // save to user defaults
  NSUserDefaults *usrdft = [NSUserDefaults standardUserDefaults];
  [usrdft setObject:itmidsarr forKey:kSelectedHealthEntryItems];
  [usrdft synchronize];
}

/**
 * Upgrades stored selected item data to the latest version.
 * If no stored data is found, then nothing happens.
 */
- (void)upgradeStoredSelectedItems
{
  // load current object version
  NSUserDefaults *usrdft = [NSUserDefaults standardUserDefaults];
  id selitmobj = [usrdft objectForKey:kSelectedHealthEntryItems];
  
  // if object is nil, it has never been set before, so no upgrade needed
  if(!selitmobj) { return; }
  
  // start upgrade process: each step upgrades selitmobj to the next version
  
  // v0 -> v1: upgrade NSArray to NSDictionary and add version property
  if([selitmobj isKindOfClass:[NSArray class]])
  {
    NSLog(@"performing v0 -> v1 upgrade for %@...",kSelectedHealthEntryItems);
    
    // get array reference
    NSArray *itmidsarr = selitmobj;
    
    // create empty new dictionary with version key
    NSMutableDictionary *itmidsdct = [[NSMutableDictionary alloc] initWithCapacity:itmidsarr.count+1];
    [itmidsdct setObject:[NSNumber numberWithInt:1] forKey:kSelectedHealthEntryItemsVersionKey];
    
    // populate dictionary from array
    for(NSString *itmidfstr in itmidsarr) { [itmidsdct setObject:[NSDictionary dictionary] forKey:itmidfstr]; }
    
    // update current object pointer
    selitmobj = itmidsdct;
    NSLog(@"done!");
  }
  
  // output final version number of selected items
  NSNumber *dtaver = [(NSDictionary *)selitmobj objectForKey:kSelectedHealthEntryItemsVersionKey];
  NSLog(@"selected items data version is (%@)",dtaver);
  /**/NSLog(@"selected items data: %@",selitmobj);
  assert(dtaver.integerValue==kSelectedHealthEntryItemsDataVersion); // after all upgrades, version of data must match version expected by app
  
  // save upgraded version of selitmobj in user defaults
  [usrdft setObject:selitmobj forKey:kSelectedHealthEntryItems];
  [usrdft synchronize];
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
    // merge in all data types for this item
    NSSet * itmdtatypset = [((HealthEntryItem *)[healthEntryItems objectAtIndex:xa]) dataTypes];
    [set unionSet:itmdtatypset];
  }
  
  // return set
  return set;
}

@end
