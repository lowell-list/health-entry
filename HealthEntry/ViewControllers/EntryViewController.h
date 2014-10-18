@import UIKit;
@import HealthKit;

@interface EntryViewController : UIViewController <UITableViewDelegate>

@property (nonatomic) HKHealthStore *healthStore;

@end
