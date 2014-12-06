//
//  CorrelationHealthEntryItem.h
//  HealthEntry
//
//  Created by Lowell List on 11/28/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "HealthEntryItem.h"

/**
 * An item with two data points and types.
 */
@interface DoubleHealthEntryItem : HealthEntryItem <UITextFieldDelegate>

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/
{
@protected
}

/// correlation type
@property (readonly) HKCorrelationType * correlationType;

/// data label 1
@property (readonly) NSString * dataLabel1;

/// quantity data type 1
@property (readonly) HKQuantityType * dataType1;

/// unit that describes data 1
@property (readonly) HKUnit * dataUnit1;

/// The quantity string that the user entered for data item 1
@property (readonly,copy) NSString * userInput1;

/// data label 2
@property (readonly) NSString * dataLabel2;

/// quantity data type 2
@property (readonly) HKQuantityType * dataType2;

/// unit that describes data 2
@property (readonly) HKUnit * dataUnit2;

/// The quantity string that the user entered for data item 2
@property (readonly,copy) NSString * userInput2;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/// initialize
- (id)initWithIdentifier:(NSString *)identifier label:(NSString *)label sortValue:(NSInteger)sortValue
         correlationType:(HKCorrelationType *)correlationType
              dataLabel1:(NSString *)dataLabel1 dataType1:(HKQuantityType *)dataType1 unit1:(HKUnit *)unit1
              dataLabel2:(NSString *)dataLabel2 dataType2:(HKQuantityType *)dataType2 unit2:(HKUnit *)unit2;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
