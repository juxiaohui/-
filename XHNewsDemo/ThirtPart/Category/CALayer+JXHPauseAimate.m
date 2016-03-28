//
//  CALayer+JXHPauseAimate.m
//  XHNewsDemo
//
//  Created by iosdev on 16/3/17.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "CALayer+JXHPauseAimate.h"

@implementation CALayer (JXHPauseAimate)

- (void)pauseAnimate
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimate
{
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
