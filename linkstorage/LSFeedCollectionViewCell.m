//
//  LSFeedCollectionViewCell.m
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSFeedCollectionViewCell.h"
#import "SDK.h"
#import "FeedData.h"
#import "WebCache/UIImageView+WebCache.h"

@implementation LSFeedCollectionViewCell

- (instancetype)initWithData:(NSDictionary *)data {
    
    NSString *photo = [[data objectForKey:@"user"] objectForKey:@"photo"];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
    self.avatarView.layer.cornerRadius = self.avatarView.bounds.size.width/2;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [self.avatarView setUserInteractionEnabled:YES];
    [self.avatarView addGestureRecognizer:singleTap];
    
    // Set Label Link styles
    [self.nameLabel setLinkAttributes:@{ (id)kCTForegroundColorAttributeName: self.nameLabel.textColor}];
    [self.urlLabel setLinkAttributes:@{ (id)kCTForegroundColorAttributeName: self.nameLabel.textColor}];
    
    // Set Text to Lables
    self.urlLabel.text = [[data objectForKey:@"url"] objectForKey:@"original"];
    self.nameLabel.text = [[data objectForKey:@"user"] objectForKey:@"name"];
    self.textView.text = [data objectForKey:@"text"];
    self.titleLabel.text = [data objectForKey:@"title"];
    self.timeLabel.text = [[data objectForKey:@"date"] objectForKey:@"ago"];
    
    // Set Links
    NSString *url = [NSString stringWithFormat:@"ls://profile?%@",[[data objectForKey:@"user_id"] stringValue]];
    [self.nameLabel addLinkToURL:[NSURL URLWithString:url] withRange:[self.nameLabel.text rangeOfString:self.nameLabel.text]];
    self.nameLabel.delegate = self;
    
    [self.urlLabel addLinkToURL:[NSURL URLWithString:self.urlLabel.text] withRange:[self.urlLabel.text rangeOfString:self.urlLabel.text]];
    self.urlLabel.delegate = self;
    
    [self.textView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
    
    // If there are no Title or Text
    self.titleLabelTop.constant = 7;
    self.textViewTop.constant = 3;
    self.titleLabelHeight.constant = 21;
    self.textViewHeight.constant = 120;
    if ([self.titleLabel.text isEqualToString:@""]) {
        self.titleLabelHeight.constant = 0;
        self.titleLabelTop.constant = 0;
        self.textViewTop.constant = 7;
    }
    if ([self.textView.text isEqualToString:@""]) {
        self.textViewHeight.constant = 0;
        self.textViewTop.constant = 0;
    } else {
        CGFloat textSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX)].height;
        textSize = textSize>120 ? 120 : textSize-14;
        self.textViewHeight.constant = textSize;
    }
    
    // Set Like
    NSString *likes = [[[data objectForKey:@"likes"] objectForKey:@"count"] stringValue];
    likes = [likes isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@",likes];
    CGFloat width = 30+likes.length*10;
    [self.likeButton setTitle:likes forState:UIControlStateNormal];
    self.likeButtonWidth.constant = width;
    if([[[data objectForKey:@"likes"] objectForKey:@"isliked"] integerValue]) {
        [self.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
        [self.likeButton setTag:1];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
        [self.likeButton setTag:0];
    }
    self.likeButton.layer.cornerRadius = 2.0f;
    
    return self;
}

- (IBAction)likePressed:(id)sender {
    UIButton *likeBtn = (UIButton *)sender;
    NSInteger row = [likeBtn.superview.superview tag]; // get cell index
    NSLog(@"%@",likeBtn.superview.superview);
    NSDictionary *post = [[[[FeedData sharedInstance] data] objectForKey:@"items"] objectAtIndex:row];
    
    NSNumber *user_id = [post objectForKey:@"user_id"];
    NSNumber *post_id = [post objectForKey:@"post_id"];
    NSString *hash = [[post objectForKey:@"likes"] objectForKey:@"hash"];
    
    NSDictionary *result = [[SDK sharedInstance] likeToUserId:user_id post_id:post_id hash:hash];
    if ([result objectForKey:@"response"]!=nil) {
        NSString *likes = [[result objectForKey:@"response"] stringValue];
        likes = [likes isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@",likes];
        CGFloat width = 30+likes.length*10;
        [self.likeButton setTitle:likes forState:UIControlStateNormal];
        self.likeButtonWidth.constant = width;
        
        if ([sender tag]) {
            [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [self.likeButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
            [self.likeButton setTag:0];
        } else {
            [self.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
            [self.likeButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
            [self.likeButton setTag:1];
        }
    }
}

- (void)avatarViewPressed:(id)sender {
    NSInteger row = [[[[sender view] superview] superview] tag];
    NSDictionary *post = [[[[FeedData sharedInstance] data] objectForKey:@"items"] objectAtIndex:row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ls://profile?%@",[[post objectForKey:@"user_id"] stringValue]]];
    LSAttributedLabel *ls = [[LSAttributedLabel alloc] init];
    [ls attributedLabel:nil didSelectLinkWithURL:url];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    LSAttributedLabel *ls = [[LSAttributedLabel alloc] init];
    [ls attributedLabel:label didSelectLinkWithURL:url];
}

@end
