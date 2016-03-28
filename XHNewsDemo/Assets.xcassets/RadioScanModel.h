//
//  RadioScanModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioScanModel : NSObject


@property(nonatomic,copy)NSString *playCount;
@property(nonatomic,copy)NSString *tname;
@property(nonatomic,retain)NSDictionary *radio;
@property(nonatomic,copy)NSString *tid;

+(void)getRadiolScanModelWithCid:(NSString *)cid andPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;

@end
