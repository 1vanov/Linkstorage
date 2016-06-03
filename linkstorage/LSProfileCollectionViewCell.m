//
//  LSPRofileCollectionViewCell.m
//  linkstorage
//
//  Created by Ilya on 24.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSProfileCollectionViewCell.h"
#import "SDK.h"
#import "LSProfileViewController.h"
#import "ProfileData.h"

@implementation LSProfileCollectionViewCell

- (instancetype)initWithData:(NSDictionary *)data {
    
    // Set Label Link styles
    [self.urlLabel setLinkAttributes:@{ (id)kCTForegroundColorAttributeName: self.urlLabel.textColor}];
    
    // Set Text to Lables
    self.urlLabel.text = [[data objectForKey:@"url"] objectForKey:@"original"];
    self.textView.text = [data objectForKey:@"text"];
    self.titleLabel.text = [data objectForKey:@"title"];
    self.timeLabel.text = [[data objectForKey:@"date"] objectForKey:@"ago"];
    
    // Set Links
    [self.urlLabel addLinkToURL:[NSURL URLWithString:self.urlLabel.text] withRange:[self.urlLabel.text rangeOfString:self.urlLabel.text]];
    self.urlLabel.delegate = self;
    
    [self.textView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
    
    // If there are no Title or Text
    self.titleLabelTop.constant = 5;
    self.textViewTop.constant = 4;
    self.titleLabelHeight.constant = 21;
    self.textViewHeight.constant = 87;
    if ([self.titleLabel.text isEqualToString:@""]) {
        self.titleLabelHeight.constant = 0;
        self.titleLabelTop.constant = 0;
        self.textViewTop.constant = 5;
    }
    if ([self.textView.text isEqualToString:@""]) {
        self.textViewHeight.constant = 0;
        self.textViewTop.constant = 0;
    } else {
        CGFloat textSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX)].height;
        textSize = textSize>87 ? 87 : textSize-14;
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
    ProfileData *data = [ProfileData sharedInstance];
    NSDictionary *post = [[data.wallData objectForKey:@"items"] objectAtIndex:row];
    
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

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    LSAttributedLabel *ls = [[LSAttributedLabel alloc] init];
    [ls attributedLabel:label didSelectLinkWithURL:url];
}

@end
