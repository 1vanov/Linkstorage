//
//  LeftMenuData.m
//  Linkstorage
//
//  Created by Ilya on 25.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LeftMenuData.h"

@implementation LeftMenuData

+ (instancetype)sharedInstance {
    static LeftMenuData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LeftMenuData alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    // label - image - rightDetail
    
    self.firstSection = [NSMutableArray array];
    [self.firstSection addObject:[NSArray arrayWithObjects:@"Профиль", @"user", @"", @"ProfileNavigationController", nil]];
    [self.firstSection addObject:[NSArray arrayWithObjects:@"Уведомления", @"novel", @"3", @"NotifyNavigationController", nil]];
    [self.firstSection addObject:[NSArray arrayWithObjects:@"Новости", @"news", @"", @"FeedNavigationController", nil]];
    [self.firstSection addObject:[NSArray arrayWithObjects:@"Поиск", @"search", @"", @"SearchNavigationController", nil]];
    [self.firstSection addObject:[NSArray arrayWithObjects:@"Настройки", @"settings", @"", @"SettingsNavigationController", nil]];
    
    self.secondSection = [NSMutableArray array];
    [self.secondSection addObject:[NSArray arrayWithObjects:@"Добавить", @"plus", @"", @"q", nil]];
    [self.secondSection addObject:[NSArray arrayWithObjects:@"Статьи", @"burn_folder", @"14", @"", nil]];
    [self.secondSection addObject:[NSArray arrayWithObjects:@"История", @"documents_folder", @"5", @"", nil]];
    [self.secondSection addObject:[NSArray arrayWithObjects:@"iOS Development", @"likes_folder", @"27", @"", nil]];
    [self.secondSection addObject:[NSArray arrayWithObjects:@"Маркетинг", @"user_folder", @"18", @"", nil]];
    [self.secondSection addObject:[NSArray arrayWithObjects:@"Рокетбанк", @"porn_folder", @"8", @"", nil]];
    
    return self;
}

@end
