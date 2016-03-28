//
//  NewsListModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/21.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListModel : NSObject


@property(nonatomic,copy)NSArray *ads;

@property(nonatomic,copy)NSArray *imgextra;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *imgsrc;

@property(nonatomic,copy)NSString *digest;

@property(nonatomic,copy)NSString *photosetID;

@property(nonatomic,copy)NSString *videoID;

@property(nonatomic,copy)NSString *docid;

@property (nonatomic, copy) NSString *TAG;

@property (nonatomic, copy) NSString *skipType;

@property (nonatomic, copy) NSString *editor;

+(void)getNewsListModelWithCid:(NSString *)tid andPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;

@end
