//
//  JXHPhotoBrowerController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/3/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHPhotoBrowerController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "JXHPhotoBrowerView.h"
#import "NewsListModel.h"
#import "PictureModel.h"
#import "UIView+JXHExt.h"
#import "JXHRelatePhotoModel.h"
#import "JXHReuseScrollView.h"

@interface JXHPhotoBrowerController ()<UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic,copy)  NSString * firstID;
@property (nonatomic,copy)  NSString * secondID;
@property (nonatomic,strong) JXHPhotoBrowerView * photoBrowerView;
@property (nonatomic,strong) NSMutableArray * pictureModelArray;
@property (nonatomic,strong) NSMutableArray * relatePhotoArray;
@property (nonatomic,strong) NSMutableArray * pictures;
@property (nonatomic,strong) NSMutableArray * imageViews;
//@property (nonatomic,strong) UIScrollView * zoomScrollView;
@property (nonatomic, strong) UIScrollView *changescrollView;
@property (nonatomic, strong) NSMutableSet *recycledPages;
@property (nonatomic, strong) NSMutableSet *visiblePages;


@end

@implementation JXHPhotoBrowerController


- (NSMutableSet *)recycledPages {
    if (!_recycledPages) {
        self.recycledPages = [NSMutableSet set];
    }
    return _recycledPages;
}
- (NSMutableSet *)visiblePages {
    if (!_visiblePages) {
        self.visiblePages = [NSMutableSet set];
    }
    return _visiblePages;
}
-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews=[NSMutableArray array];
    }
    return _imageViews;
}

-(NSMutableArray *)pictures{
    if (!_pictures) {
        _pictures=[NSMutableArray array];
    }
    return _pictures;
}

-(NSMutableArray *)relatePhotoArray{
    if (!_relatePhotoArray) {
        _relatePhotoArray=[NSMutableArray array];
    }
    return _relatePhotoArray;
}
-(NSMutableArray *)pictureModelArray{
    if (!_pictureModelArray) {
        _pictureModelArray=[NSMutableArray array];
    }
    return _pictureModelArray;
}

-(JXHPhotoBrowerView *)photoBrowerView{
    if (!_photoBrowerView) {
        _photoBrowerView=[JXHPhotoBrowerView photoBrowerView];
        _photoBrowerView.bounds=[UIScreen mainScreen].bounds;
    }
    return _photoBrowerView;
}

- (void)loadView {
    self.view=self.photoBrowerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.firstID = [self.photosID substringWithRange:NSMakeRange(4, 4)];
    self.secondID = [self.photosID substringFromIndex:9];
    [self addAction];
    [self addGestureRecognizer];
    [self loadData];
    [self loadRelateData];
    
}

/**
 *  按钮点击事件
 */
-(void)addAction{
    
    [self.photoBrowerView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.photoBrowerView.commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.photoBrowerView.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.photoBrowerView.saveImageButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];

}

/**
 *  添加手势
 */
-(void)addGestureRecognizer{
    //点击
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    [self.photoBrowerView addGestureRecognizer:tap];
    //双击
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapHanle:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.photoBrowerView.imagesScrollView addGestureRecognizer:doubleTap];
    
    self.photoBrowerView.imagesScrollView.maximumZoomScale=2.0;
    
    self.photoBrowerView.imagesScrollView.minimumZoomScale=1.0;
    
    [tap requireGestureRecognizerToFail:doubleTap];
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    [self.photoBrowerView.imagesScrollView addGestureRecognizer:longPress];
    
}

/**
 *  数据请求
 */

-(void)loadData{
    
       [[JXHNetEngine sharedInstance] requestDataFromNet:[NSString stringWithFormat:PhotoURL,self.firstID,self.secondID] success:^(id responsData) {
        NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pictureModelArray removeAllObjects];
            self.pictureModelArray=[PictureModel mj_objectArrayWithKeyValuesArray:recvDic[@"photos"]];
            [self setUPBaseData];
            //[self setup];
            [self setUpPhotoBrower];
        });
     } falied:^(NSError *error) {
  }];
}

/**
 *   请求相关的图片集
 */
-(void)loadRelateData{
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:[NSString stringWithFormat:RelatePhotoURL,self.firstID,self.secondID] success:^(id responsData) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.relatePhotoArray removeAllObjects];
            self.relatePhotoArray=[JXHRelatePhotoModel mj_objectArrayWithKeyValuesArray:responsData];
        });
        
    } falied:^(NSError *error) {
        
    }];
}

-(void)setup{
    
    CGRect visibleBounds = self.photoBrowerView.imagesScrollView.bounds;
    
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex =  floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex =  MIN(lastNeededPageIndex, (int)[self.pictureModelArray count] - 1);
    if (self.visiblePages) {
        
        for (JXHReuseScrollView *scrollView in self.visiblePages) {
            //不显⽰的判断条件
            if (scrollView.index < firstNeededPageIndex || scrollView.index > lastNeededPageIndex) {
                //将没有显示的ImageView保存在recycledPages里
                [self.recycledPages addObject:scrollView];
                //将未显示的ImageView移除
                [scrollView removeFromSuperview];
            }
        }
    }
    [self.visiblePages minusSet:self.recycledPages];
    
    while (self.recycledPages.count > 2) {
        [self.recycledPages removeObject:[self.recycledPages anyObject]];
    }
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) { //当index对应的ImageView没有显示时,使用重用来定义ImageView
            JXHReuseScrollView * scrollView= [self dequeueRecyclScrollView]; //当page = = nil
            if (!scrollView) {
                scrollView = [[JXHReuseScrollView alloc] init];
                scrollView.bounces = YES;
                scrollView.delegate = self;
                scrollView.zoomScale = 1.0;
                scrollView.minimumZoomScale = 1.0;
                scrollView.maximumZoomScale = 2.0;
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.directionalLockEnabled = YES;
            }
            //设置index对应的ImageView图片和位置
            [self configurePage:scrollView forIndex:index];
            //将page加入到visiblePages集合里
            [self.visiblePages addObject:scrollView];
            [self.photoBrowerView.imagesScrollView addSubview:scrollView];
        }
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (JXHReuseScrollView *scrollView in self.visiblePages) {
        if (scrollView.index == index) { //如果index所对应的ImageView在可见数组中,将标志位标记为YES,否则返 回NO
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

-(JXHReuseScrollView *)dequeueRecyclScrollView{
    //查看是否有重用对象
    JXHReuseScrollView *scrollView = [self.recycledPages anyObject];
    if (scrollView) {
        [self.recycledPages removeObject:scrollView];
    }
    return scrollView;

}

-(void)configurePage:(JXHReuseScrollView *)scrollView forIndex:(NSUInteger)index {


    scrollView.index = index; //这句要写，不然第一张会消失
    scrollView.frame = CGRectMake(kScreenWidth * index, -20, kScreenWidth, kScreenHeight);
    
    scrollView.imageView.contentMode = UIViewContentModeScaleAspectFit;//自适应图片大小
    scrollView.imageView.frame = self.view.bounds;
    
    [scrollView.imageView sd_setImageWithURL:[NSURL URLWithString:[self.pictureModelArray[index] imgurl]]  placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

-(void)setUPBaseData{
    
    self.photoBrowerView.titleLabel.text=[NSString stringWithFormat:@"1/%ld",self.pictureModelArray.count];
    self.photoBrowerView.desTextView.text=[self.pictureModelArray[0] note];
    self.photoBrowerView.tooBarView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.photoBrowerView.tooBarView.layer.borderWidth=0.5;
    
}
-(void)setUpPhotoBrower{
    
    self.photoBrowerView.imagesScrollView.contentSize=CGSizeMake((self.pictureModelArray.count+1) * kScreenWidth, 0);
    self.photoBrowerView.imagesScrollView.delegate=self;
    for (int i = 0; i < self.pictureModelArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
//        UIScrollView *scrollView=[[UIScrollView alloc]init];
//        scrollView.bounces = YES;
//        scrollView.delegate = self;
//        scrollView.zoomScale = 1.0;
//        scrollView.minimumZoomScale = 1.0;
//        scrollView.maximumZoomScale = 2.0;
//        scrollView.showsVerticalScrollIndicator = NO;
//        scrollView.directionalLockEnabled = YES;
//        imageView.userInteractionEnabled = YES;
        PictureModel *model=self.pictureModelArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imageView.x = kScreenWidth * i;
            //scrollView.x=kScreenWidth+i;
            
            imageView.width = kScreenWidth;
            //scrollView.width= kScreenWidth;
            
            imageView.height=image.size.height *imageView.width/image.size.width;
            //scrollView.height=image.size.height *imageView.width/image.size.width;;
            
            
            if (imageView.height > kScreenHeight) { // 图片过长
                imageView.height=kScreenHeight;
                //scrollView.height=kScreenHeight;
                
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.centerY=kScreenHeight*0.5;
                //scrollView.centerY=kScreenHeight*0.5;
                
            } else { // 图片居中显示
                imageView.centerY = kScreenHeight * 0.5-50;
                //scrollView.centerY=kScreenHeight*0.5-50;
            }
        }];
        
        //[scrollView addSubview:imageView];
        
        [self.photoBrowerView.imagesScrollView addSubview:imageView];
        
        
        [self.imageViews addObject:imageView];
    }
}

-(void)setupRelatedImages{
   
    [self.pictures removeAllObjects];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            JXHRelatePhotoModel *model = self.relatePhotoArray[i * 2 + j];
            CGRect frame1 = CGRectMake(kScreenWidth * self.pictureModelArray.count + kScreenWidth / 2 * i, (kScreenHeight - 90) / 3 * 2 * j, kScreenWidth / 2, (kScreenHeight - 90) / 3);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame1];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
            [self.photoBrowerView.imagesScrollView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tap];
    
            [self.pictures addObject:imageView];
            
            CGRect frame2 = CGRectMake(0, CGRectGetHeight(imageView.frame) - 30, CGRectGetWidth(imageView.frame), 30);
            UILabel *label = [[UILabel alloc] initWithFrame:frame2];
            label.backgroundColor = [UIColor blackColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            label.alpha = 0.8;
            label.text = model.setname;
            [imageView addSubview:label];
        }
    }
    JXHRelatePhotoModel *model = self.relatePhotoArray.lastObject;
    CGRect frame1 = CGRectMake(kScreenWidth * self.pictureModelArray.count, (kScreenHeight - 90) / 3, kScreenWidth, (kScreenHeight - 90) / 3);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame1];
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [self.photoBrowerView.imagesScrollView addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [imageView addGestureRecognizer:tap];
    [self.pictures addObject:imageView];
    CGRect frame2 = CGRectMake(0, CGRectGetHeight(imageView.frame) - 30, CGRectGetWidth(imageView.frame), 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame2];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.text = model.setname;
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.alpha = 0.8;
    [imageView addSubview:label];
}


/**
 *  按钮时间处理
 */
-(void)back{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)comment{

}
-(void)share{
    
}
-(void)save{
    
}
/**
 *  手势处理
 */

-(void)tapHandle:(UITapGestureRecognizer *)tap{//点击
    
    if (self.photoBrowerView.tooBarView.frame.origin.y>kScreenHeight) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.photoBrowerView.tooBarView.transform=CGAffineTransformIdentity;
            
            self.photoBrowerView.descriptionView.transform=CGAffineTransformIdentity;
            
            self.photoBrowerView.titleView.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [UIApplication sharedApplication].statusBarHidden=NO;
       
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.photoBrowerView.tooBarView.transform=CGAffineTransformMakeTranslation(0, 180);
            
            self.photoBrowerView.descriptionView.transform=CGAffineTransformMakeTranslation(0, 180);
            
           [UIApplication sharedApplication].statusBarHidden=YES;
            
            self.photoBrowerView.titleView.transform=CGAffineTransformMakeTranslation(0, -80);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void)doubleTapHanle:(UITapGestureRecognizer *)doubleTap{//双击
    
//    NSInteger index = self.photoBrowerView.imagesScrollView.contentOffset.x / kScreenWidth;
//        if (index==self.pictureModelArray.count)return;
//        static BOOL isZooming = NO;
//        if (isZooming) {
//            [self.photoBrowerView.imagesScrollView setZoomScale:1.0 animated:YES];
//        }else{
//            //scrollView.zoomScale = 2.0;
//            [self.photoBrowerView.imagesScrollView  setZoomScale:2.0 animated:YES];
//        }
//        isZooming = !isZooming;
   
}
-(void)longPressHandle:(UILongPressGestureRecognizer *)longPress{//长按
    
    if (longPress.state == UIGestureRecognizerStateBegan||longPress.state==UIGestureRecognizerStateChanged) {
       
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存图片" message:@"您确定要保存吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            NSInteger index = self.photoBrowerView.imagesScrollView.contentOffset.x / kScreenWidth;
            if (index==self.pictureModelArray.count)return;
            UIImageView*imageView=[self.imageViews objectAtIndex:index];
            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//判断图片保存状态
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
     
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:OKAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}



-(void)handleTap:(UITapGestureRecognizer *)tap{

    JXHPhotoBrowerController *pictureVC = [[JXHPhotoBrowerController alloc] init];
    NSUInteger currentIndex = [self.pictures indexOfObject:tap.view];
    JXHRelatePhotoModel *model = self.relatePhotoArray[currentIndex];
    pictureVC.photosID = [self.photosID stringByReplacingOccurrencesOfString:self.secondID withString:model.setid];
    
    [self.navigationController pushViewController:pictureVC animated:YES];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.photoBrowerView.imagesScrollView.contentOffset.x / kScreenWidth;
    
    self.photoBrowerView.titleView.hidden=index>=self.pictureModelArray.count;
    self.photoBrowerView.tooBarView.hidden=index>=self.pictureModelArray.count;
    self.photoBrowerView.descriptionView.hidden=index>=self.pictureModelArray.count;
    
    if (index < self.pictureModelArray.count) {
        PictureModel *model = self.pictureModelArray[index];
        self.photoBrowerView.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, self.pictureModelArray.count];
        self.photoBrowerView.desTextView.text = model.note;
    } else {
        [self setupRelatedImages];
    }
}

//指定那个视图被缩放
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return  [[scrollView subviews] firstObject];
  
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    ((UIImageView *)[[scrollView subviews] firstObject]).center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}


-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
