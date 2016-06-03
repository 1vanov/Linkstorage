//
//  LSPostViewController.m
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSPostViewController.h"
#import "SDK.h"

@interface LSPostViewController ()

@end

@implementation LSPostViewController

- (void)viewDidLoad {
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // empty back button
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.urlLabel setAlpha:0];
    [self.titleView setAlpha:0];
    [self.textView setAlpha:0];
    
    [self.titleView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
    [self.textView setContentInset:UIEdgeInsetsMake(-8, -5, -8, -5)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Fetch neccessary data from API
        if (!self.postData)
            self.postData = [[SDK sharedInstance] getPost:self.post];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.urlLabel.text = [[self.postData objectForKey:@"url"] objectForKey:@"original"];
            self.titleView.text = [self.postData objectForKey:@"title"];
            self.textView.text = [self.postData objectForKey:@"text"];
            
            [self.titleView sizeToFit];
            
            if (self.titleView.text.length) {
                NSLog(@"%f",self.titleView.contentSize.height);
                self.titleViewHeight.constant = self.titleView.contentSize.height;
                if (self.titleViewHeight.constant==37) self.titleViewHeight.constant-=14;
            } else {
                self.textViewTop.constant = self.titleViewTop.constant;
                self.titleViewHeight.constant = 0.0f;
                self.titleViewTop.constant = 0.0f;
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.urlLabel setAlpha:1];
                [self.titleView setAlpha:1];
                [self.textView setAlpha:1];
            }];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
