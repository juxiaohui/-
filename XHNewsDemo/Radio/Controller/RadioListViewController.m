//
//  RadioListViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "RadioListViewController.h"
#import "RadioScanModel.h"
#import "RadioScanTableViewCell.h"
#import "RadioPlayViewController.h"
@interface RadioListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray *radioScanListArray;

@end

@implementation RadioListViewController


-(NSMutableArray *)radioScanListArray{
    if (!_radioScanListArray) {
        _radioScanListArray=[NSMutableArray array];
    }
    return _radioScanListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseData];
    [self setupTableView];
    [self setupRefresh];
    [self loadData];
}
-(void)setBaseData{
    self.title=self.cname;
    self.page=0;
}
-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 ) style : UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    [self registTabelViewcell];
}

-(void)registTabelViewcell{

    UINib *nib = [UINib nibWithNibName:@"RadioScanTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RadioScanTableViewCell"];
}
-(void)setupRefresh{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=0;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page=self.radioScanListArray.count;
        [weakSelf loadData];
    }];
}

-(void)loadData{
    [RadioScanModel getRadiolScanModelWithCid:self.cid andPag:self.page completed:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            if (self.page==0) {
                [self.radioScanListArray removeAllObjects];
                self.radioScanListArray=modelArray;
            }else{
                [self.radioScanListArray addObjectsFromArray:modelArray];
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
    return self.radioScanListArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioScanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RadioScanTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    RadioScanModel *model=[self.radioScanListArray objectAtIndex:indexPath.row];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.radio[@"imgsrc"]]];
    cell.titleImageView.layer.masksToBounds=YES;
    cell.titleImageView.layer.cornerRadius=37.0f;
    
    cell.nameLabel.text=model.tname;
    cell.titleLabel.text=model.radio[@"title"];
    cell.palyCountLabel.text=[NSString stringWithFormat:@"收听%@",model.playCount];
    return cell;
}
#pragma mark -
#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RadioScanModel *model=[self.radioScanListArray objectAtIndex:indexPath.row];
    RadioPlayViewController *VC=[[RadioPlayViewController alloc]init];
    VC.hidesBottomBarWhenPushed=YES;
    VC.tid=model.tid;
    [self.navigationController pushViewController:VC animated:YES];
    
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
