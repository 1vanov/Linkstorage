//
//  LSSearchTableViewCell.m
//  Linkstorage
//
//  Created by Ilya on 29.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSSearchTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation LSSearchTableViewCell

- (id)initWithData:(NSDictionary *)data {
    
    NSString *photo = [data objectForKey:@"photo"];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
    if (!self.avatarView.layer.cornerRadius) {
        self.avatarView.layer.cornerRadius = self.avatarView.bounds.size.width/2;
        self.avatarView.clipsToBounds = YES;
    }
    
    if (!self.onlineBadge.layer.cornerRadius){
        [self.onlineBadge.layer setBorderWidth:3.0f];
        [self.onlineBadge.layer setBorderColor:[UIColor whiteColor].CGColor];
        self.onlineBadge.layer.cornerRadius = 5.0f;
    }
    if ([[data objectForKey:@"last_seen"] isEqualToString:@"<div class=\"last_seen\">на сайте</div>"])
        self.onlineBadge.hidden = NO;
    else
        self.onlineBadge.hidden = YES;
    
    self.nameLabel.text = [data objectForKey:@"name"];
    
    [self setTag:[[data objectForKey:@"user_id"] integerValue]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
