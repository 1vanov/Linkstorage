//
//  LeftMenuData.h
//  Linkstorage
//
//  Created by Ilya on 25.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftMenuData : NSObject

@property (nonatomic) NSMutableArray *firstSection;
@property (nonatomic) NSMutableArray *secondSection;

+ (instancetype)sharedInstance;

@end
