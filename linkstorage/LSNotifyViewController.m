//
//  LSNotifyViewController.m
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSNotifyViewController.h"
#import "LSNotifyTableViewCell.h"
#import "AppDelegate.h"
#import "SDK.h"
#import "NotifyData.h"
#import "LSPostViewController.h"

@interface LSNotifyViewController ()

@property (nonatomic) NSInteger sectionsCount;
@property (nonatomic) NSInteger rowsCount;
@property (nonatomic) BOOL isInited;
@property (nonatomic) BOOL isDataLoading;
@property (nonatomic) NotifyData *notifyData;

@end

@implementation LSNotifyViewController

- (void)viewDidLoad {
    self.notifyData = [NotifyData sharedInstance];
    
    [self reloadView:YES reloadData:NO];
    
    // Add pull-to-refresh feature to CollectionView
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Start loading indicator
    [self.loadIndicator startAnimating];
    
    // удаление баджа в гамбургер-иконке и в левом меню
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isInited) [self reloadView:YES reloadData:YES];
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Fetch neccessary data from API
        self.notifyData.data = [[SDK sharedInstance] getNotificationsFrom:0 upd:YES];
    
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // Reload CollectionView with fetched data
            self.sectionsCount = 1;
            self.rowsCount = [[self.notifyData.data objectForKey:@"items"] count];
            self.tableView.alpha = 1;
            [self.tableView reloadData];
    
            // Stop loading indicator
            [self.loadIndicator stopAnimating];
    
            self.isInited = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
    [super viewDidAppear:YES];
}


#pragma mark - View Utility -------------------

- (void)reloadView:(BOOL)_q reloadData:(BOOL)upd {
    // Make TableView empty and invisible
    // Start load indicator
    
    if (self.navigationController.tabBarItem.badgeValue || !self.isInited) {
        self.sectionsCount = 0;
        self.rowsCount = 0;
        [self.tableView setAlpha:0.0f];
        [self.loadIndicator startAnimating];
    }

    if (upd) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.tableView reloadData];
            });
        });
    }
}

- (void)startRefresh:(UIRefreshControl *)refreshControl {
    // Pull-to-refresh handler
    NSLog(@"Refreshing..");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.notifyData.data = [[SDK sharedInstance] getNotificationsFrom:0 upd:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.tableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [refreshControl endRefreshing];
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Autoload posts when scroll
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    CGFloat deltaOffset = maximumOffset - currentOffset;
    
    if (deltaOffset < 50 && !self.isDataLoading) {
        [self loadMorePosts];
    }
}

- (void)loadMorePosts {
    // Autoload posts
    self.isDataLoading = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self.notifyData.data objectForKey:@"start_from"]) return;
        NSInteger from = [[self.notifyData.data objectForKey:@"start_from"] integerValue];
        
        NSDictionary *newData = [[SDK sharedInstance] getNotificationsFrom:from upd:YES]; // New notify data
        
        // combine old data with new
        [self.notifyData combineNotifyDataWith:newData];
        
        self.rowsCount += [[newData objectForKey:@"items"] count];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        
            if (![self.notifyData.data objectForKey:@"start_from"]) return;
        
            // Dont call this function 1sec
            int64_t delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.isDataLoading = NO;
            });
        });
    });
}



#pragma mark - Table View DataSource -------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSNotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyCell" forIndexPath:indexPath];
    
    NSDictionary *notifyData = [[self.notifyData.data objectForKey:@"items"] objectAtIndex:indexPath.row];
    
    cell = [cell initWithData:notifyData]; // Create my custom Cell
    [cell setTag:indexPath.row];
    
    return cell;
    
}


@end
