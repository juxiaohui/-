//
//  ReadListModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/15.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "ReadListModel.h"

@implementation ReadListModel
+(void)getReadListModelWithSize:(NSInteger )size completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler{
    
    NSString *url=[NSString stringWithFormat:ReadList,size];
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[@"推荐"]) {
                NSArray *array = [ReadListModel mj_objectArrayWithKeyValuesArray:recvDic[@"推荐"]];
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
    
    return @{@"t_emplate": @"template"};
}
@end
