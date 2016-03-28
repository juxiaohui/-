//
//  VideoListHeaderView.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListHeaderView : UIView


@property (nonatomic, copy) void (^(categoryBlock))(NSInteger tag);


@end
