//
//  HealthEntryItem.h
//  HealthEntry
//
//  Created by Lowell List on 10/18/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;

@interface HealthEntryItem : NSObject

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@property (readonly) HKSampleType * dataType;

@property (readonly,copy) NSString * entryCellReuseId;

@property (readonly,copy) NSString * label;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

- (id)initWithDataType:(HKSampleType *)dataType label:(NSString *)label;

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
