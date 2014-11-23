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
  /**/_selectedItems = _supportedItems;
}

- (void)selectItem:(HealthEntryItem *)item
{
  NSLog(@"item selected");
  // TODO: update _selectedItems and save the array to storage
}

- (void)unselectItem:(HealthEntryItem *)item
{
  NSLog(@"item unselected");
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
