//
//  LSSettingsViewController.m
//  Linkstorage
//
//  Created by Ilya on 29.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSSettingsViewController.h"
#import "AppDelegate.h"

@implementation LSSettingsViewController

- (void)viewDidLoad {
    
    // empty back button
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logout:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentLoginController];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setUserId: nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://linkstorage.ru/"]];
    for (NSHTTPCookie *each in cookieStorage) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:each];
    }
}

@end
