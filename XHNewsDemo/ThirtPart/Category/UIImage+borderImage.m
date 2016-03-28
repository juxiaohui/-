//
//  UIImage+borderImage.m
//  图面裁剪
//
//  Created by iosdev on 16/3/15.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "UIImage+borderImage.h"

@implementation UIImage (borderImage)

+ (nullable UIImage *)imageWithClipImage:(nullable UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)color{
    
    //图片的宽高
    CGFloat imageWH=image.size.width;
    
    //边界的宽度
    
    CGFloat borderWH=borderWidth;
    
    //设置大圆的宽高
    
    CGFloat ovalWH=imageWH + 2 * borderWH;
    
    //开始位图上下文
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    
    //画大圆
    
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    [color set];
    
    [path fill];
    
    //画裁剪路径
    
    UIBezierPath * clipPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWH, borderWH, imageWH, imageWH)];
    [clipPath addClip];
    
    //绘制图片
    [image drawAtPoint:CGPointMake(borderWH, borderWH)];
    
    //获取绘制的新图片
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    
    UIGraphicsEndImageContext();
 
    //返回新图片
    return newImage;
}
+ (nullable UIImage *)imageWithCaputureView:(nullable UIView *)view{
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    //获得当前上下文
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    
    //图层渲染到当前上下文
    [view.layer renderInContext:contextRef];
    
    //获得当前上下文图片
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    //返回上下文
    return image;
}

@end
