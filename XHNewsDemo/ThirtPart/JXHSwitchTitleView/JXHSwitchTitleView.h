//
//  JXHSwitchTitleView.h
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JXHSwitchTitleViewDelegate;


@interface JXHSwitchTitleView : UIView<UIScrollViewDelegate>

/** 按钮之间的间隔,如果不设置默认是15,若按钮比较少并且不设置间隔的话，会有自动排版的效果，最好别设置 */
@property(nonatomic,assign)NSUInteger titleBtnMargin;

/** 顶部bar的高度,如果不设置默认是30(如果低于30无效)，假设需要更低，自行修改 */
@property(nonatomic,assign)CGFloat titleBarHeight;

/** 顶部bar的颜色,如果不设置模式是[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:0.5f] */
@property(nonatomic,retain)UIColor *titleBarColor;

/** 按钮的字体大小,如果不设置默认是15 */
@property(nonatomic,assign)CGFloat btnTitlefont;

/** 按钮的字体颜色,如果不设置默认是黑色 */
@property(nonatomic,retain)UIColor *btnNormalColor;

/** 按钮选中字体颜色,如果不设置默认是绿色 */
@property(nonatomic,retain)UIColor *btnSelectedColor;

/** 按钮选中背景图片*/
@property(nonatomic,retain)UIImage *btnSelectedBgImage;

/** 按钮正常背景图片*/
@property(nonatomic,retain)UIImage *btnNormalBgImage;


@property (nonatomic, weak) IBOutlet id<JXHSwitchTitleViewDelegate> titleViewDelegate;

/**
 * 若想创建左边特殊按钮,比如一起动左边的国旗,需要用该特殊方法,调用其他的方法全部是不创建特殊按钮的
 */
- (instancetype)initWithFrame:(CGRect)frame createLeftSpecialBtn:(BOOL)iscreate;

/** 这个方法要在设置好控制器后在调用 */

- (void)reloadData;

- (UIButton *)leftButton;

@end

@protocol JXHSwitchTitleViewDelegate <NSObject>

@required

- (NSUInteger)numberOfTitleBtn:(JXHSwitchTitleView *)View;

- (UIViewController *)titleView:(JXHSwitchTitleView *)View viewControllerSetWithTilteIndex:(NSUInteger)index;

@optional

- (void)titleView:(JXHSwitchTitleView *)View didselectTitle:(NSUInteger)number;

- (void)titleView:(JXHSwitchTitleView *)View specialBtnDidSelect:(UIButton *)btn;


@end
