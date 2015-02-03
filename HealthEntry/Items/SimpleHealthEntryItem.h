//
//  SimpleHealthEntryItem.h
//  HealthEntry
//
//  Created by Lowell List on 11/26/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "HealthEntryItem.h"

/**
 * A simple item with one data point and type.
 */
@interface SimpleHealthEntryItem : HealthEntryItem <UITextFieldDelegate>

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

/// quantity data type
@property (readonly) HKQuantityType * dataType;

/// valid units that can describe the data type
@property (readonly) NSArray * dataUnits;

/// The quantity string that the user entered for this item
@property (readonly,copy) NSString * userInput;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/// initializes a SimpleHealthEntryItem
- (id)initWithIdentifier:(NSString *)identifier label:(NSString *)label sortValue:(NSInteger)sortValue
                dataType:(HKQuantityType *)dataType units:(NSArray *)units;

/// sets the currently selected data unit index
- (void)setSelectedDataUnitIndex:(NSInteger)index;

/// gets the currently selected data unit index
- (NSInteger)selectedDataUnitIndex;

/// returns the currently selected data unit
- (HKUnit *)selectedDataUnit;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
