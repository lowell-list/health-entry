//
//  SelectViewController.h
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

@import UIKit;
@import HealthKit;

@interface SelectViewController : UITableViewController

@property (nonatomic) HKHealthStore *healthStore;

@end
