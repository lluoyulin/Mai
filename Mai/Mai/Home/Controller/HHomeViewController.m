//
//  HHomeViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HHomeViewController.h"

#import "Const.h"

#import "HGoodsDetailsViewController.h"

@interface HHomeViewController ()

@end

@implementation HHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeYellow;
    
    self.showMenu=YES;
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-50)/2, 100, 50);
    [btn setTitle:@"push下一个页面" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.navigationController.navigationBar.barTintColor=ThemeYellow;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:ThemeBlack};
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)btn:(UIButton *)sender{
    HGoodsDetailsViewController *vc=[HGoodsDetailsViewController new];
    vc.title=@"商品详情页";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
