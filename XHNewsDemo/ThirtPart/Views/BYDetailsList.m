//
//  BYSelectionDetails.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYDetailsList.h"
#import "BYListItem.h"


#define kStatusHeight 20
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define padding 20
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25
@interface BYDetailsList()

@property (nonatomic,strong) UIView *sectionHeaderView;

@property (nonatomic,strong) NSMutableArray *allItems;

@property (nonatomic,strong) BYListItem *itemSelect;

@end

@implementation BYDetailsList

-(void)setListAll:(NSMutableArray *)listAll{
    _listAll = listAll;
    
    self.showsVerticalScrollIndicator = YES;
    self.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *listTop = listAll[0];
    NSArray *listBottom = listAll[1];
    
#pragma 更多频道标签
    self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,padding+(padding + kItemH)*((listTop.count -1)/itemPerLine+1),kScreenW, 30)];
    self.sectionHeaderView.backgroundColor = RGBColor(238.0, 238.0, 238.0);
    UILabel *moreText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    moreText.text = @"点击添加频道";
    moreText.font = [UIFont systemFontOfSize:14];
    [self.sectionHeaderView addSubview:moreText];
    [self addSubview:self.sectionHeaderView];
    
     __weak typeof(self) unself = self;
    NSInteger count1 = listTop.count;
    for (int i =0; i <count1; i++) {
        BYListItem *item = [[BYListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i% itemPerLine), padding+(kItemH + padding)*(i/itemPerLine), kItemW, kItemH)];
        item.longPressBlock = ^(){
            if (unself.longPressedBlock) {
                unself.longPressedBlock();
            }
        };
        item.operationBlock = ^(animateType type, NSString *itemName, int index){
            if (self.opertionFromItemBlock) {
                self.opertionFromItemBlock(type,itemName,index);
            }
        };
        item.itemName = listTop[i];
        item.location = top;
        [self.topView addObject:item];
        item->locateView = self.topView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        item.hitTextLabel = self.sectionHeaderView;
        [self addSubview:item];
        [self.allItems addObject:item];
        
        if (!self.itemSelect) {
            [item setTitleColor:[UIColor redColor] forState:0];
            self.itemSelect = item;
        }
    }
    
    NSInteger count2 = listBottom.count;
    for (int i=0; i<count2; i++) {
        BYListItem *item = [[BYListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine),CGRectGetMaxY(self.sectionHeaderView.frame)+padding+(kItemH+padding)*(i/itemPerLine), kItemW, kItemH)];
        item.operationBlock = ^(animateType type, NSString *itemName, int index){
            if (self.opertionFromItemBlock) {
                self.opertionFromItemBlock(type,itemName,index);
            }
        };
        item.itemName = listBottom[i];
        item.location = bottom;
        item.hitTextLabel = self.sectionHeaderView;
        [self.bottomView addObject:item];
        item->locateView = self.bottomView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        [self addSubview:item];
        [self.allItems addObject:item];
    }
    
    self.contentSize = CGSizeMake(kScreenW, CGRectGetMaxY(self.sectionHeaderView.frame)+padding+(kItemH+padding)*((count2-1)/4+1) + 50);
}

-(void)itemRespondFromListBarClickWithItemName:(NSString *)itemName{
    for (int i = 0 ; i<self.allItems.count; i++) {
        BYListItem *item = (BYListItem *)self.allItems[i];
        if ([itemName isEqualToString:item.itemName]) {
            [self.itemSelect setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
            [item setTitleColor:[UIColor redColor] forState:0];
            self.itemSelect = item;
        }
    }
}

-(NSMutableArray *)allItems{
    if (_allItems == nil) {
        _allItems = [NSMutableArray array];
    }
    return _allItems;
}

-(NSMutableArray *)topView{
    if (_topView == nil) {
        _topView = [NSMutableArray array];
    }
    return _topView;
}

-(NSMutableArray *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [NSMutableArray array];
    }
    return _bottomView;
}

@end
