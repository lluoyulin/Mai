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

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor=ThemeYellow;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:ThemeBlack};
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)setShowMenu:(BOOL)showMenu{
    _showMenu=showMenu;
    
    if (self.isShowMenu) {
        UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame=CGRectMake(0, 0, 44, 44);
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 22)];
        [leftButton setImage:[UIImage imageNamed:@"navigation_menu"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        self.navigationItem.leftBarButtonItem=leftItem;
    }
}

-(void)leftButton:(UIButton *)sender{
    if (self.isShowMenu) {
        //点击汉堡包发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showmenu" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
