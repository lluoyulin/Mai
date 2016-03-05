//
//  AppDelegate.m
//  Mai
//
//  Created by freedom on 16/1/20.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "AppDelegate.h"

#import "Const.h"
#import "NSObject+Utils.h"
#import "CAlertView.h"

#import "MainViewController.h"
#import "TabBarViewController.h"
#import "LBLeftBarViewController.h"

#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //不刷新数据
    self.isRefresh=NO;
    
    //进入购物车页面，当用户未登录时，显示登录页面
    [UserData setObject:@"1" forKey:@"show_login"];
    
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    self.window.rootViewController=[[MainViewController alloc] initWithLeftViewController:[LBLeftBarViewController new] centerViewController:[TabBarViewController new]];
    [self.window makeKeyAndVisible];
    
    
    //向微信注册wx3eb102aff53e1896
    [WXApi registerApp:@"wx3eb102aff53e1896" withDescription:@"出来mai"];
    
    return YES;
}

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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark 微信支付委托
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void)onResp:(BaseResp*)resp{
    switch (resp.errCode) {
        case 0:
            //发送支付成功后进入我的订单通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
            break;
        case -1:
            [CAlertView alertMessage:resp.errStr];
            break;
        case -2:
            [CAlertView alertMessage:@"取消支付"];
            break;
        case -3:
            [CAlertView alertMessage:resp.errStr];
            break;
        case -4:
            [CAlertView alertMessage:resp.errStr];
            break;
        case -5:
            [CAlertView alertMessage:resp.errStr];
            break;
    }
}

@end
