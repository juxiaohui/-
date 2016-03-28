//
//  JXHRadioViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHRadioViewController.h"
#import "RadioListModel.h"
#import "RadioListTableViewCell.h"
#import "RadioListViewController.h"
#import "RadioPlayViewController.h"
#import "JXHtListModel.h"

@interface JXHRadioViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *radioListArray;

@end

@implementation JXHRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setupRefresh];
    [self loadData];
}
-(void)setUpTableView{
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style : UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self registTabelViewcell];
}

-(void)registTabelViewcell{
    
    UINib *nib = [UINib nibWithNibName:@"RadioListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RadioListTableViewCell"];
}

- (void)setupRefresh
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    //[self.tableView.mj_header beginRefreshing];
}


-(void)loadData{
    
    MBProgressHUD *hud=[MBProgressHUD showMessage:@"加载中" toView:self.view];
    
    [RadioListModel getRadiolListModel:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            
            [self.tableView.mj_header endRefreshing];
            
            self.radioListArray=modelArray;
            
            [self.tableView reloadData];
            [hud hide:YES];
            
        }else{
            [self.tableView.mj_header endRefreshing];
            [hud hide:YES];
        }
    }];
}

#pragma mark -
#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.radioListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RadioListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RadioListTableViewCell" forIndexPath:indexPath];
    RadioListModel *model=[self.radioListArray objectAtIndex:indexPath.section];
    cell.titleLabel.text=model.cname;
    
    if (model.tList) {
        JXHtListModel *model1 =[model.tList objectAtIndex:0];
        cell.titleLable1.text=model1.tname;
        cell.button1.layer.masksToBounds=YES;
        cell.button1.layer.cornerRadius=((kScreenWidth-30)/3.0)/2;
        cell.deslabel1.text=model1.title;
        cell.img.layer.masksToBounds=YES;
        cell.img.layer.cornerRadius=12.0f;

        if (![[model1.imgsrc absoluteString] hasPrefix:@"http://"]) {
            [cell.button1 setBackgroundImage:[UIImage imageNamed:@"audio_block_bg"] forState:UIControlStateNormal];
            cell.img.image=[UIImage imageNamed:@"audio_block_bg"];
        }else{
         [cell.button1 sd_setBackgroundImageWithURL:model1.imgsrc forState:UIControlStateNormal];
         [cell.img sd_setImageWithURL:model1.imgsrc];
  
        }
        
        [cell setButtonClick:^(NSInteger tag) {
            [self handleButtonClickWithTag:tag andInfo:model];
        }];
        
        JXHtListModel *model2 =[model.tList objectAtIndex:1];
        cell.titleLabel2.text=model2.tname;
        [cell.button2 sd_setBackgroundImageWithURL:model2.imgsrc forState:UIControlStateNormal];
        cell.button2.layer.masksToBounds=YES;
        cell.button2.layer.cornerRadius=((kScreenWidth-30)/3.0)/2;
        cell.desLabel2.text=model2.title;
        
        JXHtListModel *model3 =[model.tList objectAtIndex:2];
        cell.titleLabel3.text=model3.tname;
        [cell.button3 sd_setBackgroundImageWithURL:model3.imgsrc forState:UIControlStateNormal];
        cell.button3.layer.masksToBounds=YES;
        cell.button3.layer.cornerRadius=((kScreenWidth-30)/3.0)/2;
        cell.desLabel3.text=model3.title;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;

}
//点击事件处理
-(void)handleButtonClickWithTag:(NSInteger )tag andInfo:(RadioListModel *)model{
    
    RadioPlayViewController *VC=[[RadioPlayViewController alloc]init];
    VC.hidesBottomBarWhenPushed=YES;
    
    if (tag==100) {
        RadioListViewController *listVC=[[RadioListViewController alloc]init];
        listVC.cid=model.cid;
        listVC.cname=model.cname;
        listVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:listVC animated:YES];
    
    }else{
        if (tag==200){
             VC.tid=[[model.tList objectAtIndex:0] tid];
             VC.tname=[[model.tList objectAtIndex:0] tname];
        }else if (tag==300){
             VC.tid=[[model.tList objectAtIndex:1] tid];
             VC.tname=[[model.tList objectAtIndex:1] tname];
        }else{
             VC.tid=[[model.tList objectAtIndex:2] tid];
             VC.tname=[[model.tList objectAtIndex:2] tname];
        }
         [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark -
#pragma mark -UITableVieDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200 *(kScreenWidth/320);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

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
