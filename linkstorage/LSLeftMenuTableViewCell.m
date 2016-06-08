//
//  LSLeftMenuTableViewCell.m
//  Linkstorage
//
//  Created by Ilya on 25.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSLeftMenuTableViewCell.h"

@implementation LSLeftMenuTableViewCell

- (id)initWithData:(NSArray *)data {
    self.label.text = [data objectAtIndex:0];
    self.imageView.image = [UIImage imageNamed:[data objectAtIndex:1]];
    self.rightDetail.text = [data objectAtIndex:2];
    
    if ([self.label.text isEqualToString:@"Уведомления"] && [[data objectAtIndex:2] integerValue]) {
        self.rightDetail.backgroundColor = [UIColor colorWithRed:0.22 green:0.23 blue:0.24 alpha:1.0];
        self.rightDetail.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
        self.rightDetail.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        self.rightDetail.layer.cornerRadius = 12.0f;
        self.rightDetail.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)prepareForReuse {
    self.rightDetail.backgroundColor = [UIColor clearColor];
    self.rightDetail.textColor = [UIColor lightGrayColor];
    self.rightDetail.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
    self.rightDetail.layer.cornerRadius = 0;
    self.rightDetail.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
