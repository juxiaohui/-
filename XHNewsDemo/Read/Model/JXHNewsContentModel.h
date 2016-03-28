//
//  JXHNewsContentModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/3/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXHNewsContentModel : NSObject

@property (nonatomic, copy)   NSString *body;       //内容
@property (nonatomic, copy)   NSString *source_url;  //资源链接
@property (nonatomic, retain) NSMutableArray *img;//内容中的图片集，pixel, src, alt
@property (nonatomic, retain) NSMutableArray *video;//内容中的视频，alt, url_mp4,url_m3u8
@property (nonatomic, copy)   NSString *digest;  //简介
@property (nonatomic, copy)   NSString *docid;   //唯一标识
@property (nonatomic, copy)   NSString *title;   //标题
@property (nonatomic, assign) NSInteger *replyCount; //回复数
@property (nonatomic, copy)   NSString *source;  //来源
@property (nonatomic, copy)   NSString *ptime; //发布时间

+(void)getNewsContentsModelWithId:(NSString * )str completed:(void (^)(JXHNewsContentModel *model, BOOL success)) handler;

@end
