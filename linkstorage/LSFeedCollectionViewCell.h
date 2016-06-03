//
//  LSFeedCollectionViewCell.h
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "LSAttributedLabel.h"

@interface LSFeedCollectionViewCell : UICollectionViewCell <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *nameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeButtonWidth;


- (id)initWithData:(NSDictionary *)data;
- (IBAction)likePressed:(id)sender;

@end
