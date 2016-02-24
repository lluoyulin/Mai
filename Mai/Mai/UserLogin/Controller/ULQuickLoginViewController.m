//
//  ULQuickLoginViewController.m
//  Mai
//
//  Created by freedom on 16/2/18.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "ULQuickLoginViewController.h"

#import "Const.h"
#import "CTextField.h"
#import "NSObject+HttpTask.h"
#import "NSObject+Utils.h"
#import "NSString+Utils.h"
#import "CAlertView.h"

#import "MBProgressHUD.h"

@interface ULQuickLoginViewController (){
    NSString *_code;//验证码
    NSInteger _secs;//秒数
}

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIButton *loginButton;//登录按钮
@property(nonatomic,strong) UIButton *getCodeButton;//获取验证码按钮
@property(nonatomic,strong) CTextField *phoneText;//手机号
@property(nonatomic,strong) CTextField *codeText;//验证码

@property(nonatomic,strong) NSTimer *timer;//轮询对象

@end

@implementation ULQuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"手机号快速登录";
    
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
    self.getCodeButton.frame=CGRectMake(self.contentView.width-100-15, 50, 100, 45);
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
    self.phoneText=[[CTextField alloc] initWithFrame:CGRectMake(15, 50, self.contentView.width-15-15-self.getCodeButton.width-8, 45)];
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
    self.codeText=[[CTextField alloc] initWithFrame:CGRectMake(self.phoneText.left, self.phoneText.bottom+20, self.contentView.width-15-15, self.phoneText.height)];
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
    
    //登录按钮
    self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame=CGRectMake(self.codeText.left, self.codeText.bottom+30, self.codeText.width, 45);
    self.loginButton.layer.masksToBounds=YES;
    self.loginButton.layer.cornerRadius=2;
    self.loginButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [self.loginButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.loginButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.showsTouchWhenHighlighted=YES;
    self.loginButton.backgroundColor=ThemeYellow;
    [self.contentView addSubview:self.loginButton];
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
    NSString *url=@"code";
    NSDictionary *parameters=@{@"token":Token,
                               @"mobile":self.phoneText.text};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            _code=[dic objectForKey:@"code"];
            
            self.phoneText.accessibilityValue=[self.phoneText text];
            
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
 *  登录
 */
-(void)userLogin{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"登录中...";
    
    //构造参数
    NSString *url=@"tel_login";
    NSDictionary *parameters=@{@"token":Token,
                               @"mobile":self.phoneText.text};
    
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
            self.userHead=CheckNull([[dic objectForKey:@"user"] objectForKey:@"headimg"]);
            
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
    if (![self.phoneText.text isEqualToString:self.phoneText.accessibilityValue]) {
        [CAlertView alertMessage:@"手机号和获取验证码时不一致"];
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
    if (![self.codeText.text isEqualToString:[NSString stringWithFormat:@"%@",_code]]) {
        [CAlertView alertMessage:@"验证码不正确"];
        [self.codeText becomeFirstResponder];
        
        return;
    }
    
    [self.phoneText resignFirstResponder];
    [self.codeText resignFirstResponder];
    
    //登录
    [self userLogin];
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
    
    [self.phoneText resignFirstResponder];
    [self.codeText resignFirstResponder];
    
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
        viewHeight=self.loginButton.bottom;
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
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
