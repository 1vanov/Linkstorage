//
//  LSLeftMenuViewController.m
//  Linkstorage
//
//  Created by Ilya on 25.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSLeftMenuViewController.h"
#import "LSLeftMenuTableViewCell.h"
#import "LeftMenuData.h"
#import "AppDelegate.h"

@interface LSLeftMenuViewController ()

@end

@implementation LSLeftMenuViewController

- (void)viewDidLoad {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0.23 green:0.24 blue:0.25 alpha:1.0]];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return [[[LeftMenuData sharedInstance] firstSection] count];
    if (section==1) return [[[LeftMenuData sharedInstance] secondSection] count];
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (section == 0) return;
    [view setTintColor:[UIColor colorWithRed:0.15 green:0.18 blue:0.18 alpha:1.0]];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]];
    [header.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0.0f;
    return 36.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return @"Категории";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSLeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *data;
    if (indexPath.section==0) data = [[[LeftMenuData sharedInstance] firstSection] objectAtIndex:indexPath.row];
    if (indexPath.section==1) data = [[[LeftMenuData sharedInstance] secondSection] objectAtIndex:indexPath.row];
    cell = [cell initWithData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data;
    if (indexPath.section==0) data = [[[LeftMenuData sharedInstance] firstSection] objectAtIndex:indexPath.row];
    if (indexPath.section==1) data = [[[LeftMenuData sharedInstance] secondSection] objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id nc = [storyboard instantiateViewControllerWithIdentifier:[data objectAtIndex:3]];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuContainerViewController setCenterViewController:nc];
    [self closeLeftMenu:nil];
}

- (IBAction)closeLeftMenu:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}
@end
