//
//  VideoCategoryListModel.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/15.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCategoryListModel : NSObject

@property(nonatomic,retain)NSNumber *length;
@property(nonatomic,retain)NSNumber *playCount;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *d_escription;
@property(nonatomic,copy)NSString *mp4_url;
@property(nonatomic,copy)NSString *cover;

@end
