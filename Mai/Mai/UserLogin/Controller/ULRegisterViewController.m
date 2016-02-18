//
//  ULRegisterViewController.m
//  Mai
//
//  Created by freedom on 16/2/18.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "ULRegisterViewController.h"

#import "Const.h"
#import "CTextField.h"
#import "NSObject+HttpTask.h"
#import "NSObject+Utils.h"
#import "NSString+Utils.h"
#import "CAlertView.h"

#import "MBProgressHUD.h"

@interface ULRegisterViewController (){
    NSString *_code;//验证码
    NSInteger _secs;//秒数
}

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIButton *registerButton;//注册按钮
@property(nonatomic,strong) UIButton *getCodeButton;//获取验证码按钮
@property(nonatomic,strong) CTextField *phoneText;//手机号
@property(nonatomic,strong) CTextField *codeText;//验证码
@property(nonatomic,strong) CTextField *passwordText;//密码
@property(nonatomic,strong) CTextField *inviteCodeText;//邀请码

@property(nonatomic,strong) NSTimer *timer;//轮询对象

@end

@implementation ULRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //初始化视图
    [self initView];
    
    _secs=60;//设置倒计时初始值
}

#pragma mark 初始化视图
/**
 *  初始化视图
 */
-(void)initView{
    self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.contentView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.contentView];
    
    //获取验证码按钮
    self.getCodeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeButton.frame=CGRectMake(self.contentView.width-100-15, 20, 100, 45);
    self.getCodeButton.layer.masksToBounds=YES;
    self.getCodeButton.layer.cornerRadius=2;
    self.getCodeButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.getCodeButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeButton addTarget:self action:@selector(getCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeButton.showsTouchWhenHighlighted=YES;
    self.getCodeButton.backgroundColor=ThemeYellow;
    [self.contentView addSubview:self.getCodeButton];
    
    //手机号
    self.phoneText=[[CTextField alloc] initWithFrame:CGRectMake(15, 20, self.contentView.width-15-15-self.getCodeButton.width-8, 45)];
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
    
    //验证码
    self.codeText=[[CTextField alloc] initWithFrame:CGRectMake(self.phoneText.left, self.phoneText.bottom+10, self.contentView.width-15-15, self.phoneText.height)];
    self.codeText.textColor=ThemeBlack;
    self.codeText.backgroundColor=ThemeWhite;
    self.codeText.font=[UIFont systemFontOfSize:14.0];
    self.codeText.placeholder=@"输入验证码";
    self.codeText.layer.masksToBounds=YES;
    self.codeText.layer.cornerRadius=2;
    self.codeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.codeText.leftViewMode=UITextFieldViewModeAlways;
    self.codeText.keyboardType=UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.codeText];
    
    //添加验证码文本框左视图
    UIImageView *codeLeftImage=[[UIImageView alloc] initWithFrame:phoneLeftImage.frame];
    codeLeftImage.image=[UIImage imageNamed:@"user_login_code"];
    self.codeText.leftView=codeLeftImage;
    
    //密码
    self.passwordText=[[CTextField alloc] initWithFrame:CGRectMake(self.codeText.left, self.codeText.bottom+10, self.codeText.width, self.codeText.height)];
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
    
    //邀请码
    self.inviteCodeText=[[CTextField alloc] initWithFrame:CGRectMake(self.passwordText.left, self.passwordText.bottom+10, self.passwordText.width, self.passwordText.height)];
    self.inviteCodeText.textColor=ThemeBlack;
    self.inviteCodeText.backgroundColor=ThemeWhite;
    self.inviteCodeText.font=[UIFont systemFontOfSize:14.0];
    self.inviteCodeText.placeholder=@"输入邀请码(可以不填)";
    self.inviteCodeText.layer.masksToBounds=YES;
    self.inviteCodeText.layer.cornerRadius=2;
    self.inviteCodeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.inviteCodeText.leftViewMode=UITextFieldViewModeAlways;
    [self.contentView addSubview:self.inviteCodeText];
    
    //添加邀请码文本框左视图
    UIImageView *inviteCodeLeftImage=[[UIImageView alloc] initWithFrame:phoneLeftImage.frame];
    inviteCodeLeftImage.image=[UIImage imageNamed:@"user_login_invitation_code"];
    self.inviteCodeText.leftView=inviteCodeLeftImage;
    
    //注册按钮
    self.registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.frame=CGRectMake(self.inviteCodeText.left, self.inviteCodeText.bottom+30, self.inviteCodeText.width, 45);
    self.registerButton.layer.masksToBounds=YES;
    self.registerButton.layer.cornerRadius=2;
    self.registerButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [self.registerButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButton:) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.showsTouchWhenHighlighted=YES;
    self.registerButton.backgroundColor=ThemeYellow;
    [self.contentView addSubview:self.registerButton];
}

#pragma mark 自定义方法
/**
 *  短信倒计时
 */
-(void)startCountDown:(NSTimer *)timer{
    _secs--;
    
    if (_secs==0) {
        _secs=60;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.getCodeButton setEnabled:YES];
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else{
        [self.getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_secs] forState:UIControlStateNormal];
    }
}

/**
 *  获取验证码
 */
-(void)getCode{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"获取中...";
    
    //构造参数
    NSString *url=@"reg_code";
    NSDictionary *parameters=@{@"token":Token,
                               @"mobile":self.phoneText.text};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            _code=[dic objectForKey:@"code"];
            
            if(self.timer) {
                [self.timer setFireDate:[NSDate distantPast]];//开启定时器
            }
            else{
                self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown:) userInfo:nil repeats:YES];
            }
        }
        else{
            
            self.getCodeButton.enabled=YES;
            
            [CAlertView alertMessage:error];
        }
        
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        
        self.getCodeButton.enabled=YES;
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  注册
 */
-(void)regist{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"注册中...";
    
    //构造参数
    NSString *url=@"reg_code";
    NSDictionary *parameters=@{@"token":Token,
                               @"mobile":self.phoneText.text};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
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

#pragma mark 按钮事件
/**
 *  注册按钮
 *
 *  @param sender
 */
-(void)registerButton:(UIButton *)sender{
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
    if ([self.codeText.text isEmpty]) {
        [CAlertView alertMessage:@"验证码不能为空"];
        [self.codeText becomeFirstResponder];
        
        return;
    }
    if (![self.codeText.text isValidCodeNumber]) {
        [CAlertView alertMessage:@"验证码格式不正确"];
        [self.codeText becomeFirstResponder];
        
        return;
    }
    if ([self.passwordText.text isEmpty]) {
        [CAlertView alertMessage:@"密码不能为空"];
        [self.passwordText becomeFirstResponder];
        
        return;
    }
    
    [self.phoneText resignFirstResponder];
    [self.codeText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.inviteCodeText resignFirstResponder];
    
    //注册
    [self regist];
}

/**
 *  获取验证码按钮
 *
 *  @param sender
 */
-(void)getCodeButton:(UIButton *)sender{
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
    
    self.getCodeButton.enabled=NO;
    
    //获取验证码
    [self getCode];
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
    else if (self.codeText.isFirstResponder){
        viewHeight=self.codeText.bottom;
    }
    else if (self.passwordText.isFirstResponder){
        viewHeight=self.registerButton.bottom;
    }
    else if (self.inviteCodeText.isFirstResponder){
        viewHeight=self.registerButton.bottom;
    }
    
    //自适应代码
    CGFloat offset=offset=self.contentView.height-viewHeight-kbSize.height;
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
    [self.codeText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.inviteCodeText resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
