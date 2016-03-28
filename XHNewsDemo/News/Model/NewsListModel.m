//
//  NewsListModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/21.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

+(void)getNewsListModelWithCid:(NSString *)tid andPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
    
    NSString *urlStr=[NSString stringWithFormat:kNewsList,tid,page];
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:urlStr success:^(id responsData) {
        NSDictionary *recvDic = (NSDictionary *)responsData;
        //JXHLog(@"%@",responsData);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[tid]) {
                NSArray *array = [NewsListModel mj_objectArrayWithKeyValuesArray:recvDic[tid]];
                
                handler([NSMutableArray arrayWithArray:array], YES);
            } else {
                handler(nil, NO);
            }
        });
        
    } falied:^(NSError *error) {
        handler(nil, NO);
    }];
}
@end
