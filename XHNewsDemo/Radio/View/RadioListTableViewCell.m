//
//  RadioListTableViewCell.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/11.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RadioListTableViewCell.h"

@implementation RadioListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonClick:(id)sender {
    
    if (self.buttonClick) {
        UIButton *button =(UIButton *)sender;
        self.buttonClick(button.tag);
    }
}

@end
