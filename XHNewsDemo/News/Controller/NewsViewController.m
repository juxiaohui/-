//
//  NewsViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsListModel.h"
#import "NewsTableViewCell1.h"
#import "NewsTableViewCell2.h"
#import "SDCycleScrollView.h"
#import "WebViewController.h"
#import "PictureModel.h"
#import "VideoCateTableViewController.h"
#import "JXHPhotoBrowerController.h"

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,MWPhotoBrowserDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray *newsListArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic, retain)NSMutableArray *imageArray;

@property(nonatomic, retain)NSMutableArray *photos;

@property(nonatomic, retain)NSMutableArray *dataSource;

@property(nonatomic, retain)NSMutableArray *source;

@property(nonatomic, retain)NSMutableArray *contentArray;

@property(nonatomic, retain)NSMutableArray *pictureArray;



@end

@implementation NewsViewController


-(NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray=[NSMutableArray array];
    }
    return _contentArray;

}

-(NSMutableArray *)newsListArray{
    if (!_newsListArray) {
        _newsListArray=[NSMutableArray array];
    }
    return _newsListArray;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource ;
}

-(NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray=[NSMutableArray array];
    }
    return _pictureArray;
    
}
- (NSMutableArray *)source {
    if (!_source) {
        self.source = [NSMutableArray arrayWithCapacity:1];
    }
    return _source;
}


-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.97) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor];
        
        cycleScrollView2.delegate = self;
        if (self.newsListArray.count>0) {
            NewsListModel *model=[self.newsListArray objectAtIndex:0];
            
            NSMutableArray *imgUrlArray=[NSMutableArray array];
            
            NSMutableArray *titleArray=[NSMutableArray array];
            
            if (model.ads.count>0) {
                for (NSDictionary *dic in model.ads) {
                    [imgUrlArray addObject:dic[@"imgsrc"]];
                    [titleArray addObject:dic[@"title"]];
                }
                cycleScrollView2.titlesGroup=titleArray;
                cycleScrollView2.imageURLStringsGroup=imgUrlArray;
                self.pictureArray=imgUrlArray;
                
                return cycleScrollView2;
            }else{
                [imgUrlArray addObject:model.imgsrc];
                [titleArray addObject:model.title];
                cycleScrollView2.titlesGroup=titleArray;
                cycleScrollView2.imageURLStringsGroup=imgUrlArray;
                self.pictureArray=imgUrlArray;
                return cycleScrollView2;
            }
        }
    }
    return _cycleScrollView;
}


-(NSString *)tid{
    if (!_tid) {
        _tid=[[NSUserDefaults standardUserDefaults] valueForKey:self.tname];
    }
    return _tid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseData];
    
    [self setUpTableView];
    
    [self setupRefresh];
    
    [self loadData];
    
    
    self.view.backgroundColor=RGBColor(arc4random()%255, arc4random()%255, arc4random()%255);

}
-(void)setBaseData{

    self.page=0;
    self.title=self.tname;

}
-(void)setUpTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 )];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    //[self setTableHeaderView];
    
    [self registTabelViewcell];
}

-(void)setTableHeaderView{
    
    self.tableView.tableHeaderView=self.cycleScrollView;
}
-(void)registTabelViewcell{
    
    UINib *nib1 = [UINib nibWithNibName:@"NewsTableViewCell1" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"NewsTableViewCell1"];
    
    UINib *nib2 = [UINib nibWithNibName:@"NewsTableViewCell2" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"NewsTableViewCell2"];
}

- (void)setupRefresh
{
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=0;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page+=20;
        [weakSelf loadData];
    }];
}

-(void)loadData{
    [NewsListModel getNewsListModelWithCid:self.tid andPag:self.page completed:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            if (self.page==0) {
                [self.newsListArray removeAllObjects];
                self.newsListArray=modelArray;
            }else{
                [self.newsListArray addObjectsFromArray:modelArray];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self setTableHeaderView];
            
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        if(modelArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark -
#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsListArray.count-1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsListModel *model=[self.newsListArray objectAtIndex:indexPath.row+1];
    
    
    if (model.imgextra.count>0) {
        NewsTableViewCell2 *cell=[tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell2" forIndexPath:indexPath];
        cell.titleLable.text=model.title;
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
        [cell.minImageView sd_setImageWithURL:[NSURL URLWithString:[model.imgextra objectAtIndex:0][@"imgsrc"]]];
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model.imgextra objectAtIndex:1][@"imgsrc"]]];
        return cell;
        
    }else {
        NewsTableViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell1" forIndexPath:indexPath];
        if (model.title) {
            cell.title.text=model.title;
        }
        if (model.digest) {
            cell.subtitle.text=model.digest;
        }
        [cell.img sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        return cell;
    }
}
#pragma mark -
#pragma mark -UITableViewDelegate


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // 网络加载 --- 创建带标题的图片轮播器
       return nil;
    
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return kScreenWidth/1.97;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     NewsListModel *model=[self.newsListArray objectAtIndex:indexPath.row+1];
    
    if (model.imgextra.count>0) {
        return 21+8+8+8+(kScreenWidth-8-8-10)/3.0/1.33;
        
    }else{
        return 83;
    }
    return kScreenHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     NewsListModel *model=[self.newsListArray objectAtIndex:indexPath.row+1];
    
    if (model.photosetID) {
        
        JXHPhotoBrowerController *photoBrowerVC=[[JXHPhotoBrowerController alloc]init];
        
        photoBrowerVC.hidesBottomBarWhenPushed=YES;
        
        photoBrowerVC.photosID=model.photosetID;
        
        [self.navigationController pushViewController:photoBrowerVC animated:YES];
        
        
        
//        NSString *str1 = [model.photosetID substringWithRange:NSMakeRange(4, 4)];
//        NSString *str2 = [model.photosetID substringFromIndex:9];
//        [[JXHNetEngine sharedInstance] requestDataFromNet:[NSString stringWithFormat:PhotoURL,str1,str2] success:^(id responsData) {
//            NSDictionary *recvDic = (NSDictionary *)responsData;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.dataSource removeAllObjects];
//                for (NSDictionary *dic in recvDic[@"photos"]) {
//                    PictureModel *model=[[PictureModel alloc]init];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [self.dataSource addObject:model];
//                }
//                [self setUpPhotoBrower];
//            });
//            
//        } falied:^(NSError *error) {
//    }];
  }
//        else if (model.videoID){
//        
//        VideoCateTableViewController *viewController=[[VideoCateTableViewController alloc]init];
//        viewController.sid=model.videoID;
//        
//        viewController.tname=model.title;
//        
//        [self.navigationController pushViewController:viewController animated:YES];
//    
//    }
        else{
        WebViewController *viewComntroller=[[WebViewController alloc]init];
        viewComntroller.webStr=model.docid;
        viewComntroller.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewComntroller animated:YES];
    }
}
-(void)setUpPhotoBrower{
    
    MWPhoto *photo  = nil;
    
    NSMutableArray *photos = [NSMutableArray array];
    
    NSMutableArray *title = [NSMutableArray array];
    
    for (PictureModel *model in self.dataSource) {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:model.imgurl]];
        
        [photos addObject:photo];
        
        [title addObject:model.note];
    }
    self.photos = photos;
    self.contentArray=title;
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = YES;
    photoBrowser.displayNavArrows = YES;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableSwipeToDismiss = YES;
    photoBrowser.hidesBottomBarWhenPushed = YES;
    [photoBrowser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}
#pragma mark -
#pragma mark -MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    JXHPhotoBrowerController *photoBrower = [[JXHPhotoBrowerController alloc] init];
//    
//    //NSUInteger currentIndex = [self.imagePlayer.imageArr indexOfObject:gesture.view];
//    
//    photoBrower.photosID=self.pictureArray[index];
//    
////    detailVC.data = self.urls[currentIndex];
////    detailVC.data3 = self.headlines[currentIndex - 1];
//    photoBrower.hidesBottomBarWhenPushed=YES;
//    
//    [self.navigationController pushViewController:photoBrower animated:YES];

    
    
    
    
    MWPhoto *photo  = nil;
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSString  *str in self.pictureArray) {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [photos addObject:photo];
    }

    self.photos = photos;
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = YES;
    photoBrowser.displayNavArrows = YES;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableSwipeToDismiss = YES;
    photoBrowser.hidesBottomBarWhenPushed = YES;
    [photoBrowser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:photoBrowser animated:YES];
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
