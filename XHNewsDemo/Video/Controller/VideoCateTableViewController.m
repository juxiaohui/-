//
//  VideoCateTableViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/15.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "VideoCateTableViewController.h"
#import "VideoListModel.h"
#import "VideoListTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface VideoCateTableViewController ()
@property (nonatomic,retain)NSMutableArray *videoListArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect selectedRect;
@property (nonatomic,strong) VideoListTableViewCell * currentCell;

@end

@implementation VideoCateTableViewController

-(NSMutableArray *)videoListArray{
    if (!_videoListArray) {
        _videoListArray=[NSMutableArray array];
    }
    return _videoListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseData];
    [self registTabelViewcell];
    [self setupRefresh];
    [self loadData];
   
}
-(void)setBaseData{
    self.page=0;
    self.title=self.tname;
    self.tableView.tableFooterView=[[UIView alloc]init];

}
-(void)registTabelViewcell{
    
    UINib *nib = [UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoListTableViewCell"];
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
    
    
    [VideoListModel getVideoListModelWithPag:self.page andSid:self.sid completed:^(NSMutableArray *modelArray, BOOL success) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.videoListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VideoListTableViewCell" forIndexPath:indexPath];
    VideoListModel *model=[self.videoListArray objectAtIndex:indexPath.section];
    cell.titleLabel.text=model.title;
    cell.subTitleLabel.text=model.d_escription;
    [cell.desImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
    cell.desImageView.userInteractionEnabled=YES;
    [cell.desImageView addGestureRecognizer:tap];
    
    cell.timeLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",[model.length integerValue]/60,[model.length integerValue]%60];
    if ([model.playCount integerValue]>10000) {
        cell.playCountLabel.text=[NSString stringWithFormat:@"%.1f万",[model.playCount integerValue]/10000.0];
    }else{
        cell.playCountLabel.text=[NSString stringWithFormat:@"%@",model.playCount];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
