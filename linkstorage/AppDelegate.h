//
//  AppDelegate.h
//  linkstorage
//
//  Created by Ilya on 24.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MFSideMenu/MFSideMenu.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSInteger userId;
@property (nonatomic) MFSideMenuContainerViewController *menuContainerViewController;

- (void)presentMFSController;
- (void)presentLoginController;

@end

