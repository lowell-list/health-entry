//
//  HealthEntryItem.h
//  HealthEntry
//
//  Created by Lowell List on 10/18/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;
@import UIKit;

@interface HealthEntryItem : NSObject
{
@protected
  NSString * _label;
  BOOL _isInputValid;
}

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

/// item description label
@property (readonly,copy) NSString * label;

/// a value for how this item should be sorted
@property (readonly) NSInteger sortValue;

/// identifies the table cell prototype to use for this item.
@property (readonly,copy) NSString * entryCellReuseId;

/// YES if all user input for this item is valid.
@property (readonly) BOOL isInputValid;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/// initializes this item (base class data only)
- (id)initWithLabel:(NSString *)label sortValue:(NSInteger)sortValue entryCellReuseId:(NSString *)entryCellReuseId;

/// initializes a new table cell for this item
- (void)setupTableCell:(UITableViewCell *)cell;

/// refreshes a table cell for this item
- (void)updateTableCell:(UITableViewCell *)cell;

/// Returns a NSSet of all data types written by this item (may be more than one)
- (NSSet *)dataTypes;

/// Saves this item into the given HKHealthStore, then calls the given callback handler, if not nil.
- (void)saveIntoHealthStore:(HKHealthStore *)healthStore onDone:(void(^)(BOOL success))onDone;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

/**
 * @return A NSComparator block to compare two HealthEntryItem objects.
 */
+ (NSComparator)comparator;

@end
