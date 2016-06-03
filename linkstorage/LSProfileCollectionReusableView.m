//
//  LSProfileCollectionReusableView.m
//  linkstorage
//
//  Created by Ilya on 24.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSProfileCollectionReusableView.h"
#import "UIImageView+WebCache.h"
#import "ProfileData.h"
#import "SDK.h"


@implementation LSProfileCollectionReusableView

- (instancetype)init {
    ProfileData *profileData = [ProfileData sharedInstance];
    NSDictionary *data = profileData.userData;
    
    // Profile Lables
    self.nameLabel.text = [data objectForKey:@"name"];
    self.statusLabel.text = [data objectForKey:@"status"];
    self.followersLabel.text = [data objectForKey:@"followers"];
    self.followingLabel.text = [data objectForKey:@"following"];
    self.postsLabel.text = [[profileData.wallData objectForKey:@"count"] stringValue];
    
    // Profile Cover
    NSString *cover = [data objectForKey:@"cover"];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:cover] placeholderImage:nil];
    self.coverView.backgroundColor = [UIColor blackColor];
    // Add Blur If Needed
    if ([self.coverView.subviews count]==0) {
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView  alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        visualEffectView.frame = self.coverView.bounds;
        [self.coverView addSubview:visualEffectView];
        // set constraints
        visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.coverView addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
        [self.coverView addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
        [self.coverView addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
        [self.coverView addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.coverView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    }
    
    // Profile Photo
    NSString *photo = [data objectForKey:@"photo"];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
    self.avatarView.layer.cornerRadius = 3.0f;
    self.avatarView.clipsToBounds = YES;
    self.avatarView.superview.layer.cornerRadius = 3.0f;
    
    // Subscribe/AddPost Button
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] integerValue]==[[data objectForKey:@"id"] integerValue]) {
        self.subscribeButton.hidden = YES;
        self.addLinkButton.hidden = NO;
    } else {
        self.subscribeButton.hidden = NO;
        self.addLinkButton.hidden = YES;
        
        [UIView performWithoutAnimation:^{
            if ([[data objectForKey:@"is_follow"] integerValue]) {
                [self.subscribeButton setTitle:@"Отписаться" forState:UIControlStateNormal];
            } else {
                [self.subscribeButton setTitle:@"Подписаться" forState:UIControlStateNormal];
            }
            [self.subscribeButton layoutIfNeeded];
        }];
    }

    return self;
}

- (IBAction)follow:(id)sender {
    ProfileData *profileData = [ProfileData sharedInstance];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSDictionary *result = [[SDK sharedInstance] followToUserId:[profileData.userData objectForKey:@"id"] hash:[profileData.userData objectForKey:@"follow_hash"]];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if ([result objectForKey:@"response"]!=nil) {
                UIButton *btn = (UIButton *)sender;
                [self.followingLabel setText:[[result objectForKey:@"response"] stringValue]];
                
                if ([btn.titleLabel.text isEqualToString:@"Подписаться"]) {
                    [btn setTitle:@"Отписаться" forState:UIControlStateNormal];
                } else {
                    [btn setTitle:@"Подписаться" forState:UIControlStateNormal];
                }
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
}

@end
