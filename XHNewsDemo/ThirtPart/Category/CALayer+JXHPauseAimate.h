//
//  CALayer+JXHPauseAimate.h
//  XHNewsDemo
//
//  Created by iosdev on 16/3/17.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JXHPauseAimate)
// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;

@end
