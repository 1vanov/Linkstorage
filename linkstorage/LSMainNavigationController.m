//
//  LSMainNavigationController.m
//  Linkstorage
//
//  Created by Ilya on 01.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSMainNavigationController.h"
#import "AppDelegate.h"

@interface LSMainNavigationController ()

@end

@implementation LSMainNavigationController

- (void)viewDidLoad {
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.37 green:0.76 blue:0.98 alpha:1.0]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.topViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(slideLeftMenu:)]];

    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slideLeftMenu:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
