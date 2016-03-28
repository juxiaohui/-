//
//  UIImage+borderImage.h
//  图面裁剪
//
//  Created by iosdev on 16/3/15.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (borderImage)

+ (nullable UIImage *)imageWithClipImage:(nullable UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)color;
//截屏

+ (nullable UIImage *)imageWithCaputureView:(nullable UIView *)view;
@end
