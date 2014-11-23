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

- (id)initWithDataType:(HKSampleType *)dataType label:(NSString *)label {
  self = [super init];
  if(self) {
    _dataType = dataType;
    _entryCellReuseId = @"entrySingleValueCell"; // TODO: this could be customized per item
    _label = label;
  }
  return self;
}

- (void)dealloc
{
}

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

- (NSString *)description
{
  return [NSString stringWithFormat:@"Label: %@; Data Type: %@; Cell ID: %@", _label, _dataType, _entryCellReuseId];
}
/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
