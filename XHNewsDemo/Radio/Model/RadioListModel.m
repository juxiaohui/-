//
//  RadioListModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RadioListModel.h"

@implementation RadioListModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"tList" : @"JXHtListModel",

             };
}

+(void)getRadiolListModel:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:RadioList success:^(id responsData) {
       NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[@"cList"]) {
                NSArray *array = [RadioListModel mj_objectArrayWithKeyValuesArray:recvDic[@"cList"]];
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
