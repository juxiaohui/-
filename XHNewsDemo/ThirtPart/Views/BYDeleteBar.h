//
//  BYSelectNewBar.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BYDeleteBar : UIView

@property (nonatomic,strong) UILabel *hitText;

@property (nonatomic,strong) UIButton *sortBtn;

-(void)sortBtnClick:(UIButton *)sender;

@end
