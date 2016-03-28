//
//  JXHPhotoBrowerView.m
//  XHNewsDemo
//
//  Created by iosdev on 16/3/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHPhotoBrowerView.h"

@implementation JXHPhotoBrowerView

+(instancetype)photoBrowerView{

    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JXHPhotoBrowerView class]) owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
