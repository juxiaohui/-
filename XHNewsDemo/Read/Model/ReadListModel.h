//
//  ReadListModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/15.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadListModel : NSObject
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,copy) NSString *digest;//简介
@property (nonatomic,copy) NSString *img;//图片
@property (nonatomic,copy) NSString *title;//主题
@property (nonatomic,copy) NSString *pixel;//大小
@property (nonatomic,copy) NSString *source;
@property (nonatomic,retain) NSArray *imgnewextra;
@property (nonatomic,copy) NSString *t_emplate;




+(void)getReadListModelWithSize:(NSInteger )size completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;

@end
