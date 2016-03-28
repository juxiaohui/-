//
//  JXHNetEngine.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHNetEngine.h"
#import "NSString+URLEncoding.h"
@interface JXHNetEngine ()

@property(nonatomic,retain)AFHTTPSessionManager *manager;

@end
@implementation JXHNetEngine

+ (instancetype)sharedInstance{
    static JXHNetEngine *s_netEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_netEngine = [[JXHNetEngine alloc]init];
    });
    return s_netEngine;
}
- (id)init{
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc]init];
        //增加新的类型text/html
        NSSet *currentAcceptSet = self.manager.responseSerializer.acceptableContentTypes;
        NSMutableSet *mset = [NSMutableSet setWithSet:currentAcceptSet];
        [mset addObject:@"text/html"];
        self.manager.responseSerializer.acceptableContentTypes = mset;
    }
    return self;
}
-(void)requestDataFromNet:(NSString*)url success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock{

   // NSString *EncodingUrl=[url urlEncodeUsingEncoding:NSUTF8StringEncoding];
        [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            if (failedBlock) {
                failedBlock(error);
            }

        }];
}

@end
