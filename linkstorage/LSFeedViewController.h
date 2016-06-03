//
//  LSFeedViewController.h
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSFeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;


- (IBAction)slideLeftMenu:(id)sender;

@end
