//
//  UCAddressDetailsViewController.m
//  Mai
//
//  Created by freedom on 16/2/16.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCAddressDetailsViewController.h"

#import "Const.h"
#import "NSObject+HttpTask.h"
#import "UILabel+AutoFrame.h"
#import "NSString+Utils.h"
#import "CAlertView.h"
#import "NSObject+Utils.h"

#import "MBProgressHUD.h"

@interface UCAddressDetailsViewController ()

@property(nonatomic,strong) UIButton *navigationSaveButton;//保存按钮

@property(nonatomic,strong) UIView *contentView;//内容视图
@property(nonatomic,strong) UILabel *nameTagLabel;//姓名标签
@property(nonatomic,strong) UITextField *nanmeText;//姓名
@property(nonatomic,strong) UILabel *phoneTagLabel;//手机号标签
@property(nonatomic,strong) UITextField *phoneText;//手机号
@property(nonatomic,strong) UILabel *sexTagLabel;//性别标签
@property(nonatomic,strong) UIButton *sexButton;//性别按钮
@property(nonatomic,strong) UILabel *addressTagLabel;//地址标签
@property(nonatomic,strong) UITextField *addressText;//地址

@property(nonatomic,strong) UIPickerView *sexPicker;//性别选择器

@end

@implementation UCAddressDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //初始化内容视图
    [self initContentView];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化数据
    [self initData];
}

#pragma mark 初始化视图
/**
 *  初始化内容视图
 */
-(void)initContentView{
    //内容视图
    self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+10, SCREEN_WIDTH, 180)];
    self.contentView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.contentView];
    
    //顶部分割线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.contentView addSubview:topLine];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5)];
    bottomLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.contentView addSubview:bottomLine];
    
    //姓名标签
    self.nameTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 0, 16)];
    self.nameTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.nameTagLabel.textColor=ThemeBlack;
    [self.nameTagLabel setTextWidth:@"我的姓名:" size:CGSizeMake(100,16)];
    [self.contentView addSubview:self.nameTagLabel];
    
    //姓名
    self.nanmeText=[[UITextField alloc] initWithFrame:CGRectMake(self.nameTagLabel.right+15, 5, self.contentView.width-self.nameTagLabel.right-15-15, 35)];
    self.nanmeText.placeholder=@"请输入您的姓名";
    self.nanmeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.nanmeText.font=[UIFont systemFontOfSize:14.0];
    self.nanmeText.textColor=ThemeGray;
    [self.contentView addSubview:self.nanmeText];
    
    //姓名分割线
    UIView *nameLine=[[UIView alloc] initWithFrame:CGRectMake(self.nameTagLabel.left, self.nameTagLabel.bottom+14.5, self.contentView.width-15-15, 0.5)];
    nameLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.contentView addSubview:nameLine];
    
    //手机号标签
    self.phoneTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nameTagLabel.left, nameLine.bottom+14.5, 0, self.nameTagLabel.height)];
    self.phoneTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.phoneTagLabel.textColor=ThemeBlack;
    [self.phoneTagLabel setTextWidth:@"我的手机:" size:CGSizeMake(100,16)];
    [self.contentView addSubview:self.phoneTagLabel];
    
    //手机号
    self.phoneText=[[UITextField alloc] initWithFrame:CGRectMake(self.nanmeText.left, nameLine.bottom+5, self.nanmeText.width, self.nanmeText.height)];
    self.phoneText.placeholder=@"请输入您的手机号";
    self.phoneText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.phoneText.font=[UIFont systemFontOfSize:14.0];
    self.phoneText.textColor=ThemeGray;
    self.phoneText.keyboardType=UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.phoneText];
    
    //手机号分割线
    UIView *phoneLine=[[UIView alloc] initWithFrame:CGRectMake(nameLine.left, self.phoneTagLabel.bottom+14.5, nameLine.width, nameLine.height)];
    phoneLine.backgroundColor=nameLine.backgroundColor;
    [self.contentView addSubview:phoneLine];
    
    //性别标签
    self.sexTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nameTagLabel.left, phoneLine.bottom+14.5, 0, self.nameTagLabel.height)];
    self.sexTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.sexTagLabel.textColor=ThemeBlack;
    [self.sexTagLabel setTextWidth:@"我的性别:" size:CGSizeMake(100,16)];
    [self.contentView addSubview:self.sexTagLabel];
    
    //性别按钮
    self.sexButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.sexButton.frame=CGRectMake(self.nanmeText.left, phoneLine.bottom+5, self.nanmeText.width, self.nanmeText.height);
    self.sexButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.sexButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
    self.sexButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.sexButton addTarget:self action:@selector(sexButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sexButton];
    
    //设置性别按钮的右边图片
    UIImageView *rightImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.sexButton.width-16, (self.sexButton.height-16)/2, 16, 16)];
    rightImage.image=[UIImage imageNamed:@"order_address_arrow"];
    [self.sexButton addSubview:rightImage];
    
    //性别分割线
    UIView *sexLine=[[UIView alloc] initWithFrame:CGRectMake(nameLine.left, self.sexTagLabel.bottom+14.5, nameLine.width, nameLine.height)];
    sexLine.backgroundColor=nameLine.backgroundColor;
    [self.contentView addSubview:sexLine];
    
    //地址标签
    self.addressTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nameTagLabel.left, sexLine.bottom+14.5, 0, self.nameTagLabel.height)];
    self.addressTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.addressTagLabel.textColor=ThemeBlack;
    [self.addressTagLabel setTextWidth:@"我的地址:" size:CGSizeMake(100,16)];
    [self.contentView addSubview:self.addressTagLabel];
    
    //地址
    self.addressText=[[UITextField alloc] initWithFrame:CGRectMake(self.nanmeText.left, sexLine.bottom+5, self.nanmeText.width, self.nanmeText.height)];
    self.addressText.placeholder=@"请输入您所在的宿舍地址";
    self.addressText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.addressText.font=[UIFont systemFontOfSize:14.0];
    self.addressText.textColor=ThemeGray;
    [self.contentView addSubview:self.addressText];
}

/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏删除按钮
    self.navigationSaveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationSaveButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationSaveButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.navigationSaveButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.navigationSaveButton addTarget:self action:@selector(navigationSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:self.navigationSaveButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

#pragma mark 按钮事件
/**
 *  性别按钮
 *
 *  @param sender
 */
-(void)sexButton:(UIButton *)sender{
    if (!self.sexPicker) {
        self.sexPicker=[[UIPickerView alloc] init];
        self.sexPicker.frame=CGRectMake(0, SCREEN_HEIGHT-216, SCREEN_WIDTH, self.sexPicker.height);
        self.sexPicker.delegate=self;
        self.sexPicker.dataSource=self;
        self.sexPicker.backgroundColor=UIColorFromRGB(0xf5f5f5);
    }
    
    [self.nanmeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.addressText resignFirstResponder];
    [self.sexPicker removeFromSuperview];
    
    [self.view addSubview:self.sexPicker];
}

/**
 *  保存按钮
 *
 *  @param sender
 */
-(void)navigationSaveButton:(UIButton *)sender{
    [self.nanmeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.addressText resignFirstResponder];
    [self.sexPicker removeFromSuperview];
    
    if ([self.nanmeText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        [CAlertView alertMessage:@"我的姓名不能为空"];
        [self.nanmeText becomeFirstResponder];
        return;
    }
    if ([self.phoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        [CAlertView alertMessage:@"我的手机不能为空"];
        [self.phoneText becomeFirstResponder];
        return;
    }
    if (![self.phoneText.text isValidPhoneNumber]) {
        [CAlertView alertMessage:@"手机格式不正确"];
        [self.phoneText becomeFirstResponder];
        return;
    }
    if ([self.addressText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        [CAlertView alertMessage:@"我的地址不能为空"];
        [self.addressText becomeFirstResponder];
        return;
    }
    
    if (self.dic) {
        //编辑数据
        [self editData];
    }
    else{
        //添加数据
        [self addData];
    }
}

#pragma mark 自定义方法
/**
 *  初始化数据
 */
-(void)initData{
    if (self.dic) {
        self.nanmeText.text=[self.dic objectForKey:@"name"];
        self.phoneText.text=[self.dic objectForKey:@"mobile"];
        [self.sexButton setTitle:[[self.dic objectForKey:@"sex"] integerValue]==1 ? @"男" : @"女" forState:UIControlStateNormal];
        self.addressText.text=[self.dic objectForKey:@"address"];
    }
}

/**
 *  添加数据
 */
-(void)addData{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //构造参数
    NSString *url=@"address_add";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0",
                               @"name":self.nanmeText.text,
                               @"mobile":self.phoneText.text,
                               @"sex":[self.sexButton.titleLabel.text isEqualToString:@"男"] ? @"1" : @"2",
                               @"shenfen":@"1",
                               @"shiqu":@"1",
                               @"address":self.addressText.text};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            hud.mode=MBProgressHUDModeText;
            hud.labelText=@"提交成功";
            
            //延迟1.5s执行方法
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
        }
        else{
            [hud hide:YES];
            
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  编辑数据
 */
-(void)editData{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //构造参数
    NSString *url=@"address_edit_do";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0",
                               @"id":[self.dic objectForKey:@"id"],
                               @"name":self.nanmeText.text,
                               @"mobile":self.phoneText.text,
                               @"sex":[self.sexButton.titleLabel.text isEqualToString:@"男"] ? @"1" : @"2",
                               @"shenfen":@"1",
                               @"shiqu":@"1",
                               @"address":self.addressText.text};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            hud.mode=MBProgressHUDModeText;
            hud.labelText=@"提交成功";
            
            //延迟1.5s执行方法
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
        }
        else{
            [hud hide:YES];
            
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  返回上层
 */
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //自适应代码
    CGFloat offset=self.contentView.height-self.contentView.bottom-40-kbSize.height;
    if (offset<=0) {//view和键盘有重合
        [UIView animateWithDuration:0.4 animations:^{
//            self.contentView.transform=CGAffineTransformMakeTranslation(0, offset-20);
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

#pragma mark pickerview委托
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0) {
        return @"男";
    }
    else{
        return @"女";
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row==0) {
        [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
    }
    else if(row==1)
    {
        [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
    }
}

#pragma mark 重写屏幕Touch方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nanmeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.addressText resignFirstResponder];
    [self.sexPicker removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
