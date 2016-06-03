//
//  AppDelegate.m
//  linkstorage
//
//  Created by Ilya on 24.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "AppDelegate.h"
#import "SDK.h"
#import "LSLeftMenuNavigationController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.userId = [[NSUserDefaults standardUserDefaults] integerForKey:@"user_id"];
    
    BOOL logged = NO;
    for (NSDictionary *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://linkstorage.ru/"]]) {
        if ([[cookie valueForKey:@"name"] isEqualToString:@"hash"]) logged = YES;
    }
    
    if (!self.userId || !logged) {
        [self presentLoginController]; 
    } else {
        [self presentMFSController];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
//    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
//    if (event==1) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//    }
//    if (event==2) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

/*
 self.timerNotifyCounter = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(iterNotifyCounter) userInfo:nil repeats:YES];
 [self iterNotifyCounter];
 - (void)iterNotifyCounter {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 NSString *count = [[SDK sharedInstance] getNotificationsCount];
 count = [count isEqualToString:@"0"]?nil:count;
 dispatch_async(dispatch_get_main_queue(), ^(void){
 UIViewController *requiredViewController = [self.viewControllers objectAtIndex:2];
 UITabBarItem *item = requiredViewController.tabBarItem;
 [item setBadgeValue:count];
 });});
 }
 */

- (void)presentMFSController {
    UINavigationController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    LSLeftMenuNavigationController *leftMenuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeftMenuNavigationController"];
    self.menuContainerViewController = [MFSideMenuContainerViewController containerWithCenterViewController:rootController leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
    [self.menuContainerViewController.shadow setRadius:4.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    self.window.rootViewController = self.menuContainerViewController;
}

- (void)presentLoginController {
    UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    self.window.rootViewController = rootController;
}



@end
