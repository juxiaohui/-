//
//  VideoListTableViewCell.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "VideoListTableViewCell.h"

@implementation VideoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playButtonClick:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock();
    }
}


- (IBAction)buttonClick:(id)sender {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
