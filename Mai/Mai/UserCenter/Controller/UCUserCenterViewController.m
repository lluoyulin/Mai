//
//  UCUserCenterViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCUserCenterViewController.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"
#import "NSObject+Utils.h"
#import "CAlertView.h"
#import "NSObject+HttpTask.h"

#import "MainViewController.h"
#import "ULLoginViewController.h"
#import "UCEditProfileViewController.h"
#import "UCOrderListViewController.h"
#import "MPPointsViewController.h"

#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface UCUserCenterViewController ()

@property(nonatomic,strong) UIImageView *userView;//用户信息视图
@property(nonatomic,strong) UIButton *userInfoButton;//用户信息按钮
@property(nonatomic,strong) UIImageView *userHeadImage;//用户头像
@property(nonatomic,strong) UILabel *nickNameLabel;//用户昵称
@property(nonatomic,strong) UIImageView *userEditFlagImage;//用户信息编辑图片
@property(nonatomic,strong) UIButton *signButton;//签到按钮
@property(nonatomic,strong) UILabel *signTagLabel;//签到标签

@property(nonatomic,strong) UIView *myPointsView;//我的积分视图
@property(nonatomic,strong) UIImageView *myPointsLogoImage;//我的积分logo
@property(nonatomic,strong) UIButton *myPointsButton;//我的积分按钮
@property(nonatomic,strong) UILabel *myPointsTagLabel;//我的积分标签
@property(nonatomic,strong) UILabel *openMyPointsTagLabel;//打开我的积分标签
@property(nonatomic,strong) UIImageView *openMyPointsFlagImage;//打开我的积分图片

@property(nonatomic,strong) UIView *allOrdersView;//全部订单视图
@property(nonatomic,strong) UIImageView *allOrdersLogoImage;//全部订单logo
@property(nonatomic,strong) UIButton *allOrdersButton;//全部订单按钮
@property(nonatomic,strong) UILabel *myOrdersTagLabel;//我消费的订单标签
@property(nonatomic,strong) UILabel *openOrdersTagLabel;//打开我的订单标签
@property(nonatomic,strong) UIImageView *openOrdersFlagImage;//打开我的订单图片

@property(nonatomic,strong) UIView *orderOperateView;//订单状态操作栏视图


@end

@implementation UCUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    self.showMenu=YES;
    
    //注册退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"logout" object:nil];
    
    //初始化用户信息视图
    [self initUserView];
    
    //我的积分视图
    [self initMyPointsView];
    
    //初始化全部订单视图
    [self initAllOrdersView];
    
    //初始化订单状态操作栏视图
    [self initOrderOperateView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    MainViewController *vc=(MainViewController *)self.navigationController.parentViewController.parentViewController;
    
    //隐藏状态栏
    //    vc.statusBarHidden=YES;
    
    //状态栏样式
    vc.statusBarStyle=UIStatusBarStyleLightContent;
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //更新用户信息
    [self updateUserInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    MainViewController *vc=(MainViewController *)self.navigationController.parentViewController.parentViewController;
    
    //显示状态栏
    //    vc.statusBarHidden=NO;
    
    //状态栏样式
    vc.statusBarStyle=UIStatusBarStyleDefault;
    
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
    
    //用户信息按钮
    self.userInfoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.userInfoButton.frame=CGRectMake(0, (self.userView.height-60)/2, self.userView.width, 60);
    [self.userInfoButton addTarget:self action:@selector(userInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.userView addSubview:self.userInfoButton];
    
    //用户头像
    self.userHeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 60, 60)];
    self.userHeadImage.layer.masksToBounds=YES;
    self.userHeadImage.layer.borderColor=[UIColorFromRGB(0xffffff) CGColor];
    self.userHeadImage.layer.borderWidth=1.5;
    self.userHeadImage.layer.cornerRadius=self.userHeadImage.width/2;
    [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [self.userInfoButton addSubview:self.userHeadImage];
    
    //用户昵称
    self.nickNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.userHeadImage.right+15, (self.userInfoButton.height-20)/2, self.userView.width-self.userHeadImage.right-15-15-14-15, 20)];
    self.nickNameLabel.font=[UIFont systemFontOfSize:20.0];
    self.nickNameLabel.textColor=ThemeWhite;
    [self.userInfoButton addSubview:self.nickNameLabel];
    
    //用户信息编辑图片
    self.userEditFlagImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.userInfoButton.width-14-15, (self.userInfoButton.height-14)/2, 14, 14)];
    self.userEditFlagImage.image=[UIImage imageNamed:@"user_center_white_arrow"];
    [self.userInfoButton addSubview:self.userEditFlagImage];
    
    //签到按钮
    self.signButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.signButton.frame=CGRectMake(self.userView.width-44-1, self.userInfoButton.bottom+6, 44, 44);
    [self.signButton setImage:[UIImage imageNamed:@"user_center_sign"] forState:UIControlStateNormal];
    [self.signButton addTarget:self action:@selector(signButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.userView addSubview:self.signButton];
    
    //签到标签
    self.signTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.signButton.width, 12)];
    self.signTagLabel.font=[UIFont systemFontOfSize:10.0];
    self.signTagLabel.textColor=[UIColor whiteColor];
    self.signTagLabel.textAlignment=NSTextAlignmentCenter;
    self.signTagLabel.text=@"签到";
    [self.signButton addSubview:self.signTagLabel];
}

/**
 *  初始化我的积分视图
 */
-(void)initMyPointsView{
    //我的积分视图
    self.myPointsView=[[UIView alloc] initWithFrame:CGRectMake(0, self.userView.bottom, self.userView.width, 44)];
    self.myPointsView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.myPointsView];
    
    //我的积分视图分割线
    UIView *myPointsLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.myPointsView.height-0.5, self.myPointsView.width, 0.5)];
    myPointsLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.myPointsView addSubview:myPointsLine];
    
    //我的积分logo
    self.myPointsLogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, (self.myPointsView.height-21)/2, 21, 21)];
    self.myPointsLogoImage.image=[UIImage imageNamed:@"points_diamond"];
    [self.myPointsView addSubview:self.myPointsLogoImage];
    
    //我的积分按钮
    self.myPointsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.myPointsButton.frame=CGRectMake(self.myPointsLogoImage.right+10, 0, self.userView.width-self.myPointsLogoImage.right-10, 44);
    [self.myPointsButton addTarget:self action:@selector(myPointsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.myPointsView addSubview:self.myPointsButton];
    
    //我的积分标签
    self.myPointsTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (self.myPointsButton.height-16)/2, 0, 16)];
    self.myPointsTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.myPointsTagLabel.textColor=UIColorFromRGB(0x666666);
    [self.myPointsTagLabel setTextWidth:@"我的积分" size:CGSizeMake(100,16)];
    [self.myPointsButton addSubview:self.myPointsTagLabel];
    
    //打开我的积分图片
    self.openMyPointsFlagImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.myPointsButton.width-16-15, (self.myPointsButton.height-16)/2, 16, 16)];
    self.openMyPointsFlagImage.image=[UIImage imageNamed:@"order_address_arrow"];
    [self.myPointsButton addSubview:self.openMyPointsFlagImage];
    
    //打开我的积分标签
    self.openMyPointsTagLabel=[UILabel new];
    self.openMyPointsTagLabel.font=[UIFont systemFontOfSize:11.0];
    self.openMyPointsTagLabel.textColor=ThemeGray;
    [self.openMyPointsTagLabel setTextWidth:@"查看积分详情" size:CGSizeMake(150,13)];
    self.openMyPointsTagLabel.frame=CGRectMake(self.openMyPointsFlagImage.left-5-self.openMyPointsTagLabel.width, (self.myPointsButton.height-13)/2, self.openMyPointsTagLabel.width, 13);
    [self.myPointsButton addSubview:self.openMyPointsTagLabel];
}

/**
 *  初始化全部订单视图
 */
-(void)initAllOrdersView{
    //全部订单视图
    self.allOrdersView=[[UIView alloc] initWithFrame:CGRectMake(0, self.myPointsView.bottom, self.myPointsView.width, 44)];
    self.allOrdersView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.allOrdersView];
    
    //全部订单视图分割线
    UIView *allOrdersLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.allOrdersView.height-0.5, self.allOrdersView.width, 0.5)];
    allOrdersLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.allOrdersView addSubview:allOrdersLine];
    
    //全部订单logo
    self.allOrdersLogoImage=[[UIImageView alloc] initWithFrame:CGRectMake(14, (self.allOrdersView.height-21)/2, 21, 21)];
    self.allOrdersLogoImage.image=[UIImage imageNamed:@"user_center_orders"];
    [self.allOrdersView addSubview:self.allOrdersLogoImage];
    
    //全部订单按钮
    self.allOrdersButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.allOrdersButton.frame=CGRectMake(self.allOrdersLogoImage.right+10, 0, self.userView.width-self.allOrdersLogoImage.right-10, 44);
    [self.allOrdersButton addTarget:self action:@selector(allOrdersButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.allOrdersView addSubview:self.allOrdersButton];
    
    //我消费的订单标签
    self.myOrdersTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (self.allOrdersButton.height-16)/2, 0, 16)];
    self.myOrdersTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.myOrdersTagLabel.textColor=UIColorFromRGB(0x666666);
    [self.myOrdersTagLabel setTextWidth:@"我消费的订单" size:CGSizeMake(100,16)];
    [self.allOrdersButton addSubview:self.myOrdersTagLabel];
    
    //打开我的订单图片
    self.openOrdersFlagImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.allOrdersButton.width-16-15, (self.allOrdersButton.height-16)/2, 16, 16)];
    self.openOrdersFlagImage.image=[UIImage imageNamed:@"order_address_arrow"];
    [self.allOrdersButton addSubview:self.openOrdersFlagImage];
    
    //打开我的订单
    self.openOrdersTagLabel=[UILabel new];
    self.openOrdersTagLabel.font=[UIFont systemFontOfSize:11.0];
    self.openOrdersTagLabel.textColor=ThemeGray;
    [self.openOrdersTagLabel setTextWidth:@"查看已消费的订单" size:CGSizeMake(150,13)];
    self.openOrdersTagLabel.frame=CGRectMake(self.openOrdersFlagImage.left-5-self.openOrdersTagLabel.width, (self.allOrdersButton.height-13)/2, self.openOrdersTagLabel.width, 13);
    [self.allOrdersButton addSubview:self.openOrdersTagLabel];
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
    
    //初始化订单状态操作栏按钮
    [self initOrderOperateButton];
}

/**
 *  初始化订单状态操作栏按钮
 */
-(void)initOrderOperateButton{
    //按钮名称
    NSArray *titleArray=@[@"已下单",@"已支付",@"已取消",@"配送中",@"已完成"];
    
    //菜单栏按钮图片
    NSArray *imageNormalArray=@[@"user_center_card",
                                @"user_center_waiting",
                                @"user_center_receive",
                                @"user_center_distribution",
                                @"user_center_finish"];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i+1;
        btn.frame=CGRectMake(self.orderOperateView.width/5*i, 0, self.orderOperateView.width/5, self.orderOperateView.height);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(6, (btn.width-20)/2, 24, (btn.width-20)/2)];
        [btn setImage:[UIImage imageNamed:imageNormalArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageNormalArray[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(orderOperateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderOperateView addSubview:btn];
        
        UILabel *title=[[UILabel alloc] init];
        title.tag=i*10+10;
        title.font=[UIFont systemFontOfSize:11.0];
        title.textColor=ThemeGray;
        [title setTextWidth:titleArray[i] size:CGSizeMake(btn.width, 13)];
        title.frame=CGRectMake((btn.width-title.width)/2, 36, title.width, 13);
        [btn addSubview:title];
    }
}

#pragma mark 自定义方法
/**
 *  更新用户信息
 */
-(void)updateUserInfo{
    [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:self.userHead] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nickNameLabel.text=[self.nickName isEqualToString:@""] ? @"游客" : self.nickName;
}

/**
 *  签到
 */
-(void)sign{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"签到途中...";
    
    //构造参数
    NSString *url=@"qiandao";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            hud.mode=MBProgressHUDModeCustomView;
            hud.customView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            hud.labelText=@"签到成功";
            [hud hide:YES afterDelay:3];
        }
        else{
            [hud hide:YES];
            
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

#pragma mark 按钮事件
/**
 *  用户信息按钮
 *
 *  @param sender
 */
-(void)userInfoButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    [self.navigationController pushViewController:[UCEditProfileViewController new] animated:YES];
}

/**
 *  我的积分按钮
 *
 *  @param sender
 */
-(void)myPointsButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    MPPointsViewController *vc=[MPPointsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  全部订单按钮
 *
 *  @param sender
 */
-(void)allOrdersButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    UCOrderListViewController *vc=[UCOrderListViewController new];
    vc.selectIndex=5;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  订单状态操作栏按钮
 *
 *  @param sender
 */
-(void)orderOperateButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    UCOrderListViewController *vc=[UCOrderListViewController new];
    vc.selectIndex=sender.tag;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  签到按钮
 *
 *  @param sender 
 */
-(void)signButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    //签到
    [self sign];
}

#pragma mark 通知
/**
 *  退出通知
 *
 *  @param notification
 */
-(void)userLogout:(NSNotification *)notification{
    //更新用户信息
    [self updateUserInfo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
