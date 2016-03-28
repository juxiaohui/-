//
//  VideoListHeaderView.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "VideoListHeaderView.h"

@implementation VideoListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)selectAction:(UIButton *)sender {
    if (self.categoryBlock) {
        self.categoryBlock(sender.tag);
    }
}

@end
