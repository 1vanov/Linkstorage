//
//  LSSearchViewController.h
//  Linkstorage
//
//  Created by Ilya on 29.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSDictionary *searchData;
@property (nonatomic) NSInteger searchType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSwitcher;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
