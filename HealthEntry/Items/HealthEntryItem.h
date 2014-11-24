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

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@property (readonly) HKSampleType * dataType;

@property (readonly,copy) NSString * entryCellReuseId;

@property (readonly,copy) NSString * label;

/// The string that the user entered for this item
@property (readonly,copy) NSString * userInput;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

- (id)initWithDataType:(HKSampleType *)dataType label:(NSString *)label;

- (void)textFieldEditingDidEnd:(UITextField *)textField;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
