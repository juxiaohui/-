//
//  JXHNewsViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHNewsViewController.h"
#import "JXHSwitchTitleView.h"
#import "NewsViewController.h"
#import "TitleModel.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"

@interface JXHNewsViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) BYListBar *listBar;

@property (nonatomic,strong) BYDeleteBar *deleteBar;

@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;

@property (nonatomic,retain) NSMutableArray *titleArray;

@property (nonatomic,retain) NSMutableArray *listArray;

@property (nonatomic,assign) NSInteger flag;

@property (nonatomic,retain) NSMutableArray *modelArray;



@end

@implementation JXHNewsViewController



-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        
    _titleArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"]];
    }
    return _titleArray;
}

-(NSMutableArray *)listArray{
    if (!_listArray) {
        
        NSMutableArray *arr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"all"]];
        [arr removeObjectsInArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"]];
        _listArray=arr;
    }
    return _listArray;
}


-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseData];
    
    [self setNavgationBar];
    
    [self loadTitleData];
    
    [self makeContent];
}
-(void)setBaseData{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)setNavgationBar{
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_navi_bell_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"titleView"]];
    ;
    self.navigationItem.titleView=imageView;
    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
//    self.navigationItem.rightBarButtonItem=rightItem;

}

-(void)leftItemClick:(UIBarButtonItem *)item{

}
-(void)rightItemClick:(UIBarButtonItem *)item{
    
}

-(void)loadTitleData{
    
    [TitleModel getNewsTitleModelCompleted:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (int i=0; i<modelArray.count; i++) {
                    TitleModel *model=[modelArray objectAtIndex:i];
                    [[NSUserDefaults standardUserDefaults] setValue:model.tid  forKey:model.tname];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                NSMutableArray *arr0=[NSMutableArray array];
                for (int i=0; i<modelArray.count; i++) {
                    TitleModel *model=[modelArray objectAtIndex:i];
                    [arr0 addObject:model.tname];
                }
                [[NSUserDefaults standardUserDefaults] setObject:arr0 forKey:@"all"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableArray *arr=[NSMutableArray array];
                
                if (! [[NSUserDefaults standardUserDefaults] objectForKey:@"yet"]) {
                    for (int i=0; i<20; i++) {
                        TitleModel *model=[modelArray objectAtIndex:i];
                        [arr addObject:model.tname];
                    }
                    for (int i=0; i<arr.count; i++) {
                        NSString *str=[arr objectAtIndex:i];
                        if ([str isEqualToString:@"头条"]) {
                            [arr exchangeObjectAtIndex:0 withObjectAtIndex:i];
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"yet"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            });
        }
    }];
}
-(void)makeContent
{
    NSMutableArray *listTop = self.titleArray;
    NSMutableArray *listBottom = self.listArray;
    
    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, 30-kScreenHeight, kScreenWidth, kScreenHeight-30-49)];
        
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop,listBottom, nil];
        
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    //顶部滚动的Scrollview
    
    if (!self.listBar) {

        if (listTop) {
            self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            self.listBar.visibleItemList = listTop;
            self.listBar.arrowChange = ^(){
                if (unself.arrow.arrowBtnClick) {
                    unself.arrow.arrowBtnClick();
                }
            };
            self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
                [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
                //添加scrollview
                
                //移动到该位置
                unself.mainScroller.contentOffset =  CGPointMake(itemIndex * kScreenWidth, 0);
            };
            [self.view addSubview:self.listBar];
        }
    }
    
    //上面的View
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    //弹出和隐藏视图的Button
    
    if (!self.arrow) {
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenWidth-40, 0, 40, 30)];
        self.arrow.arrowBtnClick = ^(){
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:0.8 animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenHeight):CGAffineTransformMakeTranslation(0, -kScreenHeight);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth , kScreenHeight-30-64-49)];
        self.mainScroller.backgroundColor = [UIColor yellowColor];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        
       
        
        NSMutableArray *arr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"]];
        
        self.mainScroller.contentSize = CGSizeMake(kScreenWidth*(arr.count),kScreenHeight-30-64-49);
        [self.view insertSubview:self.mainScroller atIndex:0];
        
        for (int i=0;i< arr.count; i++) {
            
            [self addScrollViewWithItemName:arr[i] index:i];

        }
    }
}

-(void)addScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index{
    
    
    NewsViewController *VC=[[NewsViewController alloc]init];
    
    VC.tname=itemName;
    
    VC.view.frame =CGRectMake(index * kScreenWidth , 0, kScreenWidth, kScreenHeight);

    [self.mainScroller addSubview:VC.view];
    
    [self addChildViewController:VC];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
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
