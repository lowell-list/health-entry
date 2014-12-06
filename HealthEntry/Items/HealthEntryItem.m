//
//  HealthEntryItem.m
//  HealthEntry
//
//  Created by Lowell List on 10/18/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "HealthEntryItem.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface HealthEntryItem()

@end

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

@implementation HealthEntryItem

- (id)initWithIdentifier:(NSString *)identifier label:(NSString *)label sortValue:(NSInteger)sortValue entryCellReuseId:(NSString *)entryCellReuseId
{
  self = [super init];
  if(self) {
    _uniqueIdentifier = identifier;
    _label = label;
    _sortValue = sortValue;
    _entryCellReuseId = entryCellReuseId;
    _rowHeight = 44;
    _isInputValid = NO;
  }
  return self;
}

- (void)dealloc
{
}

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

- (NSString *)description {
  return [NSString stringWithFormat:@"[%@]",_label];
}

- (void)setupTableCell:(UITableViewCell *)cell {
  // override in subclass
}

- (void)updateTableCell:(UITableViewCell *)cell {
  // override in subclass
}

- (NSSet *)dataTypes {
  return [NSSet set]; // override in subclass
}

- (void)saveIntoHealthStore:(HKHealthStore *)healthStore entryDate:(NSDate *)entryDate onDone:(void(^)(BOOL success))onDone {
  // override in subclass
}

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

+ (NSComparator)comparator
{
  return ^(HealthEntryItem * itm1, HealthEntryItem * itm2) {
    if(itm1.sortValue > itm2.sortValue) { return NSOrderedDescending; }
    if(itm1.sortValue < itm2.sortValue) { return NSOrderedAscending; }
    return NSOrderedSame;
  };
}

@end
