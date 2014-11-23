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
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]
      label:NSLocalizedString(@"Energy Burned", nil)],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]
      label:NSLocalizedString(@"Height", nil)],
     
     [[HealthEntryItem alloc]
      initWithDataType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]
      label:NSLocalizedString(@"Weight", nil)],
     
     nil];
  NSLog(@"initialized supported items");
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
}

- (void)sortSelectedItems
{
  NSArray * tmparr = [_selectedItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSString *first = ((HealthEntryItem *)a).label;
    NSString *second = ((HealthEntryItem *)b).label;
    return [first compare:second];
  }];
  _selectedItems = [NSMutableArray arrayWithArray:tmparr];
}

- (void)selectItem:(HealthEntryItem *)item
{
  /**/NSLog(@"item %@ selected",item.label);

  // update selected items
  NSMutableArray * selitmarr = (NSMutableArray *)_selectedItems;
  [selitmarr removeObject:item]; // remove first to ensure no duplicates
  [selitmarr addObject:item];

  // save selected items
  [self saveSelectedItems];
}

- (void)unselectItem:(HealthEntryItem *)item
{
  /**/NSLog(@"item %@ unselected",item.label);

  // update selected items
  NSMutableArray * selitmarr = (NSMutableArray *)_selectedItems;
  [selitmarr removeObject:item];
  
  // save selected items
  [self saveSelectedItems];
}

- (BOOL)isItemSelected:(HealthEntryItem *)item
{
  return NO;
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
#pragma mark CLASS METHODS
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

@end
