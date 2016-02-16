//
//  MainViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "MainViewController.h"

#import "Const.h"

@interface MainViewController ()

@property(nonatomic,strong) UIViewController *leftViewController;//左边VC
@property(nonatomic,strong) UIViewController *centerViewController;//中间VC
@property(nonatomic,strong) UIView *leftView;//左边视图
@property(nonatomic,strong) UIView *centerView;//中间视图

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
}

/**
 *  显示左边视图
 */
-(void)showMenu:(NSNotification *)notification{
    if (self.centerView.left==0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.leftView.transform=CGAffineTransformMakeTranslation(self.leftView.width, 0);
            self.centerView.transform=CGAffineTransformMakeTranslation(self.leftView.width, 0);
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            self.leftView.transform=CGAffineTransformIdentity;
            self.centerView.transform=CGAffineTransformIdentity;
        }];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
