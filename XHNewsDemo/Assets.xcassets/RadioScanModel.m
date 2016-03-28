//
//  RadioScanModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RadioScanModel.h"

@implementation RadioScanModel

+(void)getRadiolScanModelWithCid:(NSString *)cid andPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
    
    NSString *url=[NSString stringWithFormat:RadioScan,cid,page];
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        
        NSDictionary *recvDic = (NSDictionary *)responsData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[@"tList"]) {
                NSArray *array = [RadioScanModel mj_objectArrayWithKeyValuesArray:recvDic[@"tList"]];
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
