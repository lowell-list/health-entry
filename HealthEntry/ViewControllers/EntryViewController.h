@import UIKit;
@import HealthKit;

@interface EntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) HKHealthStore *healthStore;

@end
