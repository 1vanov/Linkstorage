//
//  ViewController.m
//  linkstorage
//
//  Created by Ilya on 24.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSProfileViewController.h"
#import "LSProfileCollectionViewCell.h"
#import "LSProfileCollectionReusableView.h"
#import "SDK.h"
#import "AppDelegate.h"
#import "LSPostViewController.h"
#import "ProfileData.h"

@interface LSProfileViewController ()

@property (nonatomic) NSInteger sectionsCount;
@property (nonatomic) NSInteger rowsCount;
@property (nonatomic) BOOL isInited;
@property (nonatomic) BOOL isMe;
@property (nonatomic) BOOL isDataLoading;
@property (nonatomic) ProfileData *profileData;

@end

@implementation LSProfileViewController


#pragma mark - View -

- (void)viewDidLoad {
    self.profileData = [ProfileData sharedInstance];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isInited) [self reloadView:YES reloadData:YES];
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Fetch neccessary data from API
        self.profileData.wallData = [[SDK sharedInstance] getWallDataForId:self.profileData.userId from:0 upd:YES];
        self.profileData.userData = [[SDK sharedInstance] getUserDataForId:self.profileData.userId upd:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // Save add post hash
            [[NSUserDefaults standardUserDefaults] setObject:[self.profileData.userData objectForKey:@"post_hash"] forKey:@"addpost_hash"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // Reload CollectionView with fetched data
            self.sectionsCount = 1;
            self.rowsCount = [[self.profileData.wallData objectForKey:@"items"] count];
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
    self.profileData.userId = self.userId ? self.userId : ((AppDelegate *)[[UIApplication sharedApplication] delegate]).userId;
    
    if (!self.isInited) {
        self.sectionsCount = 0;
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
        self.profileData.wallData = [[SDK sharedInstance] getWallDataForId:self.profileData.userId from:0 upd:YES];
        self.profileData.userData = [[SDK sharedInstance] getUserDataForId:self.profileData.userId upd:YES];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.rowsCount = [[self.profileData.wallData objectForKey:@"items"] count];
            [self.collectionView reloadData];
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
    self.isDataLoading = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![self.profileData.wallData objectForKey:@"start_from"]) return;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSInteger from = [[self.profileData.wallData objectForKey:@"start_from"] integerValue];
        
        NSDictionary *newData = [[SDK sharedInstance] getWallDataForId:self.profileData.userId from:from upd:YES]; // New wall data
        
        // combine old data with new
        [self.profileData combineWallDataWith:newData];
        
        self.rowsCount += [[newData objectForKey:@"items"] count];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.collectionView reloadData];
        
            if (![self.profileData.wallData objectForKey:@"start_from"]) return;
        
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
    return self.sectionsCount;
}

// Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) { // Header
        LSProfileCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeader" forIndexPath:indexPath];
        headerView = [headerView init]; // Create my custom Header
       
        reusableview = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) { } // Footer
    
    return reusableview;
}

// Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePost" forIndexPath:indexPath];
    NSDictionary *postData = [[self.profileData.wallData objectForKey:@"items"] objectAtIndex:indexPath.row];
    cell = [cell initWithData:postData];
    cell.tag = indexPath.row;
    
    return cell;
}

// Sizes of cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 190.0f;
    NSDictionary *postData = [[self.profileData.wallData objectForKey:@"items"] objectAtIndex:indexPath.row];
    if ([[postData objectForKey:@"title"] isEqualToString:@""]) h -= 21+4; // 4 - text top
    if ([[postData objectForKey:@"text"] isEqualToString:@""]) {
        h -= 87+4; // 4 - text top
    } else {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, w-8-8, CGFLOAT_MAX)];
        [textView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        [textView setScrollEnabled:NO];
        [textView setShowsHorizontalScrollIndicator:NO];
        [textView setShowsVerticalScrollIndicator:NO];
        [textView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
        textView.text = [postData objectForKey:@"text"];
        [textView sizeToFit];
        CGFloat textSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height;
        textSize = textSize>87 ? 87 : textSize-14;
        h -= 87-textSize;
    }
    if ([[postData objectForKey:@"title"] isEqualToString:@""] && [[postData objectForKey:@"text"] isEqualToString:@""]) h -= 1;

    return CGSizeMake(w, h);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LSPostViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PostView"];
    vc.postData = [[self.profileData.wallData objectForKey:@"items"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
