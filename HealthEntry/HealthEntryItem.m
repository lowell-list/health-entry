//
//  HealthEntryItem.m
//  HealthEntry
//
//  Created by Lowell List on 10/18/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "HealthEntryItem.h"

@implementation HealthEntryItem

- (id)initWithDataType:(HKSampleType *)dataType label:(NSString *)label {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _entryCellReuseId = @"singleEntryCell";
        _label = label;
    }
    return self;
}

@end
