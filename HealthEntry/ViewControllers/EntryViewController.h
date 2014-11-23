//
//  EntryViewController.h
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

@import UIKit;
@import HealthKit;

@interface EntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@property (nonatomic) HKHealthStore * healthStore;

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
