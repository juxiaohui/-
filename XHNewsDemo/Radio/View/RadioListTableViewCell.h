//
//  RadioListTableViewCell.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^setButtonClick) (NSInteger tag);

@interface RadioListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UILabel *titleLable1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *deslabel1;
@property (weak, nonatomic) IBOutlet UILabel *desLabel2;
@property (weak, nonatomic) IBOutlet UILabel *desLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic, copy) void (^(buttonClick))(NSInteger tag);

//@property (nonatomic, copy) setButtonClick  block;

@end
