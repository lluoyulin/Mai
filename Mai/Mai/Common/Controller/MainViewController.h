//
//  MainViewController.h
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

//定义一个变量来控制状态栏显示，子VC通过修改这个值来间接控制
@property(nonatomic,getter=isStatusBarHidden) BOOL statusBarHidden;

//定义一个变量来控制状态栏样式，子VC通过修改这个值来间接控制
@property(nonatomic) UIStatusBarStyle statusBarStyle;

-(instancetype)initWithLeftViewController:(UIViewController *)leftVC centerViewController:(UIViewController *)centerVC;

@end
