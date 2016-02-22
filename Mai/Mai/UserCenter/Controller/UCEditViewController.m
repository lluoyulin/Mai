//
//  UCEditViewController.m
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCEditViewController.h"

#import "Const.h"
#import "CAlertView.h"
#import "NSString+Utils.h"

@interface UCEditViewController ()

@property(nonatomic,strong) UIButton *navigationSaveButton;//保存按钮

@property(nonatomic,strong) UIButton *manButton;//男按钮
@property(nonatomic,strong) UILabel *manTageLabel;//男标签
@property(nonatomic,strong) UIImageView *manSelectImage;//男选中标志

@property(nonatomic,strong) UIButton *womanButton;//女按钮
@property(nonatomic,strong) UILabel *womanTageLabel;//女标签
@property(nonatomic,strong) UIImageView *womanSelectImage;//女选中标志

@property(nonatomic,strong) UITextField *text;//文本框

@end

@implementation UCEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化视图
    [self initView];
    
    //初始化数据
    if ([self.title isEqualToString:@"性别"]) {
        if ([[self.dic objectForKey:@"text"] isEqualToString:@"1"]) {
            [self manButton:nil];
        }
        else if ([[self.dic objectForKey:@"text"] isEqualToString:@"2"]){
            [self womanButton:nil];
        }
    }
    else{
        self.text.text=[self.dic objectForKey:@"text"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.text) {
        [self.text becomeFirstResponder];
    }
}

#pragma mark 初始化视图
/**
 *  初始化视图
 */
-(void)initView{
    if ([self.title isEqualToString:@"性别"]) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+15, SCREEN_WIDTH, 88)];
        view.backgroundColor=ThemeWhite;
        [self.view addSubview:view];
        
        //顶部分割线
        UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0.5)];
        topLine.backgroundColor=UIColorFromRGB(0xdddddd);
        [view addSubview:topLine];
        
        //中间分割线
        UIView *middleLine=[[UIView alloc] initWithFrame:CGRectMake(15, view.height/2-0.5, view.width-15-15, 0.5)];
        middleLine.backgroundColor=topLine.backgroundColor;
        [view addSubview:middleLine];
        
        //底部分割线
        UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, view.height-0.5, topLine.width, 0.5)];
        bottomLine.backgroundColor=topLine.backgroundColor;
        [view addSubview:bottomLine];
        
        //男按钮
        self.manButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.manButton.frame=CGRectMake(middleLine.left, topLine.bottom, middleLine.width, 44);
        [self.manButton addTarget:self action:@selector(manButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.manButton];
        
        //男标签
        self.manTageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (self.manButton.height-16)/2, 30, 16)];
        self.manTageLabel.font=[UIFont systemFontOfSize:14.0];
        self.manTageLabel.textColor=ThemeBlack;
        self.manTageLabel.text=@"男";
        [self.manButton addSubview:self.manTageLabel];
        
        //男选中标志
        self.manSelectImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.manButton.width-13, (self.manButton.height-13)/2, 13, 13)];
        self.manSelectImage.image=[UIImage imageNamed:@"user_center_selected"];
        self.manSelectImage.hidden=YES;
        [self.manButton addSubview:self.manSelectImage];
        
        //女按钮
        self.womanButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.womanButton.frame=CGRectMake(self.manButton.left, middleLine.bottom, self.manButton.width, self.manButton.height);
        [self.womanButton addTarget:self action:@selector(womanButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.womanButton];
        
        //女标签
        self.womanTageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (self.manButton.height-16)/2, 30, 16)];
        self.womanTageLabel.font=[UIFont systemFontOfSize:14.0];
        self.womanTageLabel.textColor=ThemeBlack;
        self.womanTageLabel.text=@"女";
        [self.womanButton addSubview:self.womanTageLabel];
        
        //女选中标志
        self.womanSelectImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.manButton.width-13, (self.manButton.height-13)/2, 13, 13)];
        self.womanSelectImage.image=[UIImage imageNamed:@"user_center_selected"];
        self.womanSelectImage.hidden=YES;
        [self.womanButton addSubview:self.womanSelectImage];
    }
    else{
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+15, SCREEN_WIDTH, 44)];
        view.backgroundColor=ThemeWhite;
        [self.view addSubview:view];
        
        //顶部分割线
        UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0.5)];
        topLine.backgroundColor=UIColorFromRGB(0xdddddd);
        [view addSubview:topLine];
        
        //底部分割线
        UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, view.height-0.5, topLine.width, 0.5)];
        bottomLine.backgroundColor=topLine.backgroundColor;
        [view addSubview:bottomLine];
        
        //文本框
        self.text=[[UITextField alloc] initWithFrame:CGRectMake(15, topLine.bottom, view.width-15-15, 44)];
        self.text.font=[UIFont systemFontOfSize:14.0];
        self.text.textColor=ThemeBlack;
        self.text.placeholder=[NSString stringWithFormat:@"请输入%@",self.title];
        self.text.clearButtonMode=UITextFieldViewModeWhileEditing;
        [view addSubview:self.text];
        
        if ([self.title isEqualToString:@"邮箱"]) {
            self.text.keyboardType=UIKeyboardTypeEmailAddress;
        }
    }
}

/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏删除按钮
    self.navigationSaveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationSaveButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationSaveButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.navigationSaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationSaveButton addTarget:self action:@selector(navigationSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:self.navigationSaveButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

#pragma mark 按钮事件
/**
 *  保存按钮
 *
 *  @param sender
 */
-(void)navigationSaveButton:(UIButton *)sender{
    if ([self.title isEqualToString:@"邮箱"]) {
        if (![self.text.text isValidEmail]) {
            [CAlertView alertMessage:@"邮箱格式不正确"];
            return;
        }
    }
    if ([self.text.text isEmpty]) {
        [CAlertView alertMessage:[NSString stringWithFormat:@"%@不能为空",self.title]];
        return;
    }
    
    [self.text resignFirstResponder];
    
    NSString *text=@"";
    if ([self.title isEqualToString:@"性别"]) {
        text=self.manButton.selected ? @"1" : @"2";
    }
    else{
        text=[self.text.text text];
    }
    
    //用户资料保存成功发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"edit_profile" object:nil userInfo:@{@"text":text,@"tag":self.title}];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  男按钮
 *
 *  @param sender
 */
-(void)manButton:(UIButton *)sender{
    self.manButton.selected=YES;
    self.womanButton.selected=NO;
    
    self.manSelectImage.hidden=NO;
    self.womanSelectImage.hidden=YES;
}

/**
 *  女按钮
 *
 *  @param sender
 */
-(void)womanButton:(UIButton *)sender{
    self.manButton.selected=NO;
    self.womanButton.selected=YES;
    
    self.manSelectImage.hidden=YES;
    self.womanSelectImage.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
