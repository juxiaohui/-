//
//  RadioListModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioListModel : NSObject

@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *cname;
@property(nonatomic,copy)NSArray *tList;

+(void)getRadiolListModel:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;
@end
