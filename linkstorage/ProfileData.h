//
//  ProfileData.h
//  Linkstorage
//
//  Created by Ilya on 02.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileData : NSObject

@property (nonatomic) NSDictionary *wallData;
@property (nonatomic) NSDictionary *userData;
@property (nonatomic) NSInteger userId;


+ (instancetype)sharedInstance;
- (void)combineWallDataWith:(NSDictionary *)newData;

@end
