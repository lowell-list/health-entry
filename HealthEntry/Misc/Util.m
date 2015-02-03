//
//  Util.m
//  HealthEntry
//
//  Created by Lowell List on 2/3/15.
//  Copyright (c) 2015 Lowell List Software LLC. All rights reserved.
//

#import "Util.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@implementation Util

/**************************************************************************/
#pragma mark INSTANCE INIT / DEALLOC
/**************************************************************************/

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

+ (NSInteger)clampNSInteger:(NSInteger)value max:(NSInteger)max min:(NSInteger)min
{
  if(value<min) { return min; }
  if(value>max) { return max; }
  return value;
}

+ (double)clampDouble:(double)value max:(double)max min:(double)min
{
  if(value<min) { return min; }
  if(value>max) { return max; }
  return value;
}

@end
