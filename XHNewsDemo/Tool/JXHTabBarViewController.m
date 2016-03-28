//
//  JXHTabBarViewController.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHTabBarViewController.h"
#import "JXHNewsViewController.h"
#import "JXHReadViewController.h"
#import "JXHRadioViewController.h"
#import "JXHVideoViewController.h"
#import "AppDelegate.h"


#define ApplicationDelegate   ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface JXHTabBarViewController ()

@end

@implementation JXHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedIndex=0;
    
    [self setupViewController];
}
-(void)setupViewController{

    [self setupChildVc:[[JXHNewsViewController alloc]init] title:@"新闻" image:@"tabbar_icon_news_normal" selectedImage:@"tabbar_icon_news_highlight"];
    
    [self setupChildVc:[[JXHReadViewController alloc]init] title:@"阅读" image:@"tabbar_icon_reader_normal" selectedImage:@"tabbar_icon_reader_highlight"];
    
    [self setupChildVc:[[JXHVideoViewController alloc]init] title:@"视频" image:@"tabbar_icon_media_normal" selectedImage:@"tabbar_icon_media_highlight"];
    
    [self setupChildVc:[[JXHRadioViewController alloc]init] title:@"音乐" image:@"tabbar_icon_bar_normal" selectedImage:@"tabbar_icon_bar_highlight"];

    
    //设置tababr的背景色
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:214/255.0 green:50/255.0 blue:49/255.0 alpha:1.000];

}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    UINavigationController *nav = self.childViewControllers[2];
    // MoviePlayerViewController这个页面支持自动转屏
    if ([nav.topViewController isKindOfClass:[JXHVideoViewController class]]) {
        return !ZFPlayerShared.isLockScreen;  // 调用AppDelegate单例记录播放状态是否锁屏
       }
    return NO;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    UINavigationController *nav = self.childViewControllers[2];
     if ([nav.topViewController isKindOfClass:[JXHVideoViewController class]]) {
        if (ZFPlayerShared.isAllowLandscape) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else {
            return UIInterfaceOrientationMaskPortrait;
        }
    }else { // 其他页面支持转屏方向
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
