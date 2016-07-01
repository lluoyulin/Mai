//
//  MainViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "MainViewController.h"

#import "Const.h"

#import "LBWebViewViewController.h"
#import "SwipeBackNavigationViewController.h"

@interface MainViewController ()

@property (nonatomic,strong) UIViewController        *leftViewController;//左边VC
@property (nonatomic,strong) UIViewController        *centerViewController;//中间VC
@property (nonatomic,strong) UIViewController        *currentCenterVC;//当前中间显示VC
@property (nonatomic,strong) UIView                  *leftView;//左边视图
@property (nonatomic,strong) UIView                  *centerView;//中间视图

@property (nonatomic,strong) UIView                  *showLeftView;//显示左边视图时触摸事件的View
@property (nonatomic,strong) UITapGestureRecognizer  *tapGesture;//触摸事件

@property (nonatomic,strong) LBWebViewViewController *communityVC;//社区VC
@property (nonatomic,strong) LBWebViewViewController *marketVC;//蚤市VC

@end

@implementation MainViewController

-(instancetype)initWithLeftViewController:(UIViewController *)leftVC centerViewController:(UIViewController *)centerVC{
    self=[super init];
    
    if (self) {
        self.leftViewController=leftVC;
        self.centerViewController=centerVC;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册点击汉堡包通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu:) name:@"showmenu" object:nil];
    
    //注册切换栏目通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCenterView:) name:@"load_center_view" object:nil];
    
    //左边视图
    self.leftView=[[UIView alloc] initWithFrame:CGRectMake(-self.view.width*2/3, 0, self.view.width*2/3, self.view.height)];
    self.leftView.layer.masksToBounds=YES;
    [self.view addSubview:self.leftView];
    
    //中间视图
    self.centerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.centerView.layer.masksToBounds=YES;
    [self.view addSubview:self.centerView];
    
    //当前中间显示VC
    self.currentCenterVC=self.centerViewController;

    //添加左边VC
    [self addChildViewController:self.leftViewController];
    [self.leftViewController didMoveToParentViewController:self];
    [self.leftView addSubview:self.leftViewController.view];
    
    //添加中间VC
    [self addChildViewController:self.currentCenterVC];
    [self.currentCenterVC didMoveToParentViewController:self];
    [self.centerView addSubview:self.currentCenterVC.view];
    
    //显示左边视图时触摸事件的View
    self.showLeftView=[[UIView alloc] initWithFrame:CGRectMake(self.view.width*2/3, 0, self.view.width*2/3, self.view.height)];
    self.showLeftView.backgroundColor=[UIColor clearColor];
    self.showLeftView.hidden=YES;
    [self.view addSubview:self.showLeftView];
    [self.view bringSubviewToFront:self.showLeftView];
    
    //触摸事件
    self.tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.showLeftView addGestureRecognizer:self.tapGesture];
}

#pragma mark 事件
/**
 *  触摸事件
 *
 *  @param tap
 */
-(void)tapGesture:(UITapGestureRecognizer *)tap{
    [self showMenu:nil];
}

#pragma mark 通知
/**
 *  显示左边视图
 */
-(void)showMenu:(NSNotification *)notification{
    if (self.centerView.left==0) {
        self.showLeftView.hidden=NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.leftView.transform=CGAffineTransformMakeTranslation(self.leftView.width, 0);
            self.centerView.transform=CGAffineTransformMakeTranslation(self.leftView.width, 0);
        }];
    }
    else{
        self.showLeftView.hidden=YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.leftView.transform=CGAffineTransformIdentity;
            self.centerView.transform=CGAffineTransformIdentity;
        }];
    }
}

/**
 *  切换栏目发送通知
 */
-(void)loadCenterView:(NSNotification *)notification{
    [self showMenu:nil];

    [self.currentCenterVC.view removeFromSuperview];
    [self.currentCenterVC removeFromParentViewController];

    if ([[notification.userInfo objectForKey:@"title"] isEqualToString:@"商城"]) {
        self.currentCenterVC = self.centerViewController;
    }
    else if ([[notification.userInfo objectForKey:@"title"] isEqualToString:@"蚤市"]){
        if (!self.marketVC) {
            self.marketVC=[LBWebViewViewController new];
            self.marketVC.url=@"http://www.baidu.com";
        }

        self.currentCenterVC = self.marketVC;
    }
    else if ([[notification.userInfo objectForKey:@"title"] isEqualToString:@"社区"]){
        if (!self.communityVC) {
            self.communityVC=[LBWebViewViewController new];
            self.communityVC.url=@"http://www.sina.com.cn";
        }

        self.currentCenterVC = self.communityVC;
    }

    [self addChildViewController:self.currentCenterVC];
    [self.currentCenterVC didMoveToParentViewController:self];
    [self.centerView addSubview:self.currentCenterVC.view];
}

#pragma mark 重写系统方法
/**
 *  是否隐藏状态栏
 *
 *  @return 是或否
 */
-(BOOL)prefersStatusBarHidden{
    return _statusBarHidden;
}

/**
 *  状态栏样式
 *
 *  @return 样式
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}

#pragma mark 属性
-(void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden=statusBarHidden;
    
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle=statusBarStyle;
    
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
