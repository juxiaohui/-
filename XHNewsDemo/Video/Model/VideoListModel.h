//
//  VideoListModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListModel : NSObject
/*
"replyCount": 2,
"videosource": "新媒体",
"mp4Hd_url": null,
"cover": "http://vimg2.ws.126.net/image/snapshot/2016/1/O/5/VBCC7GAO5.jpg",
"title": "印尼爆炸现场视频 爆炸声响巨大",
"playCount": 10068,
"replyBoard": "videonews_bbs",
"replyid": "BCC7GAO4008535RB",
"description": "印尼市民拍摄爆炸现场视频",
"mp4_url": "http://flv2.bn.netease.com/videolib3/1601/14/hPuCs2522/SD/hPuCs2522-mobile.mp4",
"length": 31,
"playersize": 1,
"m3u8Hd_url": null,
"vid": "VBCC7GAO4",
"m3u8_url": "http://flv2.bn.netease.com/videolib3/1601/14/hPuCs2522/SD/movie_index.m3u8",
"ptime": "2016-01-14 14:22:32"
*/

@property(nonatomic,retain)NSNumber *length;
@property(nonatomic,retain)NSNumber *playCount;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *d_escription;
@property(nonatomic,copy)NSString *mp4_url;
@property(nonatomic,copy)NSString *cover;

+(void)getVideoListModelWithPag:(NSInteger ) page completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;

+(void)getVideoListModelWithPag:(NSInteger ) page andSid:(NSString *)sid completed:(void (^)(NSMutableArray *modelArray, BOOL success)) handler;

@end
