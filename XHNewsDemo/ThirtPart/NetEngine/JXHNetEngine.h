//
//  JXHNetEngine.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlockType) (id responsData);
typedef void(^FailedBlockType)(NSError *error);

@interface JXHNetEngine : NSObject

+ (instancetype)sharedInstance;

- (void)requestDataFromNet:(NSString*)url success:(SuccessBlockType)successBlock falied:(FailedBlockType)failedBlock;

@end
