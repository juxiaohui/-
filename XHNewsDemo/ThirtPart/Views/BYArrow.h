//
//  SelectionButton.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYArrow : UIButton

@property (nonatomic,copy) void(^arrowBtnClick)();

@end