//
//  JXHSwitchTitleView.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHSwitchTitleView.h"

#import "BYListBar.h"

#define titleBtnFont           [UIFont systemFontOfSize:(self.btnTitlefont != 0)?self.btnTitlefont : 15.0f]
#define titleViewWidth         self.bounds.size.width - (_iscreatSpecialBtn?80:0)
#define titleViewHeight        self.bounds.size.height - 44.0f
#define titleBtnMargin         ((self.titleBtnMargin != 0) ?self.titleBtnMargin : 15.0f)
#define titleItemNormalColor   ( self.btnNormalColor ?self.btnNormalColor : [UIColor blackColor])
#define titleItemSelectedColor  ( self.btnSelectedColor ?self.btnSelectedColor : [UIColor greenColor])

#define JXH_H  [UIScreen mainScreen].bounds.size.height
#define JXH_W  [UIScreen mainScreen].bounds.size.width

#define Win5_SCREEN_WIDTH   (JXH_H < JXH_W ? JXH_H : JXH_W)- (_iscreatSpecialBtn?80:0)
#define Win5_SCREEN_HEIGHT  (JXH_H > JXH_W ? JXH_H : JXH_W)


@implementation JXHSwitchTitleView

{
    BYListBar *_titleScrollView;
    
    
    UIScrollView *_mainScrollView;
    
    NSMutableArray *_viewArray;
    BOOL _isInit;
    NSInteger _selectBtnTag;
    NSLayoutConstraint *_titleBarConstraint;//_titleScroll的宽度约束
    CGFloat _lastContentOfSetX;//上次偏转的X
    UIView *_leftBGView;//左边的view
    UIButton *_leftBtn;//左边的按钮
    BOOL _iscreatSpecialBtn;//是否创建左边的特殊按钮
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self creatScrollViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame createLeftSpecialBtn:(BOOL)iscreate
{
    if (self = [super initWithFrame:frame]) {
        _iscreatSpecialBtn = iscreate;//是否创建进行赋值
        [self creatScrollViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatScrollViews];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self creatScrollViews];
    }
    return self;
}

- (void)setTitleBarColor:(UIColor *)titleBarColor
{
    _titleBarColor = titleBarColor;
    
    [self setNeedsDisplay];
}

- (void)setTitleBarHeight:(CGFloat)titleBarHeight
{
    _titleBarHeight = titleBarHeight;
    
    [self setNeedsDisplay];
}
//如果外面设置了一些titleBarColor，titleBarHeight，就会调用这个方法重新描绘
- (void)drawRect:(CGRect)rect
{
    _titleScrollView.backgroundColor = self.titleBarColor ? self.titleBarColor :[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    _leftBGView.backgroundColor = self.titleBarColor ? self.titleBarColor :[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    _titleBarConstraint.constant = (self.titleBarHeight >= 30)?self.titleBarHeight : 30;
}

#pragma mark -- 开始滚动视图
- (void)creatScrollViews
{
    //创建顶部可滑动的titleView
    _titleScrollView = [[BYListBar alloc] init];
    
//    _titleScrollView.delegate = self;
//    _titleScrollView.showsHorizontalScrollIndicator = NO;
//    _titleScrollView.showsVerticalScrollIndicator = NO;
//    _titleScrollView.translatesAutoresizingMaskIntoConstraints = NO;
//    _titleScrollView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
//    [self addSubview:_titleScrollView];
    _selectBtnTag = 100;
    
    //创建主滚动视图
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _viewArray = [[NSMutableArray alloc] init];
    //_userContentOffsetX = 0;
    _isInit = NO;
    [self addSubview:_mainScrollView];
    if (_iscreatSpecialBtn) {
        
        //创建左边的view
        _leftBGView = [[UIView alloc] init];
        _leftBGView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
        _leftBGView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_leftBGView];
        
        //创建左边的点击按钮
        _leftBtn.translatesAutoresizingMaskIntoConstraints= NO;
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_leftBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        
        [_leftBtn setImage: [UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        _leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_leftBtn addTarget:self action:@selector(specialBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBGView addSubview:_leftBtn];
        
        //添加约束
        NSDictionary *views =@{@"titleScrollView":_titleScrollView,@"mainScrollView":_mainScrollView,@"leftBGView":_leftBGView,@"leftBtn":_leftBtn};
        
        NSArray *leftBtnHConstrains =   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[leftBtn]-10-|" options:0 metrics:nil views:views];
        [_leftBGView addConstraints:leftBtnHConstrains];
        
        NSArray *leftBtnVConstrains =   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[leftBtn]-10-|" options:0 metrics:nil views:views];
        [_leftBGView addConstraints:leftBtnVConstrains];
        
        //1._titleScrollView水平上面的约束
        NSArray *HConstrains =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftBGView(40)]-0-[titleScrollView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:HConstrains];
        
        //2._mainScrollView水平方向的约束
        NSArray *mainScrollHConstrains =   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainScrollView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:mainScrollHConstrains];
        
        //垂直方向的约束
        NSArray *vContrains =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleScrollView(29)]-0-[mainScrollView]-0-|" options:0 metrics:nil views:views];
        NSLayoutConstraint *cons_1 = [NSLayoutConstraint constraintWithItem:_titleScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_leftBGView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        NSArray *vContrains_left = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[leftBGView]" options:0 metrics:nil views:views];
        
        [self addConstraint:cons_1];
        [self addConstraints:vContrains_left];
        _titleBarConstraint = [vContrains objectAtIndex:1];
        [self addConstraints:vContrains];
        
    }else{//不创建左边特殊按钮
        
        NSDictionary *views =@{@"titleScrollView":_titleScrollView,@"mainScrollView":_mainScrollView};
        
        //1._titleScrollView水平上面的约束
        NSArray *HConstrains =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleScrollView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:HConstrains];
        
        //2._mainScrollView水平方向的约束
        NSArray *mainScrollHConstrains =   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mainScrollView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:mainScrollHConstrains];
        
        //垂直方向的约束
        NSArray *vContrains =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleScrollView(29)]-0-[mainScrollView]-0-|" options:0 metrics:nil views:views];
        _titleBarConstraint = [vContrains objectAtIndex:1];
        [self addConstraints:vContrains];
    }
}

- (void)specialBtnClick:(UIButton *)btn{
    if (self.titleViewDelegate && [self.titleViewDelegate respondsToSelector:@selector(titleView:specialBtnDidSelect:)]) {
        [self.titleViewDelegate titleView:self specialBtnDidSelect:btn];
    }
}

#pragma mark - 把外界设置的控制器加到滚动视图里面
- (void)reloadData
{
    NSUInteger number = [self.titleViewDelegate numberOfTitleBtn:self];
    
    for (int i=0; i<number; i++) {
        UIViewController *vc = [self.titleViewDelegate titleView:self viewControllerSetWithTilteIndex:i];
        [_viewArray addObject:vc];
        [_mainScrollView addSubview:vc.view];
    }
    [self createButtons];
    
    //选中第一个view
    if (self.titleViewDelegate && [self.titleViewDelegate respondsToSelector:@selector(titleView:didselectTitle:)]) {
        [self.titleViewDelegate titleView:self didselectTitle:_selectBtnTag - 100];
    }
    
    _isInit = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

- (void)createButtons
{
    CGFloat viewContentWidth = titleBtnMargin;
    CGFloat xOffset = titleBtnMargin;//btn的x偏移量
    
    CGFloat a = 15.0f;
    CGFloat xOffset_reset;//即将要重新设置的间隔长度
    for (int i = 0; i < [_viewArray count]; i++) {
        UIViewController *vc = _viewArray[i];
        CGSize textSize = [vc.title boundingRectWithSize:CGSizeMake(titleViewWidth, (self.titleBarHeight >= 30)?self.titleBarHeight : 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleBtnFont} context:nil].size;
        a += textSize.width + 15.0f;
    }
    
    //当所有标题按钮长度加起来没整个视图的宽度长的时候，需要重新设置每个titleBtn之间的间隔，以便让视图看起来比较和谐
    //注意的是:如果外面设置了self.titleBtnMargin 那么该操作不应该该进行，应遵循外面的设置的属性(titleBtnMargin == 15就表示外面没设置间隔)
    
    if (a < Win5_SCREEN_WIDTH && (titleBtnMargin == 15)) {
        
        xOffset_reset = (Win5_SCREEN_WIDTH - a + 15.0f *(_viewArray.count + 1) ) /  (_viewArray.count + 1);//重新设置间隔
        
        xOffset = xOffset_reset;
        
        for (int i = 0; i < [_viewArray count]; i++) {
            
            UIViewController *vc = _viewArray[i];
            
            CGSize textSize = [vc.title boundingRectWithSize:CGSizeMake(titleViewWidth, (self.titleBarHeight >= 30)?self.titleBarHeight : 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleBtnFont} context:nil].size;
            
            viewContentWidth += xOffset_reset + textSize.width;
            
            [self createTitleBtnWithFrame:CGRectMake(xOffset,0,textSize.width  , (self.titleBarHeight >= 30)?self.titleBarHeight : 30) title:vc.title tag:i];
            
            //计算下一个btn的x偏移量
            xOffset += textSize.width + xOffset_reset;
            
        }
        
        //设置顶部滚动视图的内容总尺寸
        _titleScrollView.contentSize = CGSizeMake(viewContentWidth, _titleBarConstraint.constant);
        
    }else{//表示外面没设置self.titleBtnMargin，并且所有标题按钮长度加起来比整个视图的宽度长
        
        for (int i = 0; i < [_viewArray count]; i++) {
            UIViewController *vc = _viewArray[i];
            CGSize textSize = [vc.title boundingRectWithSize:CGSizeMake(titleViewWidth, (self.titleBarHeight >= 30)?self.titleBarHeight : 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleBtnFont} context:nil].size;
            viewContentWidth += titleBtnMargin +textSize.width;
            [self createTitleBtnWithFrame:CGRectMake(xOffset,0,textSize.width  , (self.titleBarHeight >= 30)?self.titleBarHeight : 30) title:vc.title tag:i];
            //计算下一个btn的x偏移量
            xOffset += textSize.width + titleBtnMargin;
            
        }
        //设置顶部滚动视图的内容总尺寸
        _titleScrollView.contentSize = CGSizeMake(viewContentWidth, _titleBarConstraint.constant);
        
    }
    
}

//创建title按钮
- (void)createTitleBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger )tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag + 100;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = titleBtnFont;
    [btn setTitleColor:titleItemNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:titleItemSelectedColor forState:UIControlStateSelected];
    [btn setBackgroundImage:self.btnNormalBgImage forState:UIControlStateNormal];
    [btn setBackgroundImage:self.btnSelectedBgImage forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(selectTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    if (tag == 0) {
        btn.selected = YES;
    }
    [_titleScrollView addSubview:btn];
}

- (void)layoutSubviews
{
    if (_isInit) {
        
        //更新主视图的总宽度
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth * _viewArray.count, 0);
        
        //更新_mainScrollView子视图的宽度
        for (int i = 0; i < [_viewArray count]; i++) {
            UIViewController *subVC = _viewArray[i];
            subVC.view.frame = CGRectMake(kScreenWidth*i, 0,kScreenHeight, titleViewHeight);
        }
        //滚动到选中的视图
        [_mainScrollView setContentOffset:CGPointMake((_selectBtnTag - 100)*self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_titleScrollView viewWithTag:_selectBtnTag];
        [self setBtnframe:button];
        
        //移除不在屏幕中间的view降低内存消耗
        //[self repeatUseMainScrollView];
    }
}

#pragma mark - 封装的点击按钮触和滚动视图后调用的方法
- (void)selectTitleButton:(UIButton *)sender
{
    [self changeBtnStatus:sender];
    
    //按钮选中状态，重复点击忽略不计
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
        } completion:^(BOOL finished) {
            if (finished) {
                [_mainScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:NO];
                if (self.titleViewDelegate && [self.titleViewDelegate respondsToSelector:@selector(titleView:didselectTitle:)]) {
                    [self.titleViewDelegate titleView:self didselectTitle:_selectBtnTag - 100];
                }
            }
        }];
    }
}

//调整btn的状态，让选中和不选中的互换
- (void)changeBtnStatus:(UIButton *)button
{
    //调整btn的位置
    [self setBtnframe:button];
    
    //如果更换按钮
    if (button.tag != _selectBtnTag) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_titleScrollView viewWithTag:_selectBtnTag];
        lastButton.selected = NO;
        //赋值按钮tag
        _selectBtnTag = button.tag;
    }
}

//调整按钮的位置，让其显示在屏幕中间(模仿网易的顶部动画)
- (void)setBtnframe:(UIButton *)sender
{
    CGFloat b = titleViewWidth;//_titleScrollView.bounds.size.width == 0注意这个bug--原因是使用自动布局 所以这个宽度就是0了
    CGFloat c = sender.frame.size.width;
    CGFloat x = sender.frame.origin.x;
    
    //当视图两边挡住了按钮的文字时，更新位置
    if (x - _titleScrollView.contentOffset.x > b - (titleBtnMargin+c)) {
        
        [_titleScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (b- (titleBtnMargin+c)), 0)  animated:YES];
        
    }
    
    if (x - _titleScrollView.contentOffset.x < titleBtnMargin) {
        
        [_titleScrollView setContentOffset:CGPointMake(x - titleBtnMargin, 0)  animated:YES];
    }
    
    //当按钮不在中间的时候，更新位置
    if (x > b/2 &&(_titleScrollView.contentSize.width - x - c)> b/2 ) {//按钮靠右边(判断条件需要画图)
        
        if ((x - _lastContentOfSetX) > (b/2 - c/2)) {
            
            [_titleScrollView setContentOffset:CGPointMake(x - b/2 + c/2, 0) animated:YES];
            
        }else{//按钮靠左边(判断条件需要画图)
            
            [_titleScrollView setContentOffset:CGPointMake(c/2 - b/2 + x, 0) animated:YES];
            
        }
    }
    _lastContentOfSetX = _titleScrollView.contentOffset.x;
}

#pragma mark ----UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        //更新titleView和mainScrollView位置，并切换按钮
        int tag = (int)(scrollView.contentOffset.x/self.bounds.size.width + 0.5f) +100;
        UIButton *button = (UIButton *)[_titleScrollView viewWithTag:tag];
        
        [self changeBtnStatus:button];
        
        //按钮选中状态，重复点击忽略不计--- 【注意这里动画不能重用，否则会产生bug(原因是点击按钮和滑动视图都是调用该方法，会产生混乱)】
        if (!button.selected) {
            button.selected = YES;
            [UIView animateWithDuration:0.25 animations:^{
            } completion:^(BOOL finished) {
                if (finished) {
                    if (self.titleViewDelegate && [self.titleViewDelegate respondsToSelector:@selector(titleView:didselectTitle:)]) {
                        [self.titleViewDelegate titleView:self didselectTitle:_selectBtnTag - 100];
                    }
                }
            }];
        }
        //移除不在屏幕中间的view降低内存消耗
        //[self repeatUseMainScrollView];
    }
}

//如果_mainScrollView.subViews 不在屏幕中，会移除
- (void)repeatUseMainScrollView
{
    //    for (int i = 0; i < _viewArray.count; i++) {
    //        UIViewController *ctrl = _viewArray[i];
    //        CGRect frame = ctrl.view.frame;
    //
    //        if ([self isInScreen:frame]) {//不在视图中，应该放进缓存池中
    //
    //            [ctrl.view removeFromSuperview];
    //
    //        }else{//在视图中
    //
    //            [_mainScrollView addSubview:ctrl.view];
    //
    //        }
    //    }
}

//判断改view是否在视图上:YES就是不在，NO是在视图上
- (BOOL)isInScreen:(CGRect)frame
{
    return ((frame.origin.x + frame.size.width)   <  _mainScrollView.contentOffset.x ) ||
    (frame.origin.x > (_mainScrollView.contentOffset.x + 375));
}

- (UIButton *)leftButton
{
    return _leftBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
