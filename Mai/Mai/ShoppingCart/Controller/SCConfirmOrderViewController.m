//
//  SCConfirmOrderViewController.m
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "SCConfirmOrderViewController.h"

#import "Const.h"

#import "SCGoodsListViewController.h"

static const CGFloat PayViewHeight=50.0;

@interface SCConfirmOrderViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;//订单信息视图

@property(nonatomic,strong) UIButton *addressButton;//地址按钮
@property(nonatomic,strong) UIImageView *addressFlagImage;//地址标志
@property(nonatomic,strong) UIImageView *selectAddressImage;//选择地址标志
@property(nonatomic,strong) UILabel *consigneeLabel;//收货人
@property(nonatomic,strong) UILabel *consigneeAddressLabel;//收货地址

@property(nonatomic,strong) UIView *goodsView;//商品视图

@property(nonatomic,strong) UIView *payWayView;//支付方式视图
@property(nonatomic,strong) UILabel *onlinePayTagLabel;//在线支付标签
@property(nonatomic,strong) UIButton *onlinePayButton;//在线支付按钮
@property(nonatomic,strong) UILabel *offlinePayTagLabel;//线下支付标签
@property(nonatomic,strong) UIButton *offlinePayButton;//线下支付按钮

@property(nonatomic,strong) UIView *orderInfoView;//订单信息视图
@property(nonatomic,strong) UILabel *sumTagLabel;//商品总价标签
@property(nonatomic,strong) UILabel *sumLabel;//商品总价
@property(nonatomic,strong) UILabel *tipTagLabel;//服务费标签
@property(nonatomic,strong) UILabel *tipLabel;//服务费
@property(nonatomic,strong) UILabel *nonTipTagLabel;//减免服务费标签
@property(nonatomic,strong) UILabel *nonTipLabel;//减免服务费
@property(nonatomic,strong) UILabel *payTagLabel;//实付款标签
@property(nonatomic,strong) UILabel *payLabel;//实付款
@property(nonatomic,strong) UITextField *remarkText;//备注

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
    
    //初始化支付方式视图
    [self initPayWayView];
    
    //初始化订单信息视图
    [self initOrderInfoView];
    
    //计算scrollView内容高度
    CGRect rect=CGRectZero;
    for (UIView *subView in self.scrollView.subviews) {
        rect=CGRectUnion(rect, subView.frame);
    }
    self.scrollView.contentSize=CGSizeMake(self.scrollView.width, rect.size.height);
}

#pragma mark 初始化视图
/**
 *  初始化订单信息视图
 */
-(void)initScrollView{
    //订单信息视图
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-10-PayViewHeight)];
    self.scrollView.backgroundColor=UIColorFromRGB(0xf5f5f5);
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
    self.consigneeLabel.text=@"收货人：罗玉林(男) | 18608515145";
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
    self.goodsView.layer.masksToBounds=YES;
    [self.scrollView addSubview:self.goodsView];
    
    //商品列表
    SCGoodsListViewController *goodsListVC=[SCGoodsListViewController new];
    [self addChildViewController:goodsListVC];
    [goodsListVC didMoveToParentViewController:self];
    
    [self.goodsView addSubview:goodsListVC.view];
    
    //顶部分割线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.goodsView.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.goodsView addSubview:topLine];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.goodsView.height-0.5, self.goodsView.width, 0.5)];
    bottomLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.goodsView addSubview:bottomLine];
}

/**
 *  初始化支付方式视图
 */
-(void)initPayWayView{
    //支付方式视图
    self.payWayView=[[UIView alloc] initWithFrame:CGRectMake(0, self.goodsView.bottom+10, self.goodsView.width, 83)];
    self.payWayView.backgroundColor=ThemeWhite;
    [self.scrollView addSubview:self.payWayView];
    
    //顶部分割线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.payWayView.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.payWayView addSubview:topLine];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.payWayView.height-0.5, self.payWayView.width, 0.5)];
    bottomLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.payWayView addSubview:bottomLine];
    
    //在线支付标签
    self.onlinePayTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 16)];
    self.onlinePayTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.onlinePayTagLabel.textColor=ThemeBlack;
    self.onlinePayTagLabel.text=@"在线支付";
    [self.payWayView addSubview:self.onlinePayTagLabel];
    
    //在线支付按钮
    self.onlinePayButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.onlinePayButton.frame=CGRectMake(self.payWayView.width-44-2, 0, 44, 40);
    self.onlinePayButton.tintColor=ThemeRed;
    [self.onlinePayButton setImage:[UIImage imageNamed:@"order_pay_select"] forState:UIControlStateNormal];
    [self.onlinePayButton setImage:[[UIImage imageNamed:@"order_pay_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.onlinePayButton addTarget:self action:@selector(onlinePayButton:) forControlEvents:UIControlEventTouchUpInside];
    self.onlinePayButton.selected=YES;
    [self.payWayView addSubview:self.onlinePayButton];
    
    //线下支付标签
    self.offlinePayTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.onlinePayTagLabel.left, self.onlinePayTagLabel.bottom+20, self.onlinePayTagLabel.width, self.onlinePayTagLabel.height)];
    self.offlinePayTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.offlinePayTagLabel.textColor=ThemeBlack;
    self.offlinePayTagLabel.text=@"货到付款";
    [self.payWayView addSubview:self.offlinePayTagLabel];
    
    //线下支付按钮
    self.offlinePayButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.offlinePayButton.frame=CGRectMake(self.onlinePayButton.left, self.onlinePayButton.bottom+3, self.onlinePayButton.width, self.onlinePayButton.height);
    self.offlinePayButton.tintColor=ThemeRed;
    [self.offlinePayButton setImage:[UIImage imageNamed:@"order_pay_select"] forState:UIControlStateNormal];
    [self.offlinePayButton setImage:[[UIImage imageNamed:@"order_pay_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.offlinePayButton addTarget:self action:@selector(offlinePayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.payWayView addSubview:self.offlinePayButton];
}

/**
 *  初始化订单信息视图
 */
-(void)initOrderInfoView{
    //订单信息视图
    self.orderInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.payWayView.bottom+10, self.payWayView.width, 236)];
    self.orderInfoView.backgroundColor=ThemeWhite;
    [self.scrollView addSubview:self.orderInfoView];
    
    //顶部分割线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.orderInfoView.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.orderInfoView addSubview:topLine];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.orderInfoView.height-0.5, self.orderInfoView.width, 0.5)];
    bottomLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.orderInfoView addSubview:bottomLine];
    
    //商品总价标签
    self.sumTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 14, 80, 16)];
    self.sumTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.sumTagLabel.textColor=ThemeBlack;
    self.sumTagLabel.text=@"商品总价";
    [self.orderInfoView addSubview:self.sumTagLabel];
    
    //商品总价
    self.sumLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.orderInfoView.width-100-15, self.sumTagLabel.top, 100, self.sumTagLabel.height)];
    self.sumLabel.font=self.sumTagLabel.font;
    self.sumLabel.textColor=self.sumTagLabel.textColor;
    self.sumLabel.text=@"¥12";
    self.sumLabel.textAlignment=NSTextAlignmentRight;
    [self.orderInfoView addSubview:self.sumLabel];
    
    //商品总价分割线
    UIView *sumLine=[[UIView alloc] initWithFrame:CGRectMake(self.sumTagLabel.left, self.sumTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    sumLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.orderInfoView addSubview:sumLine];
    
    //服务费标签
    self.tipTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sumTagLabel.left, sumLine.bottom+14, self.sumTagLabel.width, self.sumTagLabel.height)];
    self.tipTagLabel.font=self.sumTagLabel.font;
    self.tipTagLabel.textColor=self.sumTagLabel.textColor;
    self.tipTagLabel.text=@"服务费";
    [self.orderInfoView addSubview:self.tipTagLabel];
    
    //服务费
    self.tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sumLabel.left, self.tipTagLabel.top, 100, self.tipTagLabel.height)];
    self.tipLabel.font=self.tipTagLabel.font;
    self.tipLabel.textColor=self.tipTagLabel.textColor;
    self.tipLabel.text=@"¥12";
    self.tipLabel.textAlignment=NSTextAlignmentRight;
    [self.orderInfoView addSubview:self.tipLabel];
    
    //服务费分割线
    UIView *tipLine=[[UIView alloc] initWithFrame:CGRectMake(self.tipTagLabel.left, self.tipTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    tipLine.backgroundColor=sumLine.backgroundColor;
    [self.orderInfoView addSubview:tipLine];
    
    //减免服务费标签
    
    //减免服务费
    
    //实付款标签
    
    //实付款
    
    //备注
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

/**
 *  在线支付按钮
 *
 *  @param sender
 */
-(void)onlinePayButton:(UIButton *)sender{
    if (!sender.isSelected) {
        self.onlinePayButton.selected=YES;
        self.offlinePayButton.selected=NO;
    }
}

/**
 *  线下支付按钮
 *
 *  @param sender
 */
-(void)offlinePayButton:(UIButton *)sender{
    if (!sender.isSelected) {
        self.onlinePayButton.selected=NO;
        self.offlinePayButton.selected=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
