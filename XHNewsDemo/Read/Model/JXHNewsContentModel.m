//
//  JXHNewsContentModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/3/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHNewsContentModel.h"

@implementation JXHNewsContentModel

+(void)getNewsContentsModelWithId:(NSString * )str completed:(void (^)(JXHNewsContentModel *model, BOOL success)) handler{
    
    NSString *url=[NSString stringWithFormat:NewsDetail,str];
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[str]) {
                JXHNewsContentModel *model = [JXHNewsContentModel mj_objectWithKeyValues:recvDic[str]];
                handler(model, YES);
            } else {
                handler(nil, NO);
            }
        });

    } falied:^(NSError *error) {
        
    }];
    
}

@end
