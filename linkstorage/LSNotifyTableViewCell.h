//
//  LSNotifyTableViewCell.h
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "LSAttributedLabel.h"

@interface LSNotifyTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *nameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *actionLabel;

- (id)initWithData:(NSDictionary *)data;

@end
