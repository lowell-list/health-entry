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
{
}
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
    /**/_selectedItems = _supportedItems; // TODO: read from storage
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

- (void)selectItem:(HealthEntryItem *)item
{
  NSLog(@"item selected");
}

- (void)unselectItem:(HealthEntryItem *)item
{
  NSLog(@"item unselected");
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
