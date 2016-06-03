//
//  LSAttributedLabel.m
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSAttributedLabel.h"
#import "LSPostViewController.h"
#import "AppDelegate.h"
#import "LSProfileViewController.h"

@implementation LSAttributedLabel

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"ls"]) {
        NSString *type = [url host];
        NSString *data = [url query];
        if ([type isEqualToString:@"profile"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            id nc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [nc setUserId:[data integerValue]];
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuContainerViewController.centerViewController pushViewController:nc animated:YES];
        }
        if ([type isEqualToString:@"post"]) {
            
           // LSPostViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PostView"];
          //  vc.post = data;
            
        }
    } else {
        if (![[url scheme] hasPrefix:@"http"]) {
            NSString *_url = [NSString stringWithFormat:@"http://%@",url];
            url = [NSURL URLWithString:_url];
        }
        
        // open profile if url like a "linkstorage.ru/user/1"
        NSString *_url = [NSString stringWithFormat:@"%@",url];
        NSRange  searchedRange = NSMakeRange(0, [_url length]);
        NSString *pattern = @"linkstorage\.ru\/user\/([0-9]+)";
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:nil];
        NSArray* matches = [regex matchesInString:_url options:0 range: searchedRange];
        if ([matches count]) {
            NSString *match = [_url substringWithRange:[[matches objectAtIndex:0] rangeAtIndex:1]];
            return;
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
    }
}

@end
