//
//  SDK.m
//  linkstorage
//
//  Created by Ilya on 25.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "SDK.h"
#import "AppDelegate.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation SDK

#define URL_ORIG @"http://linkstorage.ru/"
#define URL @"http://linkstorage.ru/core/"

+ (instancetype)sharedInstance {
    static SDK *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SDK alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary *)getUserDataForId:(NSInteger)uid upd:(BOOL)upd {
    if (!self.userData || upd) {
        self.userData = [[NSDictionary alloc] init];
        do {
            NSLog(@"[SDK] getUserDataForId (%ld): query to api..",uid);
            self.userData = [self getJson:[NSString stringWithFormat:@"%@user.php?id=%ld",URL,uid]];
        } while (!self.userData);
    }
    return [self.userData objectForKey:@"response"];
}
- (NSDictionary *)getUserDataForId:(NSInteger)uid {
    return [self getUserDataForId:uid upd:NO];
}


- (NSDictionary *)getWallDataForId:(NSInteger)uid from:(NSInteger)from upd:(BOOL)upd {
    if (!self.wallData || upd) {
        self.wallData = [[NSDictionary alloc] init];
        do {
            NSLog(@"[SDK] getWallDataForId (%ld): query to api..",uid);
            self.wallData = [self getJson:[NSString stringWithFormat:@"%@wall.php?from=%ld&user_id=%ld",URL,from,uid]];
        } while (!self.wallData);
    }
    return [self.wallData objectForKey:@"response"];
}
- (NSDictionary *)getWallDataForId:(NSInteger)uid from:(NSInteger)from {
    return [self getWallDataForId:uid from:from upd:NO];
}


- (NSDictionary *)loginWithEmail:(NSString *)email password:(NSString *)pass {
    NSLog(@"[SDK] login: query to api..");
    NSDictionary *result = [self getJson:[NSString stringWithFormat:@"%@login.php?e=%@&p=%@",URL,email,pass]];
    return result;
        
}


- (NSDictionary *)likeToUserId:(NSNumber *)user_id post_id:(NSNumber *)post_id hash:(NSString *)hash {
    NSLog(@"[SDK] like (%@_%@): query to api..",user_id,post_id);
    NSDictionary *result = [self getJson:[NSString stringWithFormat:@"%@like.php?owner_id=%@&post_id=%@&hash=%@",URL,user_id,post_id,hash]];
    return result;
}


- (NSDictionary *)getSearchData:(NSString *)query type:(NSInteger)type from:(NSInteger)from upd:(BOOL)upd {
    if (!self.searchData || upd) {
        self.searchData = [[NSDictionary alloc] init];
        type = type==0?2:1;
        do {
            NSLog(@"[SDK] getSearchData (\"%@\",%ld,%ld): query to api..",query,type,from);
            self.searchData = [self getJson:[NSString stringWithFormat:@"%@search.php?q=%@&by=%ld&from=%ld",URL,query,type,from]];
        } while (!self.searchData);
    }
    return [self.searchData objectForKey:@"response"];
}
- (NSDictionary *)getSearchData:(NSString *)query type:(NSInteger)type from:(NSInteger)from {
    return [self getSearchData:query type:type from:from upd:NO];

}

- (NSDictionary *)getNotificationsFrom:(NSInteger)from upd:(BOOL)upd {
    if (!self.notifyData || upd) {
        self.notifyData = [[NSDictionary alloc] init];
        do {
            NSLog(@"[SDK] getNotifyDataFrom (%ld): query to api..",from);
            self.notifyData = [self getJson:[NSString stringWithFormat:@"%@feed?tab=notifications&from=%ld&ajax=1",URL_ORIG,from]];
        } while (!self.notifyData);
    }
    return [self.notifyData objectForKey:@"response"];
}
- (NSDictionary *)getNotificationsFrom:(NSInteger)from {
    return [self getNotificationsFrom:from upd:NO];
}
- (NSString *)getNotificationsCount {
    NSDictionary *result = [self getJson:[NSString stringWithFormat:@"%@pull.php?type=notifier&ajax=1",URL]];
    return [[[result objectForKey:@"response"] objectForKey:@"count"] stringValue];
}

- (NSDictionary *)getPost:(NSString *)post {
    NSLog(@"[SDK] getPost (%@): query to api..",post);
    NSDictionary *result = [self getJson:[NSString stringWithFormat:@"%@getPost.php?post=%@&ajax=1",URL,post]];
    return [result objectForKey:@"response"];
}

- (void)addPostWithUrl:(NSString *)url title:(NSString *)title text:(NSString *)text private:(NSInteger)private onSuccess:(void (^)(NSDictionary *result))successBlock onError:(void (^)(NSArray *result))errorBlock {
    NSString *hash = [[NSUserDefaults standardUserDefaults] objectForKey:@"addpost_hash"];
    NSDictionary *params = @{@"url":url, @"title":title, @"text":text, @"private":@(private), @"hash":hash, @"tab":@""};
    [[AFHTTPSessionManager manager] POST:[NSString stringWithFormat:@"%@post.php",URL] parameters:params success:^(NSURLSessionDataTask *task, id result) {
        if ([result objectForKey:@"response"]) {
            successBlock([result objectForKey:@"response"]);
        }
        if ([result objectForKey:@"error"]) {
            errorBlock([result objectForKey:@"error"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSArray *_error = [NSArray arrayWithObjects:[error localizedDescription], nil];
        NSLog(@"%@",_error);
        errorBlock(_error);
    }];
}

- (NSDictionary *)getFeedFrom:(NSInteger)from upd:(BOOL)upd {
    if (!self.feedData || upd) {
        self.feedData = [[NSDictionary alloc] init];
        do {
            NSLog(@"[SDK] getNotifyDataFrom (%ld): query to api..",from);
            self.feedData = [self getJson:[NSString stringWithFormat:@"%@news.php?from=%ld",URL,from]];
        } while (!self.feedData);
    }
    return [self.feedData objectForKey:@"response"];
}
- (NSDictionary *)getFeedFrom:(NSInteger)from {
    return [self getFeedFrom:from upd:NO];
}


- (NSDictionary *)getLinkDesc:(NSString *)url {
    return [self getJson:[NSString stringWithFormat:@"%@getSiteDescription.php?url=%@&ajax=1",URL,url]];
}


- (NSDictionary *)followToUserId:(NSNumber *)user_id hash:(NSString *)hash {
    NSLog(@"[SDK] follow (%@): query to api..",user_id);
    NSDictionary *result = [self getJson:[NSString stringWithFormat:@"%@follow.php?user_id=%@&hash=%@",URL,user_id,hash]];
    return result;
}


- (NSDictionary *)getJson:(NSString *)strUrl {
    NSLog(@"[SDK] Query to: %@",strUrl);
        
    NSURL *url = [NSURL URLWithString:strUrl];
    NSError* error = nil;
    
    NSData* jsonData = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    } else {
        id resultJson = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%@", error);
            return [NSDictionary dictionary];
        } else {
            NSDictionary *result = (NSDictionary *)resultJson;
            return result;
        }
    }
}

- (id)getJsonFromString:(NSString *)string {
    NSError* error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"%@",error);
    return json;
}


@end
