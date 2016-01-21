//
//  TabBarViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "TabBarViewController.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"
#import "SwipeBackNavigationViewController.h"

#import "HHomeViewController.h"
#import "TLTimeLimitViewController.h"
#import "SCShoppingCartViewController.h"
#import "UCUserCenterViewController.h"

@interface TabBarViewController (){
    NSArray *_tabBarTiTleArray;//菜单栏名称
    NSArray *_tabBarImageNormalArray;//菜单栏按钮图片
    NSArray *_tabBarImagePressedArray;//菜单栏按钮选中图片
}

@property(nonatomic,strong) UIView *tabBarView;//tabBar视图

@end

@implementation TabBarViewController

- (instancetype)init{
    self=[super init];
    
    if (self) {
        self.tabBar.hidden=YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //菜单栏名称
    _tabBarTiTleArray=@[@"首页",@"限时购",@"购物车",@"我的"];
    
    //菜单栏按钮图片
    _tabBarImageNormalArray=@[@"tabbar_home_normal",
                              @"tabbar_timelimit_normal",
                              @"tabbar_shopping_normal",
                              @"tabbar_user_normal"];
    
    //菜单栏按钮选中图片
    _tabBarImagePressedArray=@[@"tabbar_home_pressed",
                               @"tabbar_timelimit_pressed",
                               @"tabbar_shopping_pressed",
                               @"tabbar_user_pressed"];
    
    //初始化自定义Tabbar
    [self initCustomTabbar];
    
    //初始化ViewController
    [self initViewController];
}

/**
 *  初始化自定义Tabbar
 */
-(void)initCustomTabbar{
    //tabBar视图
    self.tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    self.tabBarView.tag=99;
    self.tabBarView.backgroundColor=UIColorFromRGB(0xf8f8f8);
    [self.view addSubview:self.tabBarView];
    
    //tabBar视图中顶部线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBarView.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xadadad);
    [self.tabBarView addSubview:topLine];
    
    //tabBar中按钮
    for (int i=0; i<_tabBarTiTleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i+1;
        btn.frame=CGRectMake(self.tabBarView.width/4*i, 0, self.tabBarView.width/4, self.tabBarView.height);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(8, (btn.width-24)/2, 17, (btn.width-24)/2)];
        [btn setImage:[UIImage imageNamed:_tabBarImageNormalArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_tabBarImagePressedArray[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(tabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView addSubview:btn];
        
        UILabel *title=[[UILabel alloc] init];
        title.tag=i*10+10;
        title.font=[UIFont systemFontOfSize:10.0];
        title.textColor=ThemeGray;
        [title setTextWidth:_tabBarTiTleArray[i] size:CGSizeMake(btn.width, 12)];
        title.frame=CGRectMake((btn.width-title.width)/2, 35, title.width, 12);
        [btn addSubview:title];
        
        //默认选中第一个菜单栏按钮
        if (i==0) {
            [self tabBarButton:btn];
        }
    }
}

/**
 *  初始化ViewController
 */
-(void)initViewController{
    HHomeViewController *home=[HHomeViewController new];
    home.title=@"首页";
    
    TLTimeLimitViewController *timeLimit=[TLTimeLimitViewController new];
    timeLimit.title=@"限时购";
    
    SCShoppingCartViewController *shoppingCart=[SCShoppingCartViewController new];
    shoppingCart.title=@"限时购";
    
    UCUserCenterViewController *userCenter=[UCUserCenterViewController new];
    userCenter.title=@"我的";
    
    self.viewControllers=@[[[SwipeBackNavigationViewController alloc] initWithRootViewController:home],
                           [[SwipeBackNavigationViewController alloc] initWithRootViewController:timeLimit],
                           [[SwipeBackNavigationViewController alloc] initWithRootViewController:shoppingCart],
                           [[SwipeBackNavigationViewController alloc] initWithRootViewController:userCenter]];
}

/**
 *  tabBar点击
 *
 *  @param sender
 */
-(void)tabBarButton:(UIButton *)sender{
    self.selectedIndex=sender.tag-1;
    
    for (int i=0; i<_tabBarTiTleArray.count; i++) {
        UIButton *btn=(UIButton *)[self.tabBarView viewWithTag:i+1];
        UILabel *title=(UILabel *)[btn viewWithTag:i*10+10];
        
        if (btn.tag==sender.tag) {
            btn.selected=YES;
            title.textColor=ThemeYellow;
        }
        else{
            btn.selected=NO;
            title.textColor=ThemeGray;
        }
    }
}

@end
