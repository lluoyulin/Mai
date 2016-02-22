//
//  ULLoginViewController.m
//  Mai
//
//  Created by freedom on 16/2/18.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "ULLoginViewController.h"

#import "Const.h"
#import "NSObject+HttpTask.h"
#import "NSString+Utils.h"
#import "NSObject+Utils.h"
#import "CTextField.h"
#import "CAlertView.h"

#import "ULRegisterViewController.h"
#import "ULQuickLoginViewController.h"
#import "ULFindPasswordViewController.h"

#import "MBProgressHUD.h"

@interface ULLoginViewController ()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) CTextField *phoneText;//手机号
@property(nonatomic,strong) CTextField *passwordText;//密码
@property(nonatomic,strong) UIButton *loginButton;//登录按钮
@property(nonatomic,strong) UIButton *forgetPasswordButton;//忘记密码按钮
@property(nonatomic,strong) UIButton *registerButton;//注册按钮
@property(nonatomic,strong) UIButton *quickLoginButton;//快速登录按钮

@end

@implementation ULLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"登录";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //初始化视图
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self isLogin]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 初始化视图
/**
 *  初始化视图
 */
-(void)initView{
    self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.contentView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.contentView];
    
    //手机号
    self.phoneText=[[CTextField alloc] initWithFrame:CGRectMake(15, 50, self.contentView.width-15-15, 45)];
    self.phoneText.textColor=ThemeBlack;
    self.phoneText.backgroundColor=ThemeWhite;
    self.phoneText.font=[UIFont systemFontOfSize:14.0];
    self.phoneText.placeholder=@"输入手机号";
    self.phoneText.layer.masksToBounds=YES;
    self.phoneText.layer.cornerRadius=2;
    self.phoneText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.phoneText.keyboardType=UIKeyboardTypeNumberPad;
    self.phoneText.leftViewMode=UITextFieldViewModeAlways;
    [self.contentView addSubview:self.phoneText];
    
    //添加手机号文本框左视图
    UIImageView *phoneLeftImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.phoneText.height-20)/2, 20, 20)];
    phoneLeftImage.image=[UIImage imageNamed:@"user_login_phone"];
    self.phoneText.leftView=phoneLeftImage;
    
    //密码
    self.passwordText=[[CTextField alloc] initWithFrame:CGRectMake(self.phoneText.left, self.phoneText.bottom+20, self.phoneText.width, self.phoneText.height)];
    self.passwordText.textColor=ThemeBlack;
    self.passwordText.backgroundColor=ThemeWhite;
    self.passwordText.font=[UIFont systemFontOfSize:14.0];
    self.passwordText.placeholder=@"输入密码";
    self.passwordText.layer.masksToBounds=YES;
    self.passwordText.layer.cornerRadius=2;
    self.passwordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.passwordText.leftViewMode=UITextFieldViewModeAlways;
    self.passwordText.secureTextEntry=YES;
    [self.contentView addSubview:self.passwordText];
    
    //添加密码文本框左视图
    UIImageView *passwordLeftImage=[[UIImageView alloc] initWithFrame:phoneLeftImage.frame];
    passwordLeftImage.image=[UIImage imageNamed:@"user_login_password"];
    self.passwordText.leftView=passwordLeftImage;
    
    //登录按钮
    self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame=CGRectMake(self.phoneText.left, self.passwordText.bottom+40, self.phoneText.width, self.phoneText.height);
    self.loginButton.backgroundColor=ThemeYellow;
    self.loginButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [self.loginButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.showsTouchWhenHighlighted=YES;
    [self.contentView addSubview:self.loginButton];
    
    //忘记密码按钮
    self.forgetPasswordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPasswordButton.frame=CGRectMake(self.contentView.width-60-15, self.passwordText.bottom+3, 60, 34);
    self.forgetPasswordButton.titleLabel.font=[UIFont systemFontOfSize:11.0];
    self.forgetPasswordButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [self.forgetPasswordButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPasswordButton addTarget:self action:@selector(forgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    self.forgetPasswordButton.showsTouchWhenHighlighted=YES;
    [self.contentView addSubview:self.forgetPasswordButton];
    
    //注册按钮
    self.registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.frame=CGRectMake(self.loginButton.left, self.loginButton.bottom+0.5, 60, 44);
    self.registerButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    self.registerButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.registerButton setTitleColor:UIColorFromRGB(0x1f2255) forState:UIControlStateNormal];
    [self.registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButton:) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.showsTouchWhenHighlighted=YES;
    [self.contentView addSubview:self.registerButton];
    
    //快速登录按钮
    self.quickLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.quickLoginButton.frame=CGRectMake(self.contentView.width-100-15, self.registerButton.top, 100, 44);
    self.quickLoginButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    self.quickLoginButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [self.quickLoginButton setTitleColor:UIColorFromRGB(0x1f2255) forState:UIControlStateNormal];
    [self.quickLoginButton setTitle:@"手机号快速登录" forState:UIControlStateNormal];
    [self.quickLoginButton addTarget:self action:@selector(quickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    self.quickLoginButton.showsTouchWhenHighlighted=YES;
    [self.contentView addSubview:self.quickLoginButton];
}

#pragma mark 自定义方法
/**
 *  登录
 */
-(void)userLogin{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"登录中...";
    
    //构造参数
    NSString *url=@"login_do";
    NSDictionary *parameters=@{@"token":Token,
                               @"uname":[self.phoneText text],
                               @"upass":[self.passwordText text]};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            //缓存用户信息
            self.login=@"1";
            self.uid=CheckNull([[dic objectForKey:@"user"] objectForKey:@"uid"]);
            self.userName=CheckNull([[dic objectForKey:@"user"] objectForKey:@"uname"]);
            self.phone=CheckNull([[dic objectForKey:@"user"] objectForKey:@"tel"]);
            self.nickName=CheckNull([[dic objectForKey:@"user"] objectForKey:@"nickname"]);
            self.sex=CheckNull([[dic objectForKey:@"user"] objectForKey:@"sex"]);
            self.mail=CheckNull([[dic objectForKey:@"user"] objectForKey:@"mail"]);
            self.province=CheckNull([[dic objectForKey:@"user"] objectForKey:@"province"]);
            self.city=CheckNull([[dic objectForKey:@"user"] objectForKey:@"city"]);
            self.area=CheckNull([[dic objectForKey:@"user"] objectForKey:@"area"]);
            self.address=CheckNull([[dic objectForKey:@"user"] objectForKey:@"address"]);
            
            //获取购物车数据
            [self loadShoppingCartData];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [CAlertView alertMessage:error];
        }
        
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  获取购物车数据
 */
-(void)loadShoppingCartData{
    //构造参数
    NSString *url=@"cart";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];//添加到购物车中的商品列表
            
            if (array.count>0) {//服务器上购物车有数据
                //清空本地缓存购物车数据
                [self clearShoppingCart];
                
                //把服务器上最新的购物车数据添加到本地缓存中
                for (NSDictionary *dic in array) {
                    for (int i=0; i<[[dic objectForKey:@"num"] integerValue]; i++) {
                        [self setShoppingCount:[dic objectForKey:@"num"] sid:[dic objectForKey:@"sid"] fid:[[dic objectForKey:@"gs"] objectForKey:@"fid"] isAdd:YES];
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

#pragma mark 按钮事件
/**
 *  登录按钮
 *
 *  @param sender
 */
-(void)loginButton:(UIButton *)sender{
    if ([self.phoneText.text isEmpty]) {
        [CAlertView alertMessage:@"手机号不能为空"];
        [self.phoneText becomeFirstResponder];
        
        return;
    }
    if (![self.phoneText.text isValidPhoneNumber]) {
        [CAlertView alertMessage:@"手机号格式不正确"];
        [self.phoneText becomeFirstResponder];
        
        return;
    }
    if ([self.passwordText.text isEmpty]) {
        [CAlertView alertMessage:@"密码不能为空"];
        [self.passwordText becomeFirstResponder];
        
        return;
    }
    
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    //登录
    [self userLogin];
}

/**
 *  忘记密码按钮
 *
 *  @param sender
 */
-(void)forgetPasswordButton:(UIButton *)sender{
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    ULFindPasswordViewController *vc=[ULFindPasswordViewController new];
    vc.title=@"找回密码";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  注册按钮
 *
 *  @param sender
 */
-(void)registerButton:(UIButton *)sender{
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    ULRegisterViewController *vc=[ULRegisterViewController new];
    vc.title=@"注册";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  快速登录按钮
 *
 *  @param sender
 */
-(void)quickLoginButton:(UIButton *)sender{
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    ULQuickLoginViewController *vc=[ULQuickLoginViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 键盘弹出、隐藏通知
/**
 *  键盘弹出回调
 *
 *  @param notification 通知信息
 */
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat viewHeight=0;
    if (self.phoneText.isFirstResponder) {
        viewHeight=self.phoneText.bottom;
    }
    else if (self.passwordText.isFirstResponder){
        viewHeight=self.loginButton.bottom;
    }
    
    //自适应代码
    CGFloat offset=self.contentView.height-viewHeight-kbSize.height;
    if (offset<=0) {//view和键盘有重合
        [UIView animateWithDuration:0.4 animations:^{
                        self.contentView.transform=CGAffineTransformMakeTranslation(0, offset-20);
        }];
    }
    else{
        [UIView animateWithDuration:0.4 animations:^{
            self.contentView.transform=CGAffineTransformIdentity;
        }];
    }
}

/**
 *  键盘消失回调
 *
 *  @param notification 通知信息
 */
- (void)keyboardWillHide:(NSNotification *)notification{
    //自适应代码
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.transform=CGAffineTransformIdentity;
    }];
}

#pragma mark 重写屏幕Touch方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
