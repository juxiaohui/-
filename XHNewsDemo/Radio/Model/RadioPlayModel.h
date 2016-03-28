//
//  RadioPlayModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioPlayModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *ptime;
@property(nonatomic,copy)NSString *docid;
@property(nonatomic,copy)NSString *digest;
@property(nonatomic,copy)NSString *imgsrc;

+(void)getRadioPlayModelWithCid:(NSString *)tid andPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;
@end
