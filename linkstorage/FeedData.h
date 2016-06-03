//
//  FeedData.h
//  Linkstorage
//
//  Created by Ilya on 13.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedData : NSObject

@property (nonatomic) NSDictionary *data;
@property (nonatomic) NSString *userId;


+ (instancetype)sharedInstance;
- (void)combineFeedDataWith:(NSDictionary *)newData;

@end
