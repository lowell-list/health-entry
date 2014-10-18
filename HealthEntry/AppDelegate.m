#import "AppDelegate.h"
#import "SelectViewController.h"
#import "EntryViewController.h"
@import HealthKit;

@interface AppDelegate()

@property (nonatomic) HKHealthStore *healthStore;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.healthStore = [[HKHealthStore alloc] init];

    [self setUpHealthStoreForTabBarControllers];

    return YES;
}

#pragma mark - Convenience

- (void)setUpHealthStoreForTabBarControllers
{
    UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];

    for (UINavigationController *navigationController in tabBarController.viewControllers) {
        id viewController = navigationController.topViewController;
        
        if ([viewController respondsToSelector:@selector(setHealthStore:)]) {
            [viewController setHealthStore:self.healthStore];
        }
    }
}

@end
