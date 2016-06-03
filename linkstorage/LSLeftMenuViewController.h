//
//  LSLeftMenuViewController.h
//  Linkstorage
//
//  Created by Ilya on 25.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)closeLeftMenu:(id)sender;
@end
