//
//  NotifyData.h
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITabBarController;

@interface NotifyData : NSObject

@property (nonatomic) NSDictionary *data;
@property (nonatomic) UITabBarController *controller;

+ (instancetype)sharedInstance;
- (void)combineNotifyDataWith:(NSDictionary *)newData;


@end
