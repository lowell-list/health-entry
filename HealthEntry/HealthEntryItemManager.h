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

/**
 * An NSArray of all HealthEntryItems supported by this app.
 */
@property (readonly) NSArray * supportedItems;

/**
 * An NSArray of all HealthEntryItems selected for data entry.
 */
@property (readonly) NSArray * selectedItems;

/**
 * Returns the singleton instance.
 */
+ (HealthEntryItemManager *)instance;

/**
 * Selects the given item for data entry.
 */
- (void)selectItem:(HealthEntryItem *)item;

/**
 * Unselects the given item for data entry.
 */
- (void)unselectItem:(HealthEntryItem *)item;

@end
