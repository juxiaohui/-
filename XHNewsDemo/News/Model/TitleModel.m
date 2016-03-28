//
//  TitleModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "TitleModel.h"

@implementation TitleModel

+(void)getNewsTitleModelCompleted:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
   
    [[JXHNetEngine sharedInstance] requestDataFromNet:kChannel success:^(id responsData) {
        NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[@"tList"]) {
                NSArray *array = [TitleModel mj_objectArrayWithKeyValuesArray:recvDic[@"tList"]];
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
