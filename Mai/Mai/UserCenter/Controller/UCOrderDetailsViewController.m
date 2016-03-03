//
//  UCOrderDetailsViewController.m
//  Mai
//
//  Created by freedom on 16/2/17.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCOrderDetailsViewController.h"

#import "Const.h"
#import "NSObject+HttpTask.h"
#import "CAlertView.h"
#import "NSObject+Utils.h"
#import "UILabel+AutoFrame.h"

#import "UCGoodsListViewController.h"
#import "UCOrderListViewController.h"

#import "MBProgressHUD.h"

#import "WXApi.h"
#import "WXApiObject.h"

static const CGFloat PayViewHeight=50.0;

@interface UCOrderDetailsViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;//订单信息视图

@property(nonatomic,strong) UIView *orderNOView;//订单号视图
@property(nonatomic,strong) UILabel *orderNOLabel;//订单号

@property(nonatomic,strong) UIImageView *addressImage;//地址图片
@property(nonatomic,strong) UIImageView *addressFlagImage;//地址标志
@property(nonatomic,strong) UILabel *consigneeLabel;//收货人
@property(nonatomic,strong) UILabel *consigneeAddressLabel;//收货地址

@property(nonatomic,strong) UIView *goodsView;//商品视图

@property(nonatomic,strong) UIView *orderInfoView;//订单信息视图
@property(nonatomic,strong) UILabel *payWayTagLabel;//支付方式标签
@property(nonatomic,strong) UILabel *payWayLabel;//支付方式
@property(nonatomic,strong) UILabel *sumTagLabel;//商品总价标签
@property(nonatomic,strong) UILabel *sumLabel;//商品总价
@property(nonatomic,strong) UILabel *tipTagLabel;//服务费标签
@property(nonatomic,strong) UILabel *tipLabel;//服务费
@property(nonatomic,strong) UILabel *nonTipTagLabel;//减免服务费标签
@property(nonatomic,strong) UILabel *nonTipLabel;//减免服务费
@property(nonatomic,strong) UILabel *payLabel;//实付款
@property(nonatomic,strong) UILabel *orderDateLabel;//订单时间
@property(nonatomic,strong) UILabel *remarkLabel;//备注

@property(nonatomic,strong) UIView *payView;//支付操作视图
@property(nonatomic,strong) UIButton *cancelButton;//取消支付
@property(nonatomic,strong) UIButton *payButton;//支付按钮

@end

@implementation UCOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"订单详情";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //添加支付成功后进入我的订单通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"pay_success" object:nil];
    
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
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-(self.isPayViewHidden ? 0 : 10+PayViewHeight))];
    self.scrollView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.scrollView];
    
    //初始化订单号视图
    [self initOrderNOView];
    
    //初始化地址视图
    [self initAddressView];
    
    //初始化商品视图
    [self initGoodsView];
    
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
 *  初始化订单号视图
 */
-(void)initOrderNOView{
    //订单号视图
    self.orderNOView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 38)];
    self.orderNOView.backgroundColor=ThemeWhite;
    [self.scrollView addSubview:self.orderNOView];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.orderNOView.height-0.5, self.orderNOView.width, 0.5)];
    bottomLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.orderNOView addSubview:bottomLine];
    
    //订单号
    self.orderNOLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, (self.orderNOView.height-16)/2, self.orderNOView.width-15-15, 16)];
    self.orderNOLabel.font=[UIFont systemFontOfSize:14.0];
    self.orderNOLabel.textColor=ThemeGray;
    self.orderNOLabel.text=[NSString stringWithFormat:@"订单号：%@",@""];
    [self.orderNOView addSubview:self.orderNOLabel];
}

/**
 *  初始化地址视图
 */
-(void)initAddressView{
    //地址图片
    self.addressImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.orderNOView.bottom+10, self.scrollView.width, 74)];
    self.addressImage.image=[UIImage imageNamed:@"order_address_bg"];
    [self.scrollView addSubview:self.addressImage];
    
    //地址标志
    self.addressFlagImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.addressImage.height-22)/2, 22, 22)];
    self.addressFlagImage.image=[UIImage imageNamed:@"order_address_flag"];
    [self.addressImage addSubview:self.addressFlagImage];
    
    //收货人
    self.consigneeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.addressFlagImage.right+10, (self.addressImage.height-16-8-15)/2, self.addressImage.width-self.addressFlagImage.right-10-10-16-15, 16)];
    self.consigneeLabel.font=[UIFont systemFontOfSize:14.0];
    self.consigneeLabel.textColor=ThemeBlack;
    self.consigneeLabel.text=@"收货人：无";
    [self.addressImage addSubview:self.consigneeLabel];
    
    //收货地址
    self.consigneeAddressLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.consigneeLabel.left, self.consigneeLabel.bottom+8, self.consigneeLabel.width, 15)];
    self.consigneeAddressLabel.font=[UIFont systemFontOfSize:13.0];
    self.consigneeAddressLabel.textColor=ThemeGray;
    self.consigneeAddressLabel.text=@"收货地址：无";
    [self.addressImage addSubview:self.consigneeAddressLabel];
}

/**
 *  初始化商品视图
 */
-(void)initGoodsView{
    NSArray *list=[self.dic objectForKey:@"list"];
    CGFloat height=0.0;
    if (list.count==1) {
        height=90;
    }
    else if (list.count==2){
        height=180;
    }
    else{
        height=270;
    }
    
    //商品视图
    self.goodsView=[[UIView alloc] initWithFrame:CGRectMake(0, self.addressImage.bottom+10, self.addressImage.width, height)];
    self.goodsView.backgroundColor=ThemeWhite;
    self.goodsView.layer.masksToBounds=YES;
    [self.scrollView addSubview:self.goodsView];
    
    //商品列表
    UCGoodsListViewController *goodsListVC=[UCGoodsListViewController new];
    goodsListVC.goodsList=list;
    
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
 *  初始化订单信息视图
 */
-(void)initOrderInfoView{
    //订单信息视图
    self.orderInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.goodsView.bottom+10, self.goodsView.width, 290-88)];
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
    
    //支付方式标签
    self.payWayTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 14, 80, 16)];
    self.payWayTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.payWayTagLabel.textColor=ThemeBlack;
    self.payWayTagLabel.text=@"支付方式";
    [self.orderInfoView addSubview:self.payWayTagLabel];
    
    //支付方式
    self.payWayLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.orderInfoView.width-100-15, self.payWayTagLabel.top, 100, 16)];
    self.payWayLabel.font=self.payWayTagLabel.font;
    self.payWayLabel.textColor=self.payWayTagLabel.textColor;
    self.payWayLabel.textAlignment=NSTextAlignmentRight;
    [self.orderInfoView addSubview:self.payWayLabel];
    
    //支付方式分割线
    UIView *payWayLine=[[UIView alloc] initWithFrame:CGRectMake(self.payWayTagLabel.left, self.payWayTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    payWayLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.orderInfoView addSubview:payWayLine];
    
    //商品总价标签
    self.sumTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.payWayTagLabel.left, payWayLine.bottom+14, 80, 16)];
    self.sumTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.sumTagLabel.textColor=ThemeBlack;
    self.sumTagLabel.text=@"商品总价";
    [self.orderInfoView addSubview:self.sumTagLabel];
    
    //商品总价
    self.sumLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.orderInfoView.width-100-15, self.sumTagLabel.top, 100, self.sumTagLabel.height)];
    self.sumLabel.font=self.sumTagLabel.font;
    self.sumLabel.textColor=self.sumTagLabel.textColor;
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
//    [self.orderInfoView addSubview:self.tipTagLabel];
    
    //服务费
    self.tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sumLabel.left, self.tipTagLabel.top, 100, self.tipTagLabel.height)];
    self.tipLabel.font=self.tipTagLabel.font;
    self.tipLabel.textColor=self.tipTagLabel.textColor;
    self.tipLabel.textAlignment=NSTextAlignmentRight;
//    [self.orderInfoView addSubview:self.tipLabel];
    
    //服务费分割线
    UIView *tipLine=[[UIView alloc] initWithFrame:CGRectMake(self.tipTagLabel.left, self.tipTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    tipLine.backgroundColor=sumLine.backgroundColor;
//    [self.orderInfoView addSubview:tipLine];
    
    //减免服务费标签
    self.nonTipTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.tipTagLabel.left, tipLine.bottom+14, self.tipTagLabel.width, self.tipTagLabel.height)];
    self.nonTipTagLabel.font=self.tipTagLabel.font;
    self.nonTipTagLabel.textColor=self.tipTagLabel.textColor;
    self.nonTipTagLabel.text=@"减免服务费";
//    [self.orderInfoView addSubview:self.nonTipTagLabel];
    
    //减免服务费
    self.nonTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sumLabel.left, self.nonTipTagLabel.top, 100, self.nonTipTagLabel.height)];
    self.nonTipLabel.font=self.nonTipTagLabel.font;
    self.nonTipLabel.textColor=self.nonTipTagLabel.textColor;
    self.nonTipLabel.textAlignment=NSTextAlignmentRight;
//    [self.orderInfoView addSubview:self.nonTipLabel];
    
    //减免服务费分割线
    UIView *nonTipLine=[[UIView alloc] initWithFrame:CGRectMake(self.nonTipTagLabel.left, self.nonTipTagLabel.bottom+14, self.orderInfoView.width-15-15, 0.5)];
    nonTipLine.backgroundColor=sumLine.backgroundColor;
//    [self.orderInfoView addSubview:nonTipLine];
    
    //实付款
    self.payLabel=[UILabel new];
    self.payLabel.font=[UIFont systemFontOfSize:14.0];
    self.payLabel.textColor=ThemeRed;
    [self.payLabel setTextWidth:@"实付款：" size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.payLabel.frame=CGRectMake(self.orderInfoView.width-self.payLabel.width-15, sumLine.bottom+15, self.payLabel.width, 16);
    [self.orderInfoView addSubview:self.payLabel];
    
    //订单时间
    self.orderDateLabel=[UILabel new];
    self.orderDateLabel.font=[UIFont systemFontOfSize:11.0];
    self.orderDateLabel.textColor=ThemeGray;
    [self.orderDateLabel setTextWidth:@"下单时间：" size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.orderDateLabel.frame=CGRectMake(self.orderInfoView.width-self.orderDateLabel.width-15, self.payLabel.bottom+5, self.orderDateLabel.width, 13);
    [self.orderInfoView addSubview:self.orderDateLabel];
    
    //实付款分割线
    UIView *payLine=[[UIView alloc] initWithFrame:CGRectMake(nonTipLine.left, self.orderDateLabel.bottom+11, self.orderInfoView.width-15-15, 0.5)];
    payLine.backgroundColor=sumLine.backgroundColor;
    [self.orderInfoView addSubview:payLine];
    
    //备注
    self.remarkLabel=[[UILabel alloc] initWithFrame:CGRectMake(payLine.left, payLine.bottom, payLine.width, 44)];
    self.remarkLabel.font=[UIFont systemFontOfSize:14.0];
    self.remarkLabel.textColor=ThemeGray;
    self.remarkLabel.numberOfLines=2;
    [self.orderInfoView addSubview:self.remarkLabel];
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
    
    //取消支付按钮
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame=CGRectMake(0, 0, self.payView.width/2, self.payView.height);
    self.cancelButton.backgroundColor=ThemeYellow;
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.cancelButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.payView addSubview:self.cancelButton];
    
    //去结算按钮
    self.payButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame=CGRectMake(self.cancelButton.right, self.cancelButton.top, self.cancelButton.width, self.cancelButton.height);
    self.payButton.backgroundColor=ThemeRed;
    self.payButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.payButton setTitleColor:ThemeWhite forState:UIControlStateNormal];
    [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payButton:) forControlEvents:UIControlEventTouchUpInside];
    self.payButton.showsTouchWhenHighlighted=YES;
    [self.payView addSubview:self.payButton];
}

#pragma mark 自定方法
/**
 *  初始化数据
 */
-(void)initData{
    //订单号
    self.orderNOLabel.text=[NSString stringWithFormat:@"订单号：%@",[[self.dic objectForKey:@"order"] objectForKey:@"orderno"]];
    
    //收货人
    self.consigneeLabel.text=[self.dic objectForKey:@"consignee"];
    
    //收货地址
    self.consigneeAddressLabel.text=[self.dic objectForKey:@"consigneeAddressLabel"];
    
    //支付方式
    self.payWayLabel.text=[[[self.dic objectForKey:@"order"] objectForKey:@"payment"] integerValue]==1 ? @"微信支付" : @"货到付款";
    
    //商品总价
    self.sumLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[self.dic objectForKey:@"order"] objectForKey:@"zongjia"] floatValue]];
    
    //服务费
    self.tipLabel.text=[NSString stringWithFormat:@"¥%.2f",[[[self.dic objectForKey:@"order"] objectForKey:@"fuwufei"] floatValue]];
    
    //减免服务费
    self.nonTipLabel.text=[NSString stringWithFormat:@"-¥%.2f",[[[self.dic objectForKey:@"order"] objectForKey:@"jianmian"] floatValue]];
    
    //实付款
    [self.payLabel setTextWidth:[NSString stringWithFormat:@"实付款：¥%@",[NSString stringWithFormat:@"%.2f",[[[self.dic objectForKey:@"order"] objectForKey:@"totalprice"] floatValue]]] size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.payLabel.frame=CGRectMake(self.orderInfoView.width-self.payLabel.width-15, self.payLabel.top, self.payLabel.width, self.payLabel.height);
    
    //订单时间
    [self.orderDateLabel setTextWidth:[NSString stringWithFormat:@"下单时间：%@",[[self.dic objectForKey:@"order"] objectForKey:@"date"]] size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.orderDateLabel.frame=CGRectMake(self.orderInfoView.width-self.orderDateLabel.width-15, self.orderDateLabel.top ,self.orderDateLabel.width, 13);
    
    //备注
    self.remarkLabel.text=[NSString stringWithFormat:@"我的留言：%@",[[self.dic objectForKey:@"order"] objectForKey:@"remark"]];
    
    //修改备注字体颜色
    NSMutableAttributedString *remarkAttributedString=[[NSMutableAttributedString alloc] initWithString:self.remarkLabel.text];
    [remarkAttributedString addAttribute:NSForegroundColorAttributeName value:ThemeBlack range:NSMakeRange(0, 5)];
    
    self.remarkLabel.attributedText=remarkAttributedString;
    
    //是否显示支付操作视图
    if (self.isPayViewHidden) {
        self.payView.hidden=YES;
    }
    else{
        self.payView.hidden=NO;
    }
}

/**
 *  取消订单
 */
-(void)cancelOrder{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //构造参数
    NSString *url=@"order_cancel";
    NSDictionary *parameters=@{@"token":Token,
                               @"orderid":[[self.dic objectForKey:@"order"] objectForKey:@"id"],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 按钮事件取
/**
 *  取消订单按钮
 *
 *  @param sender
 */
-(void)cancelButton:(UIButton *)sender{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"是否确定取消订单" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //取消订单
        [self cancelOrder];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  支付按钮
 *
 *  @param sender
 */
-(void)payButton:(UIButton *)sender{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //构造参数
    NSString *url=@"weixin_pay";
    NSDictionary *parameters=@{@"token":Token,
                               @"orderid":[[self.dic objectForKey:@"order"] objectForKey:@"id"]};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            //调起微信支付
            PayReq *req=[PayReq new];
            req.partnerId=[[dic objectForKey:@"data"] objectForKey:@"partnerid"];
            req.prepayId=[[dic objectForKey:@"data"] objectForKey:@"prepayid"];
            req.nonceStr=[[dic objectForKey:@"data"] objectForKey:@"noncestr"];
            req.timeStamp=[[[dic objectForKey:@"data"] objectForKey:@"timestamp"] intValue];
            req.package=[[dic objectForKey:@"data"] objectForKey:@"package"];
            req.sign=[[dic objectForKey:@"data"] objectForKey:@"sign"];
            
            [WXApi sendReq:req];
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

#pragma mark 通知
/**
 *  添加支付成功后进入我的订单通知
 *
 *  @param notification
 */
-(void)paySuccess:(NSNotification *)notification{
    //构造参数
    NSString *url=@"update_order";
    NSDictionary *parameters=@{@"token":Token,
                               @"orderid":[[self.dic objectForKey:@"order"] objectForKey:@"id"]};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            UCOrderListViewController *vc=[UCOrderListViewController new];
            vc.selectIndex=2;
            vc.flag=@"pay_success";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
