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

@property(nonatomic,strong) UIViewController *leftViewController;//左边VC
@property(nonatomic,strong) UIViewController *centerViewController;//中间VC
@property(nonatomic,strong) UIView *leftView;//左边视图
@property(nonatomic,strong) UIView *centerView;//中间视图

@property(nonatomic,strong) UIView *showLeftView;//显示左边视图时触摸事件的View
@property(nonatomic,strong) UITapGestureRecognizer *tapGesture;//触摸事件

@property(nonatomic,strong) LBWebViewViewController *webViewVC;

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
    
    //添加左边VC
    [self addChildViewController:self.leftViewController];
    [self.leftViewController didMoveToParentViewController:self];
    [self.leftView addSubview:self.leftViewController.view];
    
    //添加中间VC
    [self addChildViewController:self.centerViewController];
    [self.centerViewController didMoveToParentViewController:self];
    [self.centerView addSubview:self.centerViewController.view];
    
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

/**
 *  触摸事件
 *
 *  @param tap
 */
-(void)tapGesture:(UITapGestureRecognizer *)tap{
    [self showMenu:nil];
}

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
    
    [self.centerViewController.view removeFromSuperview];
    [self.centerViewController removeFromParentViewController];
    [self.webViewVC.view removeFromSuperview];
    [self.webViewVC removeFromParentViewController];
    
    if ([[notification.userInfo objectForKey:@"title"] isEqualToString:@"商城"]) {
        [self addChildViewController:self.centerViewController];
        [self.centerViewController didMoveToParentViewController:self];
        [self.centerView addSubview:self.centerViewController.view];
    }
    else if ([[notification.userInfo objectForKey:@"title"] isEqualToString:@"社区"]){
        if (!self.webViewVC) {
            self.webViewVC=[LBWebViewViewController new];
            self.webViewVC.url=@"http://shequ.yunzhijia.com/thirdapp/forum/network/571848f3e4b0d2075fe47ba6";
        }
        
        [self addChildViewController:self.webViewVC];
        [self.webViewVC didMoveToParentViewController:self];
        [self.centerView addSubview:self.webViewVC.view];
    }
}

/**
 *  是否隐藏状态栏（重写）
 *
 *  @return 是或否
 */
-(BOOL)prefersStatusBarHidden{
    return _statusBarHidden;
}

/**
 *  状态栏样式（重写）
 *
 *  @return 样式
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}

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
