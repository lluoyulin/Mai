//
//  BaseViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

#import "Const.h"

@interface BaseViewController ()

@property(nonatomic,strong) UIButton *navigationBarLeftButton;//导航栏左边按钮

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.navigationController.navigationBar.barTintColor=ThemeYellow;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:ThemeBlack};
    
    //初始化导航栏按钮
    [self initnavigationBarButton];
}

/**
 *  初始化导航栏按钮
 */
-(void)initnavigationBarButton{
    //导航栏左边按钮
    self.navigationBarLeftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationBarLeftButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationBarLeftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 26)];
    [self.navigationBarLeftButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [self.navigationBarLeftButton addTarget:self action:@selector(navigationBarLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:self.navigationBarLeftButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

/**
 *  setter
 *
 *  @param showMenu
 */
-(void)setShowMenu:(BOOL)showMenu{
    _showMenu=showMenu;
    
    if (self.isShowMenu) {
        [self.navigationBarLeftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 22)];
        [self.navigationBarLeftButton setImage:[UIImage imageNamed:@"navigation_menu"] forState:UIControlStateNormal];
    }
}

/**
 *  左边按钮
 *
 *  @param sender 按钮对象
 */
-(void)navigationBarLeftButton:(UIButton *)sender{
    if (self.isShowMenu) {
        //点击汉堡包发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showmenu" object:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
