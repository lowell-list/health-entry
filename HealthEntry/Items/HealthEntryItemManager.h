//
//  HealthEntryItemManager.h
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthEntryItem.h"

@interface HealthEntryItemManager : NSObject

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

/// An NSArray of all HealthEntryItems supported by this app.
@property (readonly) NSArray * supportedItems;

/// An NSArray of all HealthEntryItems selected for data entry.
@property (readonly) NSArray * selectedItems;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/**
 * Selects the given item for data entry.
 */
- (void)selectItem:(HealthEntryItem *)item;

/**
 * Unselects the given item for data entry.
 */
- (void)unselectItem:(HealthEntryItem *)item;

/**
 * @return YES if the item is selected, NO otherwise.
 */
- (BOOL)isItemSelected:(HealthEntryItem *)item;

/**
 * @return All selected items with valid user input text.
 */
- (NSArray *)getSelectedItemsWithValidInput;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

/**
 * @return The singleton instance.
 */
+ (HealthEntryItemManager *)instance;

/**
 * Given a NSArray of HealthEntryItems, returns a NSSet of HKSampleType objects
 */
+ (NSSet *)getDataTypesSetFromItems:(NSArray *)healthEntryItems;

@end
