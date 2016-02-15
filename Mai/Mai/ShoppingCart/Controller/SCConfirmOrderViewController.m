//
//  SCConfirmOrderViewController.m
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "SCConfirmOrderViewController.h"

#import "Const.h"

static const CGFloat PayViewHeight=50.0;

@interface SCConfirmOrderViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;//订单信息视图

@property(nonatomic,strong) UIButton *addressButton;//地址按钮
@property(nonatomic,strong) UIImageView *addressFlagImage;//地址标志
@property(nonatomic,strong) UIImageView *selectAddressImage;//选择地址标志
@property(nonatomic,strong) UILabel *consigneeLabel;//收货人
@property(nonatomic,strong) UILabel *consigneeAddressLabel;//收货地址

@property(nonatomic,strong) UIView *goodsView;//商品视图

@property(nonatomic,strong) UIView *payView;//支付操作视图

@end

@implementation SCConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"填写订单";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //初始化订单信息视图
    [self initScrollView];
    
    //初始化支付操作视图
    [self initPayView];
}

#pragma mark 初始化视图
/**
 *  初始化订单信息视图
 */
-(void)initScrollView{
    //订单信息视图
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-10-PayViewHeight)];
    self.scrollView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.scrollView.contentSize=CGSizeMake(self.scrollView.width, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    //初始化地址视图
    [self initAddressView];
    
    //初始化商品视图
    [self initGoodsView];
}

/**
 *  初始化地址视图
 */
-(void)initAddressView{
    //地址按钮
    self.addressButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addressButton.frame=CGRectMake(0, 10, self.scrollView.width, 74);
    [self.addressButton setBackgroundImage:[UIImage imageNamed:@"order_address_bg"] forState:UIControlStateNormal];
    [self.addressButton addTarget:self action:@selector(addressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.addressButton];
    
    //地址标志
    self.addressFlagImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.addressButton.height-22)/2, 22, 22)];
    self.addressFlagImage.image=[UIImage imageNamed:@"order_address_flag"];
    [self.addressButton addSubview:self.addressFlagImage];
    
    //选择地址标志
    self.selectAddressImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.addressButton.width-15-16, (self.addressButton.height-16)/2, 16, 16)];
    self.selectAddressImage.image=[UIImage imageNamed:@"order_address_arrow"];
    [self.addressButton addSubview:self.selectAddressImage];
    
    //收货人
    self.consigneeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.addressFlagImage.right+10, (self.addressButton.height-16-8-15)/2, self.addressButton.width-self.addressFlagImage.right-10-10-self.selectAddressImage.width-15, 16)];
    self.consigneeLabel.font=[UIFont systemFontOfSize:14.0];
    self.consigneeLabel.textColor=ThemeBlack;
    self.consigneeLabel.text=@"收货人：罗玉林（男）| 18608515145";
    [self.addressButton addSubview:self.consigneeLabel];
    
    //收货地址
    self.consigneeAddressLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.consigneeLabel.left, self.consigneeLabel.bottom+8, self.consigneeLabel.width, 15)];
    self.consigneeAddressLabel.font=[UIFont systemFontOfSize:13.0];
    self.consigneeAddressLabel.textColor=ThemeGray;
    self.consigneeAddressLabel.text=@"收货地址：贵大10号楼103室";
    [self.addressButton addSubview:self.consigneeAddressLabel];
}

/**
 *  初始化商品视图
 */
-(void)initGoodsView{
    //商品视图
    self.goodsView=[[UIView alloc] initWithFrame:CGRectMake(0, self.addressButton.bottom+10, self.addressButton.width, 90)];
    self.goodsView.backgroundColor=ThemeWhite;
    [self.scrollView addSubview:self.goodsView];
}

/**
 *  初始化支付操作视图
 */
-(void)initPayView{
    //支付操作视图
    self.payView=[[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom+10, self.scrollView.width, PayViewHeight)];
    self.payView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.payView];
}

#pragma mark 按钮事件
/**
 *  地址按钮
 *
 *  @param sender
 */
-(void)addressButton:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
