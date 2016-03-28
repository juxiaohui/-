//
//  VideoListModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel

//@synthesize  description;

+(void)getVideoListModelWithPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
    
    NSString *url=[NSString stringWithFormat:VideoList,page];
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        
        NSDictionary *recvDic = (NSDictionary *)responsData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[@"videoList"]) {
                NSArray *array = [VideoListModel mj_objectArrayWithKeyValuesArray:recvDic[@"videoList"]];
                handler([NSMutableArray arrayWithArray:array], YES);
            } else {
                handler(nil, NO);
            }
        });
    } falied:^(NSError *error) {
        handler(nil, NO);
    }];
}

+(void)getVideoListModelWithPag:(NSInteger ) page andSid:(NSString *)sid completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
   
    NSString *url=[NSString stringWithFormat:VideoCategory,sid,page];
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        
        NSDictionary *recvDic = (NSDictionary *)responsData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[sid]) {
                NSArray *array = [VideoListModel mj_objectArrayWithKeyValuesArray:recvDic[sid]];
                handler([NSMutableArray arrayWithArray:array], YES);
            } else {
                handler(nil, NO);
            }
        });
    } falied:^(NSError *error) {
        handler(nil, NO);
    }];
}


//遇到OC关键字用此方法解决
+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"d_escription": @"description"};
}
@end
