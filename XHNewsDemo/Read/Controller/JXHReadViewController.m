//
//  JXHReadViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHReadViewController.h"
#import "ReadListModel.h"
#import "ReadNormalTableViewCell.h"
#import "ReadpicOneTableViewCell.h"
#import "ReadOneTwoTableViewCell.h"
#import "ReadTwoOneTableViewCell.h"
#import "WebViewController.h"
@interface JXHReadViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *readListArray;
@property(nonatomic,assign)NSInteger size;


@end

@implementation JXHReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseData];
    [self setUpTableView];
    [self setupRefresh];
    [self loadData];
}


-(void)setBaseData{
    self.size=20;

}
-(void)setUpTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 ) style : UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.translucent = NO;
    [self registTabelViewcell];
}

-(void)registTabelViewcell{
    
    UINib *nib1 = [UINib nibWithNibName:@"ReadNormalTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"ReadNormalTableViewCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"ReadpicOneTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"ReadpicOneTableViewCell"];
    
    UINib *nib3 = [UINib nibWithNibName:@"ReadOneTwoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"ReadOneTwoTableViewCell"];
    
    UINib *nib4 = [UINib nibWithNibName:@"ReadTwoOneTableViewCell" bundle:nil];
    [self.tableView registerNib:nib4 forCellReuseIdentifier:@"ReadTwoOneTableViewCell"];
}

- (void)setupRefresh
{
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.size=20;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.size=10;
        [weakSelf loadData];
    }];


}


-(void)loadData{
    
//    hud=[[MBProgressHUD alloc]initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:hud];
//    
//    hud.labelText=@"加载中...";
    //[hud show:YES];
    
    [ReadListModel getReadListModelWithSize:self.size completed:^(NSMutableArray *modelArray, BOOL success) {
        if (success) {
            if (self.size==20) {
                [self.readListArray removeAllObjects];
                self.readListArray=modelArray;
            }else{
                [self.readListArray addObjectsFromArray:modelArray];
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
    return self.readListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ReadListModel *model=[self.readListArray objectAtIndex:indexPath.section];
    
    if ([model.t_emplate isEqualToString:@"normal"]) {
        ReadNormalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReadNormalTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text=model.title;
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.sourceLabel.text=model.source;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([model.t_emplate isEqualToString:@"pic1"]){
        ReadpicOneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReadpicOneTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text=model.title;
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.sourceLabel.text=model.source;

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([model.t_emplate isEqualToString:@"pic31"]){
        ReadOneTwoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReadOneTwoTableViewCell" forIndexPath:indexPath];
    
        cell.titleLabel.text=model.title;
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.sourceLabel.text=model.source;
        [cell.bgImageView1 sd_setImageWithURL:[NSURL URLWithString:[model.imgnewextra objectAtIndex:0][@"imgsrc"]]];
        [cell.bgImageView2 sd_setImageWithURL:[NSURL URLWithString:[model.imgnewextra objectAtIndex:1][@"imgsrc"]]];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([model.t_emplate isEqualToString:@"pic32"]){
        ReadTwoOneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ReadTwoOneTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text=model.title;
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.sourceLabel.text=model.source;
        [cell.bgImageView1 sd_setImageWithURL:[NSURL URLWithString:[model.imgnewextra objectAtIndex:0][@"imgsrc"]]];
        [cell.bgImageView2 sd_setImageWithURL:[NSURL URLWithString:[model.imgnewextra objectAtIndex:1][@"imgsrc"]]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenHeight)];
    
    return cell;
}
#pragma mark -
#pragma mark -UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadListModel *model=[self.readListArray objectAtIndex:indexPath.section];
    
    if ([model.t_emplate isEqualToString:@"normal"]) {
        return 105;
    }else{
        
    CGRect rect = [model.title boundingRectWithSize:CGSizeMake(kScreenWidth-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
       
        return rect.size.height+21+8+8+8+8+180*(kScreenWidth-16)/304;
     
//        return 21+21+8+8+8+8+180*(kScreenWidth-16)/304;
//    }else if ([model.t_emplate isEqualToString:@"pic31"]){
//        return  21+21+8+8+8+8+180*(kScreenWidth-16)/304;;
//    }else if ([model.t_emplate isEqualToString:@"pic32"]){
//        return 21+21+8+8+8+8+180*(kScreenWidth-16)/304;;
    }
    return kScreenHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     ReadListModel *model=[self.readListArray objectAtIndex:indexPath.section];
    WebViewController *viewComntroller=[[WebViewController alloc]init];
    viewComntroller.webStr=model.docid;
    viewComntroller.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewComntroller animated:YES];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{


}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
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
