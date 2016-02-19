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

@property(nonatomic,strong) UIImageView *userView;//用户信息视图

@property(nonatomic,strong) UIView *allOrdersView;//全部订单视图

@property(nonatomic,strong) UIView *orderOperateView;//订单状态操作栏视图

@end

@implementation UCUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    self.showMenu=YES;
    
    //初始化用户信息视图
    [self initUserView];
    
    //初始化全部订单视图
    [self initAllOrdersView];
    
    //初始化订单状态操作栏视图
    [self initOrderOperateView];
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
    self.userView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    self.userView.image=[UIImage imageNamed:@"user_center_userinfo_bg"];
    self.userView.userInteractionEnabled=YES;
    [self.view addSubview:self.userView];
}

/**
 *  初始化全部订单视图
 */
-(void)initAllOrdersView{
    //全部订单视图
    self.allOrdersView=[[UIView alloc] initWithFrame:CGRectMake(0, self.userView.bottom, self.userView.width, 44)];
    self.allOrdersView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.allOrdersView];
    
    //全部订单视图分割线
    UIView *allOrdersLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.allOrdersView.height-0.5, self.allOrdersView.width, 0.5)];
    allOrdersLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.allOrdersView addSubview:allOrdersLine];
}

/**
 *  初始化订单状态操作栏视图
 */
-(void)initOrderOperateView{
    //订单状态操作栏视图
    self.orderOperateView=[[UIView alloc] initWithFrame:CGRectMake(0, self.allOrdersView.bottom, self.allOrdersView.width, 60)];
    self.orderOperateView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.orderOperateView];
    
    //订单状态操作栏视图分割线
    UIView *orderOperateLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.orderOperateView.height-1, self.orderOperateView.width, 1)];
    orderOperateLine.backgroundColor=UIColorFromRGB(0xe6e6e6);
    [self.orderOperateView addSubview:orderOperateLine];
}

#pragma mark 自定义方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
