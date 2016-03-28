//
//  MTImagePlayView.m
//  17dong_ios
//
//  Created by win5 on 6/4/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import "MTImagePlayView.h"
#import "UIImageView+WebCache.h"
#define kStartTag   1000
#define kDefaultScrollInterval  2

@interface MTImagePlayView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) NSMutableArray *pageControlConstraints;
@property (nonatomic, strong) NSMutableArray *scrollViewConstraints;

@end

@implementation MTImagePlayView

-(void)setSourceArray:(NSArray *)sourceArray
{
    _sourceArray = sourceArray;
    [self reloadData];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.scrollViewConstraints = [NSMutableArray array];
    
    self.scrollInterval = kDefaultScrollInterval;
    
    // scrollview
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
    }
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    
    self.scrollView.delegate = self;
    
    // UIPageControl
    if (!self.pageControl) {
        self.pageControl = [[UIPageControl alloc] init];
    }
    self.pageControl.userInteractionEnabled = YES;
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.numberOfPages = self.count;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(handleClickPageControl:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pageControl];
    
    NSArray *pageControlVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-0-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    NSArray *pageControlHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[pageControl]-|"
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    self.pageControlConstraints = [NSMutableArray arrayWithArray:pageControlVConstraints];
    [self.pageControlConstraints addObjectsFromArray:pageControlHConstraints];
    [self addConstraints:self.pageControlConstraints];
    
    self.edgeInsets = UIEdgeInsetsZero;
    
    
}

//KVO监视自身的bounds属性变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        [self reloadData];
    }
}

- (void)reloadData
{
    // 把子视图从self.srollView上面移除
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    if (self.sourceArray && self.sourceArray.count == 0) {
        self.count = 0;
    }else{
        self.count = self.sourceArray.count;
    }
    self.pageControl.numberOfPages = self.count;
    self.pageControl.currentPage = 0;
    
    if (self.count == 0) {
        return;
    }
    
    CGFloat width = self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right;
    CGFloat height = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    
    for (int i = 0; i < self.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = kStartTag + i;
        imageView.userInteractionEnabled = YES;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        [self.scrollView addSubview:imageView];
        
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
//让sdWabImage去下载图片
        if (self.sourceArray.count) {
            NSURL *url = [NSURL URLWithString:self.sourceArray[i]];
            [imageView sd_setImageWithURL:url placeholderImage:nil];
        }
    }
    
    // 添加约束
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *imageViewNames = [NSMutableArray array];
    for (int i = kStartTag; i < kStartTag + self.count; i++) {
        NSString *imageViewName = [NSString stringWithFormat:@"imageView%d", i - kStartTag];
        [imageViewNames addObject:imageViewName];
        
        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:i];
        [viewsDictionary setObject:imageView forKey:imageViewName];
    }
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[%@]-0-|", [imageViewNames objectAtIndex:0]]
                                                                            options:kNilOptions
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
    
    NSMutableString *hConstraintString = [NSMutableString string];
    [hConstraintString appendString:@"H:|-0"];
    for (NSString *imageViewName in imageViewNames) {
        [hConstraintString appendFormat:@"-[%@]-0", imageViewName];
    }
    [hConstraintString appendString:@"-|"];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hConstraintString
                                                                            options:NSLayoutFormatAlignAllTop
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.count, self.scrollView.frame.size.height);
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - 添加的手势是实现方法
- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NSInteger index = imageView.tag - kStartTag;
    
    if (self.MTImagePlayerViewDelegate && [self.MTImagePlayerViewDelegate respondsToSelector:@selector(imagePlayerView:didTapAtIndex:)]) {
        [self.MTImagePlayerViewDelegate imagePlayerView:self didTapAtIndex:index];
    }
}

- (void)handleClickPageControl:(UIPageControl *)sender
{
    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
    }
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
    
    UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:(sender.currentPage + kStartTag)];
    [self.scrollView scrollRectToVisible:imageView.frame animated:YES];
}

#pragma mark - 自动滚动
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        if (!self.autoScrollTimer || !self.autoScrollTimer.isValid) {
            self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
        }
    } else {
        if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
            [self.autoScrollTimer invalidate];
            self.autoScrollTimer = nil;
        }
    }
}

- (void)setScrollInterval:(NSUInteger)scrollInterval
{
    _scrollInterval = scrollInterval;
    
    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
    
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
}

- (void)handleScrollTimer:(NSTimer *)timer
{
    if (self.count == 0) {
        return;
    }
    
    NSInteger currentPage = self.pageControl.currentPage;
    NSInteger nextPage = currentPage + 1;
    if (nextPage == self.count) {
        nextPage = 0;
    }
    
    BOOL animated = YES;
    if (nextPage == 0) {
        animated = NO;
    }
    
    UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:(nextPage + kStartTag)];
    [self.scrollView scrollRectToVisible:imageView.frame animated:animated];
    
    self.pageControl.currentPage = nextPage;
}

#pragma mark - scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // disable v direction scroll
    if (scrollView.contentOffset.y > 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 控制定时器进行自动切图
    if (self.autoScrollTimer && self.autoScrollTimer.isValid) {
        [self.autoScrollTimer invalidate];
    }
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(handleScrollTimer:) userInfo:nil repeats:YES];
    
    // update UIPageControl
    CGRect visiableRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.bounds.size.width, scrollView.bounds.size.height);
    NSInteger currentIndex = 0;
    for (UIImageView *imageView in scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            if (CGRectContainsRect(visiableRect, imageView.frame)) {
                currentIndex = imageView.tag - kStartTag;
                break;
            }
        }
    }
    
    self.pageControl.currentPage = currentIndex;
}

#pragma mark - settings
- (void)setPageControlPosition:(MTPageControlPosition)pageControlPosition
{
    NSString *vFormat = nil;
    NSString *hFormat = nil;
    
    switch (pageControlPosition) {
        case MTPageControlPosition_TopLeft: {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:|-[pageControl]";
            break;
        }
            
        case MTPageControlPosition_TopCenter: {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:|[pageControl]|";
            break;
        }
            
        case MTPageControlPosition_TopRight: {
            vFormat = @"V:|-0-[pageControl]";
            hFormat = @"H:[pageControl]-|";
            break;
        }
            
        case MTPageControlPosition_BottomLeft: {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:|-[pageControl]";
            break;
        }
            
        case MTPageControlPosition_BottomCenter: {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:|[pageControl]|";
            break;
        }
            
        case MTPageControlPosition_BottomRight: {
            vFormat = @"V:[pageControl]-0-|";
            hFormat = @"H:[pageControl]-|";
            break;
        }
            
        default:
            break;
    }
    
    [self removeConstraints:self.pageControlConstraints];
    
    NSArray *pageControlVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    
    NSArray *pageControlHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                                                               options:kNilOptions
                                                                               metrics:nil
                                                                                 views:@{@"pageControl": self.pageControl}];
    
    [self.pageControlConstraints removeAllObjects];
    [self.pageControlConstraints addObjectsFromArray:pageControlVConstraints];
    [self.pageControlConstraints addObjectsFromArray:pageControlHConstraints];
    
    [self addConstraints:self.pageControlConstraints];
}

- (void)setHidePageControl:(BOOL)hidePageControl
{
    self.pageControl.hidden = hidePageControl;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    
    [self removeConstraints:self.scrollViewConstraints];
    
    NSArray *scrollViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[scrollView]-bottom-|"
                                                                              options:kNilOptions
                                                                              metrics:@{@"top": @(self.edgeInsets.top),
                                                                                        @"bottom": @(self.edgeInsets.bottom)}
                                                                                views:@{@"scrollView": self.scrollView}];
    NSArray *scrollViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[scrollView]-right-|"
                                                                              options:kNilOptions
                                                                              metrics:@{@"left": @(self.edgeInsets.left),
                                                                                        @"right": @(self.edgeInsets.right)}
                                                                                views:@{@"scrollView": self.scrollView}];
    
    [self.scrollViewConstraints removeAllObjects];
    [self.scrollViewConstraints addObjectsFromArray:scrollViewHConstraints];
    [self.scrollViewConstraints addObjectsFromArray:scrollViewVConstraints];
    
    [self addConstraints:self.scrollViewConstraints];
    
    // 跟新imageview的约束
    CGFloat width = self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right;
    CGFloat height = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subView;
            for (NSLayoutConstraint *constraint in imageView.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                    constraint.constant = width;
                } else if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    constraint.constant = height;
                }
            }
        }
    }
}

@end
