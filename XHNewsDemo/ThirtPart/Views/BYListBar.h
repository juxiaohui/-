//
//  BYConditionBar.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYListBar : UIScrollView

@property (nonatomic,copy) void(^arrowChange)();
@property (nonatomic,copy) void(^listBarItemClickBlock)(NSString *itemName , NSInteger itemIndex);

@property (nonatomic,strong) NSMutableArray *visibleItemList;

-(void)operationFromBlock:(animateType)type itemName:(NSString *)itemName index:(int)index;
-(void)itemClickByScrollerWithIndex:(NSInteger)index;

@end
