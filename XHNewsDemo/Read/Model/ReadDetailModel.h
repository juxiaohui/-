//
//  ReadTetailModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadDetailModel : NSObject


@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSArray *img;
@property(nonatomic,copy)NSArray *relative_sys;

+(void)getReadDetailModelWithId:(NSString * )str completed:(void (^)(ReadDetailModel *model, BOOL success)) handler;

@end
