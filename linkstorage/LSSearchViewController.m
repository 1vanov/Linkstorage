//
//  LSSearchViewController.m
//  Linkstorage
//
//  Created by Ilya on 29.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSSearchViewController.h"
#import "LSSearchTableViewCell.h"
#import "AppDelegate.h"
#import "SDK.h"
#import "LSAttributedLabel.h"


@interface LSSearchViewController ()

@property (nonatomic) NSInteger sectionsCount;
@property (nonatomic) NSInteger rowsCount;
@property (nonatomic) BOOL isInited;
@property (nonatomic) BOOL isDataLoading;

@end

@implementation LSSearchViewController


#pragma mark - View -------------------

- (void)viewDidLoad {
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setTintColor:[UIColor whiteColor]];
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [searchBar setPlaceholder:@"Поиск.."];
    [searchBar setImage:[UIImage imageNamed:@"search_white"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Поиск.." attributes:@{NSForegroundColorAttributeName: color}]];
    }
    self.navigationItem.titleView = searchBar;
    
    [self reloadView:YES reloadData:NO];
    
    // Add pull-to-refresh feature to CollectionView
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Start loading indicator
    [self.loadIndicator startAnimating];
    [self.loadIndicator.superview.layer setCornerRadius:4];
    
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
        self.searchType = [self.typeSwitcher selectedSegmentIndex];
        self.searchData = [[SDK sharedInstance] getSearchData:@"" type:self.searchType from:0 upd:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // Reload CollectionView with fetched data
            self.sectionsCount = 1;
            self.rowsCount = [[self.searchData objectForKey:@"items"] count];
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
    // Set needed self.searchType
    // Make TableView empty and invisible
    // Start load indicator

    self.sectionsCount = 0;
    self.rowsCount = 0;
    [self.tableView setAlpha:0.0f];
    [self.loadIndicator startAnimating];
    
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
        self.searchData = [[SDK sharedInstance] getSearchData:@"" type:self.searchType from:0 upd:YES];
        self.rowsCount = [[self.searchData objectForKey:@"items"] count];
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
        if (![self.searchData objectForKey:@"start_from"]) return;
        NSInteger from = [[self.searchData objectForKey:@"start_from"] integerValue];
        
        NSMutableDictionary *searchData = [NSMutableDictionary dictionaryWithDictionary:self.searchData]; // Current wall data
        NSDictionary *newData = [[SDK sharedInstance] getSearchData:@"" type:self.searchType from:from upd:YES]; // New wall data
        
        // To old items adding new
        NSArray *old_items = [self.searchData objectForKey:@"items"];
        NSArray *new_items = [newData objectForKey:@"items"];
        NSMutableArray *items = [NSMutableArray array];
        [items addObjectsFromArray:old_items];
        [items addObjectsFromArray:new_items];
        
        [searchData setObject:items forKey:@"items"];
        
        if ([newData objectForKey:@"start_from"]) {
            [searchData setObject:[newData objectForKey:@"start_from"] forKey:@"start_from"];
        } else {
            [searchData removeObjectForKey:@"start_from"];
        }
        
        self.searchData = [NSDictionary dictionaryWithDictionary:searchData];
        
        self.rowsCount += [new_items count];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
            
            if (![self.searchData objectForKey:@"start_from"]) return;
            
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
    LSSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    NSDictionary *searchData = [[self.searchData objectForKey:@"items"] objectAtIndex:indexPath.row];
    
    cell = [cell initWithData:searchData]; // Create my custom Cell
    return cell;

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *searchData = [[self.searchData objectForKey:@"items"] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ls://profile?%@",[[searchData objectForKey:@"user_id"] stringValue]]];
    LSAttributedLabel *ls = [[LSAttributedLabel alloc] init];
    [ls attributedLabel:nil didSelectLinkWithURL:url];
}


@end
