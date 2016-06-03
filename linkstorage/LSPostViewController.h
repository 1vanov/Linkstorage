//
//  LSPostViewController.h
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPostViewController : UIViewController

@property (nonatomic) NSDictionary *postData;
@property (nonatomic) NSString *post;

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UITextView *titleView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;


@end
