//
//  MTImagePlayView.h
//  17dong_ios
//
//  Created by win5 on 6/4/15.
//  Copyright (c) 2015 win5. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MTPageControlPosition) {
    MTPageControlPosition_TopLeft,
    MTPageControlPosition_TopCenter,
    MTPageControlPosition_TopRight,
    MTPageControlPosition_BottomLeft,
    MTPageControlPosition_BottomCenter,
    MTPageControlPosition_BottomRight
};
@class MTImagePlayView;

@protocol MTImagePlayerViewDelegate <NSObject>
- (void)imagePlayerView:(MTImagePlayView *)imagePlayerView didTapAtIndex:(NSInteger)index;
@end

@interface MTImagePlayView : UIView

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) id<MTImagePlayerViewDelegate> MTImagePlayerViewDelegate;
@property (nonatomic, assign) BOOL autoScroll;  // 设置是否自动滚动,default is YES
@property (nonatomic, assign) NSUInteger scrollInterval;    // scroll滚动间隔, default is 2 seconds
@property (nonatomic, assign) MTPageControlPosition pageControlPosition;  // 分页控制器的位置, defautl is bottomright
@property (nonatomic, assign) BOOL hidePageControl; // hide pageControl, default is NO
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/** 该数组存放所有需要播放的图片的下载地址 */
@property(nonatomic,  retain) NSArray *sourceArray;
- (void)reloadData;
@end

/** 如果有别的需求请按照原来框架自行修改 */