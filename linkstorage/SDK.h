//
//  SDK.h
//  linkstorage
//
//  Created by Ilya on 25.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDK : NSObject 
@property (nonatomic) NSDictionary *userData;
@property (nonatomic) NSDictionary *wallData;
@property (nonatomic) NSDictionary *searchData;
@property (nonatomic) NSDictionary *notifyData;
@property (nonatomic) NSDictionary *feedData;
@property (nonatomic) NSDictionary *response;

+ (instancetype)sharedInstance;

- (NSDictionary *)getUserDataForId:(NSInteger)uid;
- (NSDictionary *)getUserDataForId:(NSInteger)uid upd:(BOOL)upd;

- (NSDictionary *)getWallDataForId:(NSInteger)uid from:(NSInteger)from upd:(BOOL)upd;
- (NSDictionary *)getWallDataForId:(NSInteger)uid from:(NSInteger)from;

- (NSDictionary *)loginWithEmail:(NSString *)email password:(NSString *)pass;

- (NSDictionary *)likeToUserId:(NSNumber *)user_id post_id:(NSNumber *)post_id hash:(NSString *)hash;

- (NSDictionary *)getSearchData:(NSString *)query type:(NSInteger)type from:(NSInteger)from;
- (NSDictionary *)getSearchData:(NSString *)query type:(NSInteger)type from:(NSInteger)from upd:(BOOL)upd;

- (NSDictionary *)getNotificationsFrom:(NSInteger)from upd:(BOOL)upd;
- (NSDictionary *)getNotificationsFrom:(NSInteger)from;
- (NSString *)getNotificationsCount;

- (NSDictionary *)getFeedFrom:(NSInteger)from upd:(BOOL)upd;
- (NSDictionary *)getFeedFrom:(NSInteger)from;

- (NSDictionary *)getPost:(NSString *)post;

- (NSDictionary *)getLinkDesc:(NSString *)url;

- (void)addPostWithUrl:(NSString *)url title:(NSString *)title text:(NSString *)text private:(NSInteger)private onSuccess:(void (^)(NSDictionary *result))successBlock onError:(void (^)(NSArray *result))errorBlock;

- (NSDictionary *)followToUserId:(NSNumber *)user_id hash:(NSString *)hash;



- (NSDictionary *)getJson:(NSString *)strUrl;
- (id)getJsonFromString:(NSString *)string;


@end
