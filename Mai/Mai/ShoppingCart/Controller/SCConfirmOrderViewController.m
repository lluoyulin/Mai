//
//  SCConfirmOrderViewController.m
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "SCConfirmOrderViewController.h"

#import "Const.h"
#import "CKeyboardToolBar.h"
#import "NSObject+HttpTask.h"
#import "NSObject+Utils.h"
#import "CAlertView.h"

#import "SCGoodsListViewController.h"
#import "UCSelectAddressViewController.h"
#import "UCOrderDetailsViewController.h"

#import "MBProgressHUD.h"

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
@property(nonatomic,strong) UILabel *totalTagLabel;//合计文字
@property(nonatomic,strong) UILabel *totalLabel;//总价
@property(nonatomic,strong) UIButton *payButton;//支付按钮

@end

@implementation SCConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"填写订单";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //注册选择地址通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddress:) name:@"select_address" object:nil];
    
    //初始化订单信息视图
    [self initScrollView];
    
    //初始化数据
    [self initData];
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
    
    //初始化支付方式视图
    [self initPayWayView];
    
    //初始化订单信息视图
    [self initOrderInfoView];
    
    //初始化支付操作视图
    [self initPayView];
    
    //计算scrollView内容高度
    CGRect rect=CGRectZero;
    for (UIView *subView in self.scrollView.subviews) {
        rect=CGRectUnion(rect, subView.frame);
    }
    self.scrollView.contentSize=CGSizeMake(self.scrollView.width, rect.size.height);
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
    self.consigneeLabel.text=@"收货人：无";
    [self.addressButton addSubview:self.consigneeLabel];
    
    //收货地址
    self.consigneeAddressLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.consigneeLabel.left, self.consigneeLabel.bottom+8, self.consigneeLabel.width, 15)];
    self.consigneeAddressLabel.font=[UIFont systemFontOfSize:13.0];
    self.consigneeAddressLabel.textColor=ThemeGray;
    self.consigneeAddressLabel.text=@"收货地址：无";
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
    goodsListVC.type=@"1";
    goodsListVC.goodsList=[self.dic objectForKey:@"list"];
    
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
    self.onlinePayTagLabel.text=@"微信支付";
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
    self.sumLabel.text=@"¥0.00";
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
    self.tipLabel.text=@"¥0.00";
    self.tipLabel.textAlignment=NSTextAlignmentRight;
    [self.orderInfoView addSubview:self.tipLabel];
    
    //服务费分割线
    UIView *tipLine=[[UIView alloc] initWithFrame:CGRectMake(self.tipTagLabel.left, self.tipTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    tipLine.backgroundColor=sumLine.backgroundColor;
    [self.orderInfoView addSubview:tipLine];
    
    //减免服务费标签
    self.nonTipTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.tipTagLabel.left, tipLine.bottom+14, self.tipTagLabel.width, self.tipTagLabel.height)];
    self.nonTipTagLabel.font=self.tipTagLabel.font;
    self.nonTipTagLabel.textColor=self.tipTagLabel.textColor;
    self.nonTipTagLabel.text=@"减免服务费";
    [self.orderInfoView addSubview:self.nonTipTagLabel];
    
    //减免服务费
    self.nonTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sumLabel.left, self.nonTipTagLabel.top, 100, self.nonTipTagLabel.height)];
    self.nonTipLabel.font=self.nonTipTagLabel.font;
    self.nonTipLabel.textColor=self.nonTipTagLabel.textColor;
    self.nonTipLabel.text=@"-¥0.00";
    self.nonTipLabel.textAlignment=NSTextAlignmentRight;
    [self.orderInfoView addSubview:self.nonTipLabel];
    
    //减免服务费分割线
    UIView *nonTipLine=[[UIView alloc] initWithFrame:CGRectMake(self.nonTipTagLabel.left, self.nonTipTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    nonTipLine.backgroundColor=sumLine.backgroundColor;
    [self.orderInfoView addSubview:nonTipLine];
    
    //实付款标签
    self.payTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nonTipTagLabel.left, nonTipLine.bottom+14, self.nonTipTagLabel.width, self.nonTipTagLabel.height)];
    self.payTagLabel.font=self.tipTagLabel.font;
    self.payTagLabel.textColor=self.tipTagLabel.textColor;
    self.payTagLabel.text=@"实付款";
    [self.orderInfoView addSubview:self.payTagLabel];
    
    //实付款
    self.payLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sumLabel.left, self.payTagLabel.top, 100, self.payTagLabel.height)];
    self.payLabel.font=self.nonTipTagLabel.font;
    self.payLabel.textColor=self.nonTipTagLabel.textColor;
    self.payLabel.text=@"¥0.00";
    self.payLabel.textAlignment=NSTextAlignmentRight;
    [self.orderInfoView addSubview:self.payLabel];
    
    //减免服务费分割线
    UIView *payLine=[[UIView alloc] initWithFrame:CGRectMake(self.payTagLabel.left, self.payTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    payLine.backgroundColor=sumLine.backgroundColor;
    [self.orderInfoView addSubview:payLine];
    
    //备注
    self.remarkText=[[UITextField alloc] initWithFrame:CGRectMake(self.payTagLabel.left, payLine.bottom, payLine.width, 60)];
    self.remarkText.placeholder=@"给卖家留言...";
    self.remarkText.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.remarkText.font=[UIFont systemFontOfSize:14.0];
    self.remarkText.textColor=ThemeGray;
    [self.orderInfoView addSubview:self.remarkText];
    
    //添加键盘工具栏
    CKeyboardToolBar *keyboardToolBar=[CKeyboardToolBar new];
    keyboardToolBar.resignKeyboardBlock=^(){
        [self.remarkText resignFirstResponder];
    };
    
    self.remarkText.inputAccessoryView=keyboardToolBar;
}

/**
 *  初始化支付操作视图
 */
-(void)initPayView{
    //支付操作视图
    self.payView=[[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom+10, self.scrollView.width, PayViewHeight)];
    self.payView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.payView];
    
    //顶部线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.payView.width, 0.5)];
    line.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.payView addSubview:line];
    
    //去结算按钮
    self.payButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame=CGRectMake(self.payView.width-90-15, (self.payView.height-39)/2, 90, 39);
    self.payButton.layer.masksToBounds=YES;
    self.payButton.layer.cornerRadius=2;
    self.payButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    self.payButton.backgroundColor=ThemeRed;
    [self.payButton setTitleColor:ThemeWhite forState:UIControlStateNormal];
    [self.payButton setTitle:@"去结算(0)" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButton:) forControlEvents:UIControlEventTouchUpInside];
    self.payButton.showsTouchWhenHighlighted=YES;
    self.payButton.enabled=NO;
    [self.payView addSubview:self.payButton];
    
    //合计文字
    self.totalTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, (self.payView.height-16)/2, 60, 16)];
    self.totalTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.totalTagLabel.textColor=ThemeGray;
    self.totalTagLabel.text=@"实付款：";
    [self.payView addSubview:self.totalTagLabel];
    
    //总价
    self.totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.totalTagLabel.right,(self.payView.height-24)/2,self.payView.width-self.totalTagLabel.right-10-self.payButton.width-15,24)];
    self.totalLabel.font=[UIFont systemFontOfSize:22.0];
    self.totalLabel.textColor=ThemeRed;
    self.totalLabel.text=@"¥0.00";
    [self.payView addSubview:self.totalLabel];
    
    //修改字体大小
    NSMutableAttributedString *totalAttributedString=[[NSMutableAttributedString alloc] initWithString:self.totalLabel.text];
    [totalAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    
    self.totalLabel.attributedText=totalAttributedString;
}

#pragma mark 自定方法
/**
 *  初始化数据
 */
-(void)initData{
    //获取数据
    [self loadData];
    
    //更新总价
    [self updateTotal:[self.dic objectForKey:@"total"]];
}

/**
 *  获取数据
 */
-(void)loadData{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"获取中...";
    
    //构造参数
    NSString *url=@"order_show";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            //设置支付可用
            self.payButton.enabled=YES;
            
            if (![CheckNull([dic objectForKey:@"address"]) isEqualToString:@""]) {
                //更新收货地址
                [self updateAddress:[dic objectForKey:@"address"]];
            }
            
            //更新服务费
            self.tipLabel.text=[NSString stringWithFormat:@"¥%.2f",[[dic objectForKey:@"fuwu"] floatValue]];
            self.nonTipLabel.text=[NSString stringWithFormat:@"-¥%.2f",[[dic objectForKey:@"fuwu"] floatValue]];
            
            //更新总价
            CGFloat total=[[self.dic objectForKey:@"total"] floatValue];//总价
            
            if ([[dic objectForKey:@"free"] integerValue]==0) {//不免服务费
                if (total<[[dic objectForKey:@"man"] floatValue]) {//商品总价小于了每单免服务费金额
                    self.nonTipLabel.text=@"-¥0.00";
                    total=total+[[dic objectForKey:@"fuwu"] floatValue];
                }
            }
            
            [self updateTotal:[NSString stringWithFormat:@"%.2f",total]];
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
 *  更新收货地址
 *
 *  @param address 收货地址
 */
-(void)updateAddress:(NSDictionary *)address{
    //收货人
    self.consigneeLabel.text=[NSString stringWithFormat:@"收货人：%@(%@) | %@",[address objectForKey:@"name"],[[address objectForKey:@"sex"] integerValue]==1 ? @"男" : @"女",[address objectForKey:@"mobile"]];
    
    //收货地址
    self.consigneeAddressLabel.text=[NSString stringWithFormat:@"收货地址：%@",[address objectForKey:@"address"]];
    self.consigneeAddressLabel.accessibilityValue=[address objectForKey:@"id"];//地址id
}

/**
 *  更新总价
 *
 *  @param total 总价
 */
-(void)updateTotal:(NSString *)total{
    //商品总价
    self.sumLabel.text=[NSString stringWithFormat:@"¥%@",[self.dic objectForKey:@"total"]];
    
    //实付款
    self.payLabel.text=[NSString stringWithFormat:@"¥%@",total];
    
    //总价
    self.totalLabel.text=[NSString stringWithFormat:@"¥%@",total];
    
    //修改字体大小
    NSMutableAttributedString *totalAttributedString=[[NSMutableAttributedString alloc] initWithString:self.totalLabel.text];
    [totalAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    
    self.totalLabel.attributedText=totalAttributedString;
    
    //去结算按钮
    [self.payButton setTitle:[NSString stringWithFormat:@"去结算(%@)",[self.dic objectForKey:@"count"]] forState:UIControlStateNormal];
}

/**
 *  提交订单
 */
-(void)submitOrder{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //封装商品id集合
    NSMutableString *sidList=[[NSMutableString alloc] init];
    for (NSDictionary *dic in [self.dic objectForKey:@"list"]) {
        [sidList appendFormat:@",%@",[dic objectForKey:@"sid"]];
    }
    
    //封装商品数量集合
    NSMutableString *numList=[[NSMutableString alloc] init];
    for (NSDictionary *dic in [self.dic objectForKey:@"list"]) {
        [numList appendFormat:@",%@",[dic objectForKey:@"num"]];
    }
    
    
    //构造参数
    NSString *url=@"order_save";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0",
                               @"address_id":self.consigneeAddressLabel.accessibilityValue,
                               @"payment":self.onlinePayButton.isSelected ? @"1" : @"2",
                               @"remark":[self.remarkText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                               @"zongjia":[self.sumLabel.text substringFromIndex:1],
                               @"fuwufei":[self.tipLabel.text substringFromIndex:1],
                               @"jianmian":[self.nonTipLabel.text substringFromIndex:2],
                               @"totalprice":[self.totalLabel.text substringFromIndex:1],
                               @"goods":[sidList substringFromIndex:1],
                               @"num":[numList substringFromIndex:1]};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            NSDictionary *dicOrder=@{@"order":[dic objectForKey:@"order"],
                                     @"list":[self.dic objectForKey:@"list"],
                                     @"consignee":self.consigneeLabel.text,
                                     @"consigneeAddressLabel":self.consigneeAddressLabel.text};//封装订单信息
            //清除购物车缓存
            [self clearCacheShoppingCart];
            
            UCOrderDetailsViewController *vc=[UCOrderDetailsViewController new];
            vc.dic=dicOrder;
            vc.payViewHidden=self.onlinePayButton.isSelected ? NO : YES;
            [self.navigationController pushViewController:vc animated:YES];
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
 *  清除购物车缓存
 */
-(void)clearCacheShoppingCart{
    for (NSDictionary *dic in [self.dic objectForKey:@"list"]) {
        //清除购物车中一个商品
        [self clearShoppingCartWithId:[dic objectForKey:@"sid"] fid:[[dic objectForKey:@"gs"] objectForKey:@"fid"] count:[dic objectForKey:@"num"]];
    }
}

#pragma mark 按钮事件
/**
 *  地址按钮
 *
 *  @param sender
 */
-(void)addressButton:(UIButton *)sender{
    UCSelectAddressViewController *vc=[UCSelectAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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

/**
 *  支付按钮
 *
 *  @param sender
 */
-(void)payButton:(UIButton *)sender{
    if (!self.consigneeAddressLabel.accessibilityValue) {
        [CAlertView alertMessage:@"请选择收货地址"];
        
        return;
    }
    
    //提交订单
    [self submitOrder];
}

#pragma mark 键盘弹出和隐藏通知方法
/**
 *  键盘弹出回调
 *
 *  @param notification 通知信息
 */
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //自适应代码
    CGFloat offset=self.scrollView.height-kbSize.height;
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.transform=CGAffineTransformMakeTranslation(0, -offset-60);
    }];
}

/**
 *  键盘消失回调
 *
 *  @param notification 通知信息
 */
- (void)keyboardWillHide:(NSNotification *)notification{
    //自适应代码
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.transform=CGAffineTransformIdentity;
    }];
}

/**
 *  选择地址回调
 *
 *  @param notification 通知信息
 */
-(void)selectAddress:(NSNotification *)notification{
    //更新收货地址
    [self updateAddress:notification.userInfo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
