//
//  RadioPlayViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "RadioPlayModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "UIImage+borderImage.h"
#import <AVFoundation/AVFoundation.h>
//#import "JXHAudioTool.h"
#import "CALayer+JXHPauseAimate.h"


@interface RadioPlayViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *anmationImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,retain) NSMutableArray *radioListArray;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,copy)   NSString *playURL;


//定时器
@property (nonatomic,strong) NSTimer * progressTimer;
//远程播放器
@property (nonatomic, strong) AVPlayer *player;



@end

@implementation RadioPlayViewController

//懒加载
-(AVPlayer *)player{
    if (!_player) {
        
        AVPlayerItem *item=[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];

        _player=[[AVPlayer alloc]initWithPlayerItem:item];
    }
    return _player;
}

-(NSMutableArray *)radioListArray{
    if (!_radioListArray) {
        _radioListArray=[NSMutableArray array];
    }
    return _radioListArray;
}

#pragma mark -  控制器的View将要布局子视图
/**
 *  控制器的View将要布局子视图，此时能得到子视图的真实大小
 */
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.anmationImageView.layer.masksToBounds=YES;
    self.anmationImageView.layer.cornerRadius=self.anmationImageView.frame.size.width*0.5;
    self.anmationImageView.layer.borderWidth=5;
    self.anmationImageView.layer.borderColor=RGBColor(36, 36, 36).CGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseData];
    [self setupRefresh];
}
-(void)setBaseData{
    self.page=0;
    self.currentIndex = 0;
    self.title=self.tname;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self.slider setThumbImage:[UIImage imageNamed:@"player_thumb"] forState:UIControlStateNormal];
}
-(void)setupRefresh{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=0;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page=self.radioListArray.count;
        [weakSelf loadData];
    }];
}

#pragma mark -
#pragma mark -获取网络数据

-(void)loadData{
    
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"加载中" toView:self.view];
    [RadioPlayModel getRadioPlayModelWithCid:self.tid andPag:self.page completed:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            if (self.page==0) {
                [self.radioListArray removeAllObjects];
                self.radioListArray=modelArray;
            }else{
                [self.radioListArray addObjectsFromArray:modelArray];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            [hud hide:YES];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [hud hide:YES];
        }
        
        if(modelArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self requestRadioURL];
    }];
}
#pragma mark -
#pragma mark -获取播放数据库
-(void)requestRadioURL{
    
    //默认播放第一首歌曲
    RadioPlayModel *model = self.radioListArray[_currentIndex];
    
    if (![model.imgsrc  hasPrefix:@"http://"]) {

        self.anmationImageView.image=[UIImage imageNamed:@"audionews_play_bg"];
    }else{

       [self.anmationImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
    }
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:[NSString stringWithFormat:RadioURL, model.docid] success:^(id responsData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *recvDic = (NSDictionary *)responsData;
            if (recvDic[model.docid]) {
                NSDictionary *dic = recvDic[model.docid];
                [self getURLWithObject:dic];
                self.playButton.selected=YES;
            } else {
                
            }
        });
        
    } falied:^(NSError *error) {
        
    }];
}

-(NSString *)stringWithTime:(NSTimeInterval)time{
    
    NSInteger min=time/60;
    
    NSInteger second=(NSInteger)time%60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",min,second];
}

-(void)getURLWithObject:(NSDictionary *)dic{
    
    NSDictionary *urlDic=[dic[@"video"] lastObject];
    self.playURL=urlDic[@"url_mp4"];
    AVPlayerItem *item=[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.playURL]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
    self.currentTimeLabel.text=[self stringWithTime:CMTimeGetSeconds(self.player.currentTime)];
    
    //此时获取的时长是不可靠的。
    //self.totalTimeLabel.text=[self stringWithTime:CMTimeGetSeconds(self.player.currentItem.duration)];
    //KVO监测音频的加载状态，加载完成才能回去音频的总时长。
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    //NSLog(@"%f_________",CMTimeGetSeconds(self.player.currentItem.duration));
    //开始动画
    [self startAnimation];
    //添加定时器
    [self removeProgressTimer];
    
    [self addProgressTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.tableView reloadData];
}

-(void)startAnimation{
    CABasicAnimation  *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //旋转的是弧度
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue   = @(M_PI*2);
    rotationAnimation.duration  = 30;
    rotationAnimation.repeatCount = MAXFLOAT;
    //这里指定一个key的目的是方便找到该动画
    [self.anmationImageView.layer addAnimation:rotationAnimation forKey:@"playMusic"];
}

#pragma mark - 定时器

-(void)addProgressTimer{
    
    //手动更新进度，防止开始进度错误
    [self updateProgress];
    self.progressTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    
}
-(void)removeProgressTimer{
    
    [self.progressTimer invalidate];
    self.progressTimer=nil;
}
#pragma mark - 更新进度

-(void)updateProgress{
    
    self.currentTimeLabel.text=[self stringWithTime:CMTimeGetSeconds(self.player.currentTime)];
    
    self.slider.value=CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);;
}


- (NSURL *)getNetURL {
    
    NSString *newURL = [self.playURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:newURL];
}

#pragma mark - 滑块事件处理

- (IBAction)sliderClick:(id)sender {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange:(id)sender {
    
    
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.slider.value;
    
    NSLog(@"%f",CMTimeGetSeconds(self.player.currentItem.duration));
    
    self.currentTimeLabel.text=[self stringWithTime: currentTime];

}

- (IBAction)endSlider:(id)sender {

    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.slider.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

    [self.player play];
    
    [self addProgressTimer];
}

#pragma mark - 手势

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    
    CGPoint point=[sender locationInView:sender.view];
    
    CGFloat raton=point.x/self.slider.frame.size.width;
    
    NSTimeInterval currentTime=raton* CMTimeGetSeconds(self.player.currentItem.duration);
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    
    [self updateProgress];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if ([change[@"new"] integerValue]==AVPlayerItemStatusReadyToPlay) {
            
            self.totalTimeLabel.text=[self stringWithTime:CMTimeGetSeconds(self.player.currentItem.duration)];
        }
    }
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
}

#pragma mark - 播放器按钮触发事件

- (void)playRadio:(UIButton *)sender {
    
    if (self.radioListArray.count) {
        
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            [self.player play];
            [self.anmationImageView.layer resumeAnimate];
            [self addProgressTimer];
        } else {
            [self.player pause];
            [self.anmationImageView.layer pauseAnimate];
            [self removeProgressTimer];
        }
    }
}

- (void)lastOne {
    if (_currentIndex > 0) {
        _currentIndex -= 1;
        [self requestRadioURL];
    }
}

- (void)nextOne {
    if (_currentIndex < self.radioListArray.count - 1) {
        _currentIndex += 1;
        [self requestRadioURL];
    }
}
/**
 *   监听播放完成的通知
 */
- (void)mediaPlayerPlaybackFinished:(NSNotificationCenter *)notification {
    
    if (_currentIndex < self.radioListArray.count - 1) {
        _currentIndex += 1;
        [self requestRadioURL];
    } else {
        self.playButton.selected = NO;
    }
}

- (IBAction)buttonClick:(UIButton *)sender {
   
    if (sender.tag==100) {
        [self lastOne];
    }else if (sender.tag==200){
        [self playRadio:sender];
    }else{
        [self nextOne];
    }
}

#pragma mark -
#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.radioListArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
    }
    RadioPlayModel *model=[self.radioListArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.title;
    cell.detailTextLabel.text=model.ptime;
    NSIndexPath *Path = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    if (indexPath == Path) {
        cell.textLabel.highlighted = YES;
    }
    return cell;
}
#pragma mark -
#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _currentIndex = indexPath.row;
    [self requestRadioURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
- (IBAction)backButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden=NO;
}


-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
