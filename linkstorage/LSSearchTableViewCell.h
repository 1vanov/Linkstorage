//
//  LSSearchTableViewCell.h
//  Linkstorage
//
//  Created by Ilya on 29.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineBadge;

- (id)initWithData:(NSDictionary *)data;

@end
