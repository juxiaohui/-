//
//  CustomPopView.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "CustomPopView.h"
#import "PopHeaderView.h"
#import "ButtonTableViewCell.h"


@interface CustomPopView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UIView *cover;

@property (nonatomic) UIView *topView;

@property (nonatomic) UITableView *tableView;
@end


@implementation CustomPopView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.5;
        cover.frame = CGRectMake(0, -(kScreenHeight-64), kScreenWidth, kScreenHeight-64);
        _cover = cover;
        //[self addSubview:cover];
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        topView.frame = CGRectMake(0, -(kScreenHeight-64), kScreenWidth, kScreenHeight-64);
        _topView=topView;

        [self addSubview:topView];
        
    
        PopHeaderView *headerView=[[[NSBundle mainBundle] loadNibNamed:@"PopHeaderView" owner:self options:nil] lastObject];
        headerView.frame=CGRectMake(0, 0, kScreenWidth, 40);
        [headerView.cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [headerView.sortButton addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        headerView.sortButton.layer.cornerRadius=10;
        headerView.sortButton.layer.masksToBounds=YES;
        headerView.sortButton.layer.borderWidth=1;
        headerView.sortButton.layer.borderColor=[UIColor redColor].CGColor;
        [topView addSubview:headerView];
        UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-64-40)];
        _tableView=tableView;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor whiteColor];
        //_tableView.alpha=0.5;
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _tableView.frame.size.width, 1)];
        [_topView addSubview:_tableView];
    }
    return self;
}




-(void)sort:(UIButton *)button{
    if (button.selected) {
        
       // ButtonTableViewCell *cell = (ButtonTableViewCell *)button.superview.superview;
        
        NSIndexPath *path=[NSIndexPath indexPathForRow:1 inSection:0];
        
        ButtonTableViewCell *cell=[self.tableView cellForRowAtIndexPath:path];
        
        for (UIButton *button in cell.contentView) {
            //_deleteBtn.hidden = NO;
            double (^angle)(double) = ^(double deg) {
                return deg / 180.0 * M_PI;
            };
            CABasicAnimation * ba = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            ba.fromValue = @(angle(-5.0));
            ba.toValue = @(angle(5.0));
            ba.repeatCount = MAXFLOAT;
            ba.duration = 0.1;
            ba.autoreverses = YES;
            [self.layer addAnimation:ba forKey:nil];
        }
       
        
        
        
        //ButtonTableViewCell *cell=[self.tableVie]
        
    }else{
    
    }
    button.selected=!button.selected;
}
-(void)cancle{
    [self hidden];

}
-(void)show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _cover.frame= CGRectMake(0, 0 , kScreenWidth, kScreenHeight-64);
        _topView.frame = CGRectMake(0, 0 , kScreenWidth, kScreenHeight-64);
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.5 animations:^{
        _cover.frame= CGRectMake(0, -(kScreenHeight-64) ,kScreenWidth, kScreenHeight-64);
        _topView.frame = CGRectMake(0, -(kScreenHeight-64) ,kScreenWidth, kScreenHeight-64);
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor=[UIColor lightGrayColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-10, 20)];
    label.text=@"点击添加更多栏目";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentLeft;
    [view addSubview:label];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ButtonTableViewCell *cell=[[ButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonTableViewCell"];
    
    
    if (indexPath.section==0) {
        
        cell.dataArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"];
    
    }else{
                
        NSMutableArray *arr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"all"]];
    
        [arr removeObjectsInArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"]];

        cell.dataArray=arr;
                
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.0;
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array=[NSArray array];
    if (indexPath.section==0) {
        array=[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"];
    }else{
        NSMutableArray *arr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"all"]];
        [arr removeObjectsInArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"yet"]];
        array=arr;
    }
    CGFloat btnW=(kScreenWidth-75)/4.0;
    
    CGFloat btnH=btnW/2.5;
    
    CGFloat padding=15.0;
    
    int a = (int)array.count;
    
    int b = a/4;
    int c = a%4;
    
    if (!c) {
        return btnH*b+padding*(b+1);
    }else{
        return btnH*(b+1)+padding*(b+1+1);
    }
}
@end
