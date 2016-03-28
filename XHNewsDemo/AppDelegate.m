//
//  AppDelegate.m
//  XHNewsDemo
//
//  Created by iosdev on 16/1/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "AppDelegate.h"
#import "JXHTabBarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setBarTintColor :[UIColor colorWithHexString:@"0xe13e3f"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.window.backgroundColor=[UIColor whiteColor];
    JXHTabBarViewController *tabBarController=[[JXHTabBarViewController alloc]init];
    self.window.rootViewController=tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}
//-(NSURL*)UrlWithStringForImage:(NSString*)string{
//    
//    NSString * str = [NSString stringWithFormat:@"%@@800w_600h_10Q.jpg",string];
//    NSLog(@"加载图片地址=%@",str);
//    return [NSURL URLWithString:str];
//}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if ([NSStringFromClass([[[window subviews]lastObject] class]) isEqualToString:@"UITransitionView"]) {
//        return UIInterfaceOrientationMaskAll;
//        //优酷 土豆  乐视  已经测试可以
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
