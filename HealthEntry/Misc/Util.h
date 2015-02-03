//
//  Util.h
//  HealthEntry
//
//  Created by Lowell List on 2/3/15.
//  Copyright (c) 2015 Lowell List Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/
{
@protected
}

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

+ (NSInteger)clampNSInteger:(NSInteger)value max:(NSInteger)max min:(NSInteger)min;
+ (double)clampDouble:(double)value max:(double)max min:(double)min;

@end
