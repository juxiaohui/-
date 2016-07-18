//
//  WKWebViewViewController.m
//  XHNewsDemo
//
//  Created by juxiaohui on 16/7/18.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "ReadDetailModel.h"
#import <WebKit/WebKit.h>
#import "RelateNewsModel.h"
#import "JXHNewsContentModel.h"

@interface WKWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,retain)  MBProgressHUD *HUD;
@property(nonatomic,weak)    WKWebView *webView;
@property(nonatomic,retain)  ReadDetailModel *readModel;
@property (nonatomic,strong) JXHNewsContentModel * model;
@property(nonatomic,retain)  NSMutableArray *realateArray;
@property (nonatomic,strong) NSMutableDictionary* modelDic;
@property(nonatomic, weak)   UIProgressView * progressView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self requestWebData];
    
    UIProgressView * progressiew = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    progressiew.progress=0.0;
    
    [self.view addSubview:progressiew];
    
    progressiew.trackTintColor=[UIColor blueColor];
    
    self.progressView=progressiew;

}
-(void)requestWebData{
    
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
    
    // 创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContent addScriptMessageHandler:self name:@"NativeMethod"];
    // 将UserConttentController设置到配置文件
    config.userContentController = userContent;
    // 高端的自定义配置创建WKWebView
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
//    // 设置访问的URL
//    NSURL *url = [NSURL URLWithString:@"http://www.jianshu.com"];
//    // 根据URL创建请求
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    // WKWebView加载请求
//    [webView loadRequest:request];
    self.webView=webView;
    
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    self.webView.navigationDelegate = self;
    
    [webView loadHTMLString:webStr baseURL:nil];
    // 将WKWebView添加到视图
    [self.view addSubview:webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%@",change);
        
        self.progressView.progress =[change[@"new"] floatValue];
    }
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       self.progressView.hidden=YES;
    });
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailNavigation");
    
    //self.progressView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

    NSLog(@"userContentController");
}

-(void)dealloc{
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"NativeMethod"];
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
