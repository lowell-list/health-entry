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

/// selected unit
@property (readonly) HKUnit * selectedDataUnit;

/// The quantity string that the user entered for this item
@property (readonly,copy) NSString * userInput;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/// initializes a SimpleHealthEntryItem
- (id)initWithIdentifier:(NSString *)identifier label:(NSString *)label sortValue:(NSInteger)sortValue
                dataType:(HKQuantityType *)dataType units:(NSArray *)units;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
