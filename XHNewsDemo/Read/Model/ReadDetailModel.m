//
//  ReadTetailModel.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "ReadDetailModel.h"

@implementation ReadDetailModel



-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
   
}

-(id)valueForUndefinedKey:(NSString *)key{

    return nil;
}


+(void)getReadDetailModelWithId:(NSString * )str completed:(void (^)(ReadDetailModel *model, BOOL success)) handler{
    NSString *url=[NSString stringWithFormat:NewsDetail,str];
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[str]) {
                //NSArray *array = [ReadListModel mj_objectArrayWithKeyValuesArray:recvDic[str];
                ReadDetailModel *model=[[ReadDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:recvDic[str]];
                handler(model, YES);
            } else {
                handler(nil, NO);
            }
        });
        
    } falied:^(NSError *error) {
    }];




}
@end
