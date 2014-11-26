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

- (id)initWithDataType:(HKSampleType *)dataType unit:(HKUnit *)unit label:(NSString *)label sortValue:(NSInteger)sortValue {
  self = [super init];
  if(self) {
    _dataType = dataType;
    _dataUnit = unit;
    _entryCellReuseId = @"entrySingleValueCell"; // TODO: this could be customized per item
    _label = label;
    _sortValue = sortValue;
    _userInput = @"";
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
  return [NSString stringWithFormat:@"label: %@; userInput: %@", _label, _userInput];
}

- (void)textFieldEditingDidEnd:(UITextField *)textField
{
  _userInput = textField.text;
  /**/NSLog(@"set userInput text to [%@] for item [%@]",_userInput,_label);
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
