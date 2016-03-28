//
//  VideoListTableViewCell.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFPlayerView;

@interface VideoListTableViewCell :  UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *desImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet ZFPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property(nonatomic,copy)void((^playBlock))();
@property(nonatomic,copy)void((^shareBlock))();

@end
