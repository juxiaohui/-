//
//  JXHVideoViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoListHeaderView.h"
#import "VideoListTableViewCell.h"
#import "VideoListModel.h"
#import "VideoCateTableViewController.h"
#import "ZFPlayerView.h"
#import "FullViewController.h"
#import <Masonry.h>

@interface JXHVideoViewController ()<UITableViewDataSource,UITableViewDelegate,FMGVideoPlayViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *videoListArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong) ZFPlayerView * playView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect selectedRect;
@property (nonatomic,retain)VideoListHeaderView *headerView;
@property (nonatomic,copy)  NSArray *categoryArray;
@property (nonatomic,copy)  NSArray *categoryTitleArray;
@property (nonatomic,strong) VideoListTableViewCell * currentCell;

@property (nonatomic, assign) CGPoint point;


@end

@implementation JXHVideoViewController

//-(ZFPlayerView *)playView{
//    if (!_playView) {
//        _playView=[ZFPlayerView setupZFPlayer];
//    }
//    return _playView;
//}

-(NSArray *)categoryTitleArray{
    if (!_categoryTitleArray) {
        _categoryTitleArray=@[@"奇葩",@"萌物",@"美女",@"精品"];
    }
    return _categoryTitleArray;
}

-(NSArray *)categoryArray{
    if (!_categoryArray) {
        _categoryArray=@[@"VAP4BFE3U",@"VAP4BFR16",@"VAP4BG6DL",@"VAP4BGTVD"];
    }
    return _categoryArray;
}
-(VideoListHeaderView *)headerView{
    if (!_headerView) {
        _headerView=[[[NSBundle mainBundle]loadNibNamed:@"VideoListHeaderView" owner:nil options:nil]lastObject];
    }
    return _headerView;
}

-(NSMutableArray *)videoListArray{
    if (!_videoListArray) {
        _videoListArray=[NSMutableArray array];
    }
    return _videoListArray;
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playView resetPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBaseData];
    [self setupTableView];
    [self setupRefresh];
    [self loadData];
}


-(void)setBaseData{
    self.page=0;
}
-(void)setupTableView{
    
    
     __weak typeof(self) weakSelf = self;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style : UITableViewStylePlain];
   // [self registTabelViewcell];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([VideoListTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoListTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.translucent = NO;
    //self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.tableHeaderView=self.headerView;
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [self.headerView setCategoryBlock:^(NSInteger tag) {
        [weakSelf handleActionWithTag:tag];
    }];
}
//头部按钮点击事件
-(void)handleActionWithTag:(NSInteger )tag{
    
    VideoCateTableViewController *viewController=[[VideoCateTableViewController alloc]init];
    viewController.sid=[self.categoryArray objectAtIndex:tag-1];
    viewController.tname=[self.categoryTitleArray objectAtIndex:tag-1];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)registTabelViewcell{
    
   
}
-(void)setupRefresh{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=0;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page=self.videoListArray.count;
        [weakSelf loadData];
    }];
}
-(void)loadData{
    [VideoListModel getVideoListModelWithPag:self.page completed:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            if (self.page==0) {
                [self.videoListArray removeAllObjects];
                self.videoListArray=modelArray;
            }else{
                [self.videoListArray addObjectsFromArray:modelArray];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.videoListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    VideoListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VideoListTableViewCell" forIndexPath:indexPath];
    
    VideoListModel *model=[self.videoListArray objectAtIndex:indexPath.section];
    
    cell.titleLabel.text=model.title;
    cell.subTitleLabel.text=model.d_escription;
    cell.playButton.hidden=NO;
    [cell.desImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
//    cell.desImageView.userInteractionEnabled=YES;
//    [cell.desImageView addGestureRecognizer:tap];
   
    
    cell.timeLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",[model.length integerValue]/60,[model.length integerValue]%60];
    if ([model.playCount integerValue]>10000) {
        cell.playCountLabel.text=[NSString stringWithFormat:@"%.1f万",[model.playCount integerValue]/10000.0];
    }else{
        cell.playCountLabel.text=[NSString stringWithFormat:@"%@",model.playCount];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
     __block NSIndexPath *weakIndexPath = indexPath;
     __block VideoListTableViewCell *weakCell = cell;
     __weak typeof(self) weakSelf = self;
    cell.playBlock=^{
        weakSelf.playView = [ZFPlayerView playerView];
        NSURL *videoURL = [NSURL URLWithString:model.mp4_url];
        // 设置player相关参数
        [weakSelf.playView setVideoURL:videoURL withTableView:weakSelf.tableView AtIndexPath:weakIndexPath];
        [weakSelf.playView addPlayerToCell:weakCell];
        //[weakCell.desImageView addSubview:weakSelf.playView];
    
    };

    return cell;
}
#pragma mark -
#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108+170*kScreenWidth/320;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)tapHandle:(UITapGestureRecognizer *)tap{
    
    UIView *playerView=tap.view;
    
    VideoListTableViewCell *cell = (VideoListTableViewCell *)playerView.superview.superview;
    
    if (_currentCell) {
        _currentCell.playButton.hidden=NO;
        _currentCell.playerView.hidden=YES;
    }
    
    _currentCell=cell;
    
    self.indexPath=[self.tableView indexPathForCell:cell];
    
    VideoListModel *model=[self.videoListArray objectAtIndex:[self.tableView indexPathForCell:cell].section];
    
    cell.playerView.hidden=NO;
    
    cell.playerView.videoURL=[NSURL URLWithString:model.mp4_url];
    
    cell.playButton.hidden=YES;
    
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentCell&&_currentCell==cell) {
        
       VideoListTableViewCell *cell1= (VideoListTableViewCell *)cell;
        cell1.playButton.hidden=NO;
        cell1.playerView.hidden=YES;

    }
}

//频幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
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
