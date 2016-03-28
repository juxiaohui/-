//
//  WebViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "WebViewController.h"
#import "ReadDetailModel.h"
#import <WebKit/WebKit.h>
#import "RelateNewsModel.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>
#import "JXHNewsContentModel.h"

@interface WebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>


@property(nonatomic,retain)MBProgressHUD *HUD;
@property(nonatomic)UIWebView *webView;
@property(nonatomic,retain)ReadDetailModel *readModel;
@property (nonatomic,strong) JXHNewsContentModel * model;
@property(nonatomic,retain)NSMutableArray *realateArray;
@property (nonatomic,strong) NSMutableDictionary* modelDic;
@property (nonatomic,strong) NJKWebViewProgress * progress;
@property (nonatomic,strong) NJKWebViewProgressView * progressView;
@end

@implementation WebViewController


-(NSMutableDictionary *)modelDic{
    if (!_modelDic) {
        _modelDic=[NSMutableDictionary dictionary];
    }
    return _modelDic;
}

-(NSMutableArray *)realateArray{
    if (!_realateArray) {
        _realateArray=[NSMutableArray array];
    }
    return _realateArray;
}

-(NJKWebViewProgress *)progress{
    if (!_progress) {
        _progress=[[NJKWebViewProgress alloc]init];
    }
    return _progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self requestWebData];
}

-(void)requestWebData{

//    [JXHNewsContentModel getNewsContentsModelWithId:self.webStr completed:^(JXHNewsContentModel *model, BOOL success) {
//        if (success) {
//            self.model=model;
//            
//            
//            
//        }
//        
//    }];

    NSString *url=[NSString stringWithFormat:NewsDetail,self.webStr];
    
    [[JXHNetEngine sharedInstance] requestDataFromNet:url success:^(id responsData) {
        
        NSDictionary *recvDic = (NSDictionary *)responsData;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recvDic[self.webStr]) {
                self.modelDic=recvDic[self.webStr];
                
                NSArray *imageArray = self.modelDic[@"img"];
                NSString *content = self.modelDic[@"body"];
                NSArray *relateArray = self.modelDic[@"relative_sys"];
                
                for (NSDictionary *dic in relateArray) {
                    RelateNewsModel *model=[[RelateNewsModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.realateArray addObject:model];
                }
                
                
                for (int i = 0; i < imageArray.count; i++) {
                    
                    NSString *img = [NSString stringWithFormat:@"<!--IMG#%d-->", i];
                    
                    NSString *imgHtml = [NSString stringWithFormat:@"<p style=\"text-align:center\"><img src=\"%@\" /></p>", imageArray[i][@"src"]];
                    
                    content = [content stringByReplacingOccurrencesOfString:img withString:imgHtml];
                }
                    NSArray *videoArray = self.modelDic[@"video"];
                    for (int i = 0; i < videoArray.count; i++) {
                        NSString *video = [NSString stringWithFormat:@"<!--VIDEO#%d-->", i];
                        NSString *str = videoArray[i][@"url_mp4"];
                        NSString *videoHtml = [NSString stringWithFormat:@"<p style=\"text-align:center\"><video width=360 height=240 controls=controls><source src=\"%@\" type=video/mp4 /></video></p>"  ,str];
                        content = [content stringByReplacingOccurrencesOfString:video withString:videoHtml];
                    }
                    
                    NSArray *linkArray = self.modelDic[@"link"];
                    for (int i = 0; i < linkArray.count; i++) {
                        NSString *link = linkArray[i][@"ref"];
                        NSString *linkHtml = [NSString stringWithFormat:@"<a href=\"%@/ target=_blank\">%@</a>",linkArray[i][@"href"], linkArray[i][@"title"]];
                        //        NSLog(@"%@",linkHtml);
                        content = [content stringByReplacingOccurrencesOfString:link withString:linkHtml];
                    }
                    
                    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"topic_template.html" ofType:nil];
                    
                    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                    NSString *resultString = [htmlString stringByReplacingOccurrencesOfString:@"__BODY__" withString:content];
                    resultString = [resultString stringByReplacingOccurrencesOfString:@"__TITLE__" withString:self.modelDic[@"title"]];
                    resultString = [resultString stringByReplacingOccurrencesOfString:@"__AUTHOR__" withString:self.modelDic[@"source"]];
                    resultString = [resultString stringByReplacingOccurrencesOfString:@"__TIME__" withString:self.modelDic[@"ptime"]];
                    [self initWebViewWithStr:resultString];
                
            } else {
                
            }
        });
        
    } falied:^(NSError *error) {
    }];
}
-(void)initWebViewWithStr:(NSString *)webStr{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49)] ;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self.progress;
    
    self.progress.webViewProxyDelegate=self;
    self.progress.progressDelegate=self;
    
    [_webView loadHTMLString:webStr baseURL:nil];
    [_webView setScalesPageToFit:YES];
    [_webView.scrollView setScrollEnabled:YES];
    [self.view addSubview:self.webView];
    
    self.progressView=[[NJKWebViewProgressView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    
    self.progressView.progress=0.0;
    
    [self.view addSubview:self.progressView];
    
  __weak typeof(self)weakSelf=self;
    
    self.progress.progressBlock=^(float progress){
    
        
        NSLog(@"%.2f",progress);
        [weakSelf.progressView setProgress:progress animated:YES];
    };
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    [self.progressView setProgress:1.0 animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.hidden=YES;
    });
    
    
    self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
//    if (self.dataSource.count) {
//        Singleton *sing = [Singleton mainSingleton];
//        NSString *str = @"%";
//        NSString *str1 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@%@'",sing.datastr,str];
//        [webView stringByEvaluatingJavaScriptFromString:str1];
//        float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, height, [UIScreen mainScreen].bounds.size.width - 20, self.dataSource.count * 60 + 30) style:UITableViewStylePlain];
//        [tableView registerClass:[RelatedNewsCell class] forCellReuseIdentifier:@"haha"];
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.rowHeight = 60;
//        [webView.scrollView addSubview:tableView];
//        [tableView release];
//    }
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{


    //[self.progressView setProgress:progress animated:NO];
}

@end
