//
//  JXHNews.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#ifndef JXHNews_h
#define JXHNews_h
/**
 *  屏幕尺寸
 *
 *  @return <#return value description#>
 */
#define kScreenSize   [UIScreen mainScreen].bounds.size
//#define kScreenWidth  kScreenSize.width
//#define kScreenHeight kScreenSize.height


#define SH  [UIScreen mainScreen].bounds.size.height
#define SW  [UIScreen mainScreen].bounds.size.width


#define ZFPlayerShared                 [ZFPlayerSingleton sharedZFPlayer]
#define kScreenWidth  (SH < SW ? SH : SW)
#define kScreenHeight (SH > SW ? SH : SW)

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//电台列表
#define RadioList @"http://c.m.163.com/nc/topicset/ios/radio/index.html"
#define RadioScan @"http://c.3g.163.com/nc/topicset/ios/radio/%@/%ld-20.html"
#define RadioPlay @"http://c.m.163.com/nc/article/list/%@/%ld-20.html"
#define RadioURL  @"http://c.m.163.com/nc/article/%@/full.html"

//视频接口

#define VideoList @"http://c.m.163.com/nc/video/home/%ld-10.html"

#define VideoCategory  @"http://c.m.163.com/nc/video/list/%@/n/%ld-10.html"

//阅读接口
#define ReadList @"http://c.3g.163.com/recommend/getSubDocPic?passport=&devId=865586021288107&size=%ld&version=5.3.1&from=yuedu"

//新闻阅读详情
#define NewsDetail @"http://c.m.163.com/nc/article/%@/full.html"

//新闻频道栏数据
#define kChannel @"http://c.3g.163.com/nc/topicset/ios/subscribe/manage/listspecial.html"

//新闻列表
#define kNewsList @"http://c.m.163.com/nc/article/list/%@/%ld-20.html"

//照片
#define PhotoURL @"http://c.3g.163.com/photo/api/set/%@/%@.json"

//相关照片

#define RelatePhotoURL @"http://c.3g.163.com/photo/api/related/%@/%@.json"


//弹幕
#define DanMuURL @"http://comment.api.163.com/api/json/post/list/props/danmu/normal/video_bbs/%@/0/500/2/0/1"

#endif /* JXHNews_h */
