//
//  UCUserCenterViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCUserCenterViewController.h"

#import "Const.h"

#import "MainViewController.h"

@interface UCUserCenterViewController ()

@property(nonatomic,strong) UIView *userView;//用户信息视图

@end

@implementation UCUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    self.showMenu=YES;
    
    //初始化用户信息视图
    [self initUserView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏状态栏
    MainViewController *vc=(MainViewController *)self.navigationController.parentViewController.parentViewController;
    vc.statusBarHidden=YES;
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //显示状态栏
    MainViewController *vc=(MainViewController *)self.navigationController.parentViewController.parentViewController;
    vc.statusBarHidden=NO;
    
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 初始化视图
/**
 *  初始化用户信息视图
 */
-(void)initUserView{
    //用户信息视图
}

#pragma mark 自定义方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
