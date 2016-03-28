//
//  ButtonTableViewCell.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/19.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    for (UIButton *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger a = 0;
    
    if (_dataArray.count > 4) {
        if (_dataArray.count/4) {//没有除尽
            a = _dataArray.count/4 + 1;
        }else{//已经除尽了
            a = _dataArray.count/4;
        }
    }else{
        a = 1;
    }
    
    for (int i = 0 ; i<_dataArray.count; i++) {
        
        //MTChooseConditionDetailModel *detailModel = _dataArray[i];//取到二级模型
        
        int col = i % 4 + 1;
        int row = i / 4 + 1;
        
        //1.配置达人榜头像视图
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        
        btn.layer.borderWidth=1;
        btn.layer.borderColor=[UIColor redColor].CGColor;
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        btn.tag = 100 + i;
        //判断按钮是否是选中的
        
        [btn setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];//给按钮赋值
        
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0xffffff"] forState:UIControlStateSelected];
        
        CGFloat btnW=(kScreenWidth-75)/4.0;
        
        CGFloat btnH=btnW/2.5;
        
        CGFloat padding=15.0;
        
        btn.frame=CGRectMake(padding+(i%4)*(btnW+padding), padding+(i/4)*(btnH+padding), btnW, btnH);
        
        
        
//        
//        [btn setBackgroundImage:[CommonUtils imageWithColor:[UIColor colorWithHexString:@"0xe8e8e8"]] forState:UIControlStateNormal];
//        
//        [btn setBackgroundImage:[CommonUtils imageWithColor:[UIColor colorWithHexString:@"0x5175b1"]] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
    
        
        
//
//        NSArray *attributes = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
//        
//        NSArray *attributes_H_rank = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
//        
//        [self.contentView addConstraints:attributes_H_rank];
//        
//        [self.contentView addConstraints:attributes];
//        
//        //cententX约束
//        NSLayoutConstraint *cententX_rank_headView = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:(2.0f*col)/5.0f constant:10];
//        
//        //cententY约束
//        NSLayoutConstraint *cententY_rank_headView = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:(2.0f*row)/(a+1) constant:10];
//        
//        
//       
//        
//        [self.contentView addConstraint:cententY_rank_headView];
//        
//        [self.contentView addConstraint:cententX_rank_headView];
        
    }
}

-(void)btnClick:(UIButton *)button{

    
}

@end
