//
//  JXHPhotoBrowerView.h
//  XHNewsDemo
//
//  Created by iosdev on 16/3/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXHPhotoBrowerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIView *tooBarView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *saveImageButton;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UITextView *desTextView;


+(instancetype)photoBrowerView;

@end
