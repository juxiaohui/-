//
//  RadioPlayModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RadioPlayModel.h"

@implementation RadioPlayModel



+(void)getRadioPlayModelWithCid:(NSString *)tid andPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
    
    NSString *url=[NSString stringWithFormat:RadioPlay,tid,page];
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        
        NSDictionary *recvDic = (NSDictionary *)responsData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[tid]) {
                NSArray *array = [RadioPlayModel mj_objectArrayWithKeyValuesArray:recvDic[tid]];
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
