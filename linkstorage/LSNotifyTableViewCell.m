//
//  LSNotifyTableViewCell.m
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSNotifyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NotifyData.h"
#import "AppDelegate.h"

@implementation LSNotifyTableViewCell

#define BG_FOLLOW [UIColor colorWithRed:0.298 green:0.416 blue:0.671 alpha:1]
#define BG_FAV [UIColor colorWithRed:0.996 green:0.82 blue:0.043 alpha:1]
#define BG_LIKE [UIColor colorWithRed:0.922 green:0.329 blue:0.357 alpha:1]

- (id)initWithData:(NSDictionary *)data {
    NSString *type = [data objectForKey:@"type"];
    
    NSString *photo = [[data objectForKey:@"user"] objectForKey:@"photo"];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
    self.avatarView.layer.cornerRadius = self.avatarView.bounds.size.width/2;
    self.avatarView.clipsToBounds = YES;
    self.badgeView.layer.cornerRadius = self.badgeView.bounds.size.width/2;
    self.badgeView.clipsToBounds = YES;
    self.badgeView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.badgeView.layer.borderWidth = 3.0f;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [self.avatarView setUserInteractionEnabled:YES];
    [self.avatarView addGestureRecognizer:singleTap];
    
    // Set Label Link styles
    [self.nameLabel setLinkAttributes:@{ (id)kCTForegroundColorAttributeName: self.nameLabel.textColor}];
    [self.actionLabel setLinkAttributes:@{ (id)kCTForegroundColorAttributeName: self.actionLabel.tintColor}];
    
    self.nameLabel.text = [[data objectForKey:@"user"] objectForKey:@"name"];
    
    // Set Links
    NSString *url = [NSString stringWithFormat:@"ls://profile?%@",[[[data objectForKey:@"user"] objectForKey:@"id"] stringValue]];
    [self.nameLabel addLinkToURL:[NSURL URLWithString:url] withRange:[self.nameLabel.text rangeOfString:self.nameLabel.text]];
    self.nameLabel.delegate = self;
    
    if ([type isEqualToString:@"follow"]) {
        self.actionLabel.text = @"читает вас";
        self.badgeView.backgroundColor = BG_FOLLOW;
        self.badgeImage.image = [UIImage imageNamed:@"plus_filled"];
    }
    if ([type isEqualToString:@"fav"] || [type isEqualToString:@"like"]) {
        self.actionLabel.text = [NSString stringWithFormat:@"оценил запись %@",[[data objectForKey:@"post"] objectForKey:@"text"]];
        
        NSString *url = [NSString stringWithFormat:@"ls://post?%@",[[data objectForKey:@"post"] objectForKey:@"full"]];
        NSRange r = [self.actionLabel.text rangeOfString:[[data objectForKey:@"post"] objectForKey:@"text"]];
        [self.actionLabel addLinkToURL:[NSURL URLWithString:url] withRange:r];
        self.actionLabel.delegate = self;
        
    }
    if ([type isEqualToString:@"fav"]) {
        self.badgeView.backgroundColor = BG_FAV;
        self.badgeImage.image = [UIImage imageNamed:@"star_filled"];
    }
    if ([type isEqualToString:@"like"]) {
        self.badgeView.backgroundColor = BG_LIKE;
        self.badgeImage.image = [UIImage imageNamed:@"like_filled"];
    }
    
    if (![[data objectForKey:@"viewed"] integerValue]) {
        self.backgroundColor = [UIColor colorWithRed:1 green:0.953 blue:0.914 alpha:1];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)avatarViewPressed:(id)sender {
    NSInteger row = [[[[sender view] superview] superview] tag];
    NSDictionary *post = [[[[NotifyData sharedInstance] data] objectForKey:@"items"] objectAtIndex:row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ls://profile?%@",[[[post objectForKey:@"user"] objectForKey:@"id"] stringValue]]];
    LSAttributedLabel *ls = [[LSAttributedLabel alloc] init];
    [ls attributedLabel:nil didSelectLinkWithURL:url];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    LSAttributedLabel *ls = [[LSAttributedLabel alloc] init];
    [ls attributedLabel:label didSelectLinkWithURL:url];
}

@end
