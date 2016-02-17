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

#import "MBProgressHUD.h"

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
    self.orderNOLabel.text=[NSString stringWithFormat:@"订单号：%@",@"1231312312312312"];
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
    self.orderInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.goodsView.bottom+10, self.goodsView.width, 293)];
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
    self.payWayLabel.text=@"在线支付";
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
    
    //实付款
    self.payLabel=[UILabel new];
    self.payLabel.font=self.nonTipTagLabel.font;
    self.payLabel.textColor=ThemeRed;
    [self.payLabel setTextWidth:[NSString stringWithFormat:@"实付款：¥%@",@"0.00"] size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.payLabel.frame=CGRectMake(self.orderInfoView.width-self.payLabel.width-15, nonTipLine.bottom+15, self.payLabel.width, self.nonTipTagLabel.height);
    [self.orderInfoView addSubview:self.payLabel];
    
    //订单时间
    self.orderDateLabel=[UILabel new];
    self.orderDateLabel.font=[UIFont systemFontOfSize:11.0];
    self.orderDateLabel.textColor=ThemeGray;
    [self.orderDateLabel setTextWidth:[NSString stringWithFormat:@"下单时间：2014-12-12 12:12:12"] size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.orderDateLabel.frame=CGRectMake(self.orderInfoView.width-self.orderDateLabel.width-15, self.payLabel.bottom+15, self.orderDateLabel.width, 13);
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
    self.remarkLabel.text=[NSString stringWithFormat:@"我的留言：萨达是打发斯蒂芬撒旦法阿斯蒂芬阿斯蒂芬阿斯蒂芬啊暗室逢灯"];
    [self.orderInfoView addSubview:self.remarkLabel];
    
    //修改备注字体颜色
    NSMutableAttributedString *remarkAttributedString=[[NSMutableAttributedString alloc] initWithString:self.remarkLabel.text];
    [remarkAttributedString addAttribute:NSForegroundColorAttributeName value:ThemeBlack range:NSMakeRange(0, 5)];
    
    self.remarkLabel.attributedText=remarkAttributedString;
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
    
    //取消支付
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame=CGRectMake(0, 0, self.payView.width/2, self.payView.height);
    self.cancelButton.backgroundColor=ThemeYellow;
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.cancelButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
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
            
            //更新收货地址
            [self updateAddress:[dic objectForKey:@"address"]];
            
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
    [self.payLabel setTextWidth:[NSString stringWithFormat:@"实付款：¥%@",total] size:CGSizeMake(self.orderInfoView.width,self.nonTipTagLabel.height)];
    self.payLabel.frame=CGRectMake(self.orderInfoView.width-self.payLabel.width-15, self.payLabel.top, self.payLabel.width, self.payLabel.height);
}

#pragma mark 按钮事件
/**
 *  支付按钮
 *
 *  @param sender
 */
-(void)payButton:(UIButton *)sender{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
