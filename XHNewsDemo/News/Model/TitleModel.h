//
//  TitleModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TitleModel : NSObject

@property(nonatomic,copy)NSString *tname;
@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *tid;

+(void)getNewsTitleModelCompleted:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;

@end
