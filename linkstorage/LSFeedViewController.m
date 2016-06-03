//
//  LSFeedViewController.m
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSFeedViewController.h"
#import "LSFeedCollectionViewCell.h"
#import "SDK.h"
#import "LSPostViewController.h"
#import "FeedData.h"
#import "AppDelegate.h"

@interface LSFeedViewController ()

@property (nonatomic) FeedData *feedData;
@property (nonatomic) NSInteger rowsCount;
@property (nonatomic) BOOL isInited;
@property (nonatomic) BOOL isMe;
@property (nonatomic) BOOL isDataLoading;

@end

@implementation LSFeedViewController


#pragma mark - View -
- (void)viewDidLoad {
    [self setNeedsStatusBarAppearanceUpdate];
    self.feedData = [FeedData sharedInstance];
    
    [self reloadView:YES reloadData:NO];
    
    // Add pull-to-refresh feature to CollectionView
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    // Start loading indicator
    [self.loadIndicator startAnimating];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isInited) [self reloadView:YES reloadData:YES];
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Fetch neccessary data from API
        self.feedData.data = [[SDK sharedInstance] getFeedFrom:0 upd:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            // Reload CollectionView with fetched data
            self.rowsCount = [[self.feedData.data objectForKey:@"items"] count];
            self.collectionView.alpha = 1;
            [self.collectionView reloadData];
            
            // Stop loading indicator
            [self.loadIndicator stopAnimating];
            
            self.isInited = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}


#pragma mark - View Utility -

- (void)reloadView:(BOOL)_q reloadData:(BOOL)upd {
    
    if (!self.isInited) {
        self.rowsCount = 0;
        [self.collectionView setAlpha:0.0f];
        [self.loadIndicator startAnimating];
    }
    
    if (upd) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.collectionView reloadData];
            });
        });
    }
}

- (void)startRefresh:(UIRefreshControl *)refreshControl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.feedData.data = [[SDK sharedInstance] getFeedFrom:0 upd:YES];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.rowsCount = [[self.feedData.data objectForKey:@"items"] count];
            [self.collectionView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [refreshControl endRefreshing];
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    CGFloat deltaOffset = maximumOffset - currentOffset;
    
    if (deltaOffset < 50 && !self.isDataLoading) {
        [self loadMorePosts];
    }
}

- (void)loadMorePosts {
    self.isDataLoading = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self.feedData.data objectForKey:@"start_from"]) return;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSInteger from = [[self.feedData.data objectForKey:@"start_from"] integerValue];
        
        NSDictionary *newData = [[SDK sharedInstance] getFeedFrom:from upd:YES]; // New feed data
        
        // combine old data with new
        [self.feedData combineFeedDataWith:newData];
        
        self.rowsCount += [[newData objectForKey:@"items"] count];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.collectionView reloadData];
            
            if (![self.feedData.data objectForKey:@"start_from"]) return;
            
            self.isDataLoading = NO;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView performBatchUpdates:nil completion:nil];
}



#pragma mark - UICollectionView -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rowsCount;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedPost" forIndexPath:indexPath];
    NSDictionary *postData = [[self.feedData.data objectForKey:@"items"] objectAtIndex:indexPath.row];
    cell = [cell initWithData:postData];
    cell.tag = indexPath.row;
    
    return cell;
}

// Sizes of cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 247.0f;
    NSDictionary *postData = [[self.feedData.data objectForKey:@"items"] objectAtIndex:indexPath.row];
    
    if ([[postData objectForKey:@"title"] isEqualToString:@""]) h -= 21+3; // Title 24 & TextTop 3
    if ([[postData objectForKey:@"text"] isEqualToString:@""]) {
        h -= 120+3; // Text 120 & TextTop 3
    } else {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, w-14-8, CGFLOAT_MAX)];
        [textView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        [textView setScrollEnabled:NO];
        [textView setShowsHorizontalScrollIndicator:NO];
        [textView setShowsVerticalScrollIndicator:NO];
        [textView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
        textView.text = [postData objectForKey:@"text"];
        [textView sizeToFit];
        CGFloat textSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height;
        textSize = textSize>120 ? 120 : textSize-14;
        h -= 120-textSize;
    }
    if ([[postData objectForKey:@"title"] isEqualToString:@""] && [[postData objectForKey:@"text"] isEqualToString:@""]) h -= 2;
    
    return CGSizeMake(w, h);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LSPostViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PostView"];
    vc.postData = [[self.feedData.data objectForKey:@"items"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SlideNavigationController Methods -
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (IBAction)slideLeftMenu:(id)sender {
   [((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}
@end
