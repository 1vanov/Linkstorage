//
//  NotifyData.m
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "NotifyData.h"

@implementation NotifyData

+ (instancetype)sharedInstance {
    static NotifyData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NotifyData alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self.data = [NSDictionary dictionary];
    return self;
}

- (void)combineNotifyDataWith:(NSDictionary *)newData {
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:self.data]; // Current wall data
    NSArray *old_items = [self.data objectForKey:@"items"];
    NSArray *new_items = [newData objectForKey:@"items"];
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObjectsFromArray:old_items];
    [items addObjectsFromArray:new_items];
    
    [data setObject:items forKey:@"items"];
    
    if ([newData objectForKey:@"start_from"]) {
        [data setObject:[newData objectForKey:@"start_from"] forKey:@"start_from"];
    } else {
        [data removeObjectForKey:@"start_from"];
    }
    self.data = [NSDictionary dictionaryWithDictionary:data];
    
}


@end
