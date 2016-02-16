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

@interface UCAddressDetailsViewController ()

@property(nonatomic,strong) UIView *contentView;//内容视图
@property(nonatomic,strong) UILabel *nameTagLabel;//姓名标签
@property(nonatomic,strong) UITextField *nanmeText;//姓名
@property(nonatomic,strong) UILabel *phoneTagLabel;//手机号标签
@property(nonatomic,strong) UITextField *phoneText;//手机号
@property(nonatomic,strong) UILabel *sexTagLabel;//性别标签
@property(nonatomic,strong) UITextField *sexText;//性别
@property(nonatomic,strong) UILabel *addressTagLabel;//地址标签
@property(nonatomic,strong) UITextField *addressText;//地址

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
    
    //性别
    self.sexText=[[UITextField alloc] initWithFrame:CGRectMake(self.nanmeText.left, phoneLine.bottom+5, self.nanmeText.width, self.nanmeText.height)];
    self.sexText.placeholder=@"男";
    self.sexText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.sexText.font=[UIFont systemFontOfSize:14.0];
    self.sexText.textColor=ThemeGray;
    self.sexText.enabled=NO;
    [self.contentView addSubview:self.sexText];
    
    //设置性别的右视图
    UIImageView *rightImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    rightImage.image=[UIImage imageNamed:@"order_address_arrow"];
    self.sexText.rightView=rightImage;
    self.sexText.rightViewMode=UITextFieldViewModeAlways;
    
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

#pragma mark 重写屏幕Touch方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nanmeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.sexText resignFirstResponder];
    [self.addressText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
