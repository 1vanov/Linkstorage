//
//  LSProfileCollectionViewCell.h
//  linkstorage
//
//  Created by Ilya on 24.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "LSAttributedLabel.h"

@interface LSProfileCollectionViewCell : UICollectionViewCell <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *urlLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeButtonWidth;

@property (copy, nonatomic) NSDictionary *wallData;

- (id)initWithData:(NSDictionary *)data;

- (IBAction)likePressed:(id)sender;
@end
