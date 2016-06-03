//
//  ProfileData.m
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "ProfileData.h"

@implementation ProfileData

+ (instancetype)sharedInstance {
    static ProfileData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProfileData alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self.wallData = [NSDictionary dictionary];
    self.userData = [NSDictionary dictionary];
    return self;
}

- (void)combineWallDataWith:(NSDictionary *)newData {
    NSMutableDictionary *wallData = [NSMutableDictionary dictionaryWithDictionary:self.wallData]; // Current wall data
    NSArray *old_items = [self.wallData objectForKey:@"items"];
    NSArray *new_items = [newData objectForKey:@"items"];
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObjectsFromArray:old_items];
    [items addObjectsFromArray:new_items];
    
    [wallData setObject:items forKey:@"items"];
    
    if ([newData objectForKey:@"start_from"]) {
        [wallData setObject:[newData objectForKey:@"start_from"] forKey:@"start_from"];
    } else {
        [wallData removeObjectForKey:@"start_from"];
    }
    self.wallData = [NSDictionary dictionaryWithDictionary:wallData];

}

@end
