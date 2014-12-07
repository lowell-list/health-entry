//
//  AppDelegate.m
//  HealthEntry
//
//  Created by Lowell List on 11/21/14.
//  Copyright (c) 2014 Lowell List Software LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "SelectViewController.h"
#import "EntryViewController.h"
@import HealthKit;
#import "HealthEntryItemManager.h"

/**************************************************************************/
#pragma mark INSTANCE PROPERTIES
/**************************************************************************/

@interface AppDelegate()

@property (nonatomic) HKHealthStore *healthStore;

@end

/**************************************************************************/
#pragma mark INSTANCE METHODS
/**************************************************************************/

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.healthStore = [[HKHealthStore alloc] init];
  
  [self setUpHealthStoreForTabBarControllers];
  [self setInitialTabIndex];
  
  return YES;
}

- (void)setUpHealthStoreForTabBarControllers
{
  UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];
  
  for(UINavigationController *navigationController in tabBarController.viewControllers) {
    id viewController = navigationController.topViewController;
    
    if ([viewController respondsToSelector:@selector(setHealthStore:)]) {
      [viewController setHealthStore:self.healthStore];
    }
  }
}

- (void)setInitialTabIndex
{
  // show Selection Screen if no items are selected, otherwise show Entry Screen
  UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];
  tabBarController.selectedIndex = ([[HealthEntryItemManager instance] countOfSelectedItems]<=0) ? 0 : 1;
}

/**************************************************************************/
#pragma mark CLASS METHODS
/**************************************************************************/

@end
