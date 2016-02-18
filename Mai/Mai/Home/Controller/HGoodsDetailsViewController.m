//
//  HGoodsDetailsViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HGoodsDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Const.h"
#import "NSObject+HttpTask.h"
#import "CAlertView.h"
#import "UILabel+AutoFrame.h"
#import "NSObject+Utils.h"

#import "CSlidingViewController.h"
#import "HGoodsDescriptionsViewController.h"
#import "HGoodsImageInfoViewController.h"
#import "SCShoppingCartViewController.h"
#import "ULLoginViewController.h"

#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface HGoodsDetailsViewController ()<ImagePlayerViewDelegate,HGoodsDescriptionsViewControllerDelegate,HGoodsImageInfoViewControllerDelegate>{
    NSMutableArray *_imagePlayerList;//幻灯片数据源
    NSDictionary *_resultDic;//商品信息数据
}

@property(nonatomic,strong) UIButton *navigationShoppingButton;//导航栏上购物车按钮
@property(nonatomic,strong) UILabel *navigationShoppingCountLabel;//导航栏上购物车数量
@property(nonatomic,strong) UIImageView *shoppingAnimationImage;//加入购物车动画图片

@property(nonatomic,strong) UIScrollView *scrollView;//商品详情容器
@property(nonatomic,strong) UIView *operateView;//操作栏视图
@property(nonatomic,strong) UIButton *addShoppingCartButton;//添加购物车按钮
@property(nonatomic,strong) UIButton *buyButton;//立即购买按钮

@property(nonatomic,strong) ImagePlayerView *imagePlayerView;//幻灯片视图

@property(nonatomic,strong) UIView *goodsInfoView;//商品信息视图
@property(nonatomic,strong) UILabel *nameLabel;//商品名称
@property(nonatomic,strong) UILabel *price1;//零售价
@property(nonatomic,strong) UILabel *price2;//本店零售价
@property(nonatomic,strong) UIButton *starButton;//收藏按钮
@property(nonatomic,strong) UILabel *starLabel;//收藏文字

@property(nonatomic,strong) UIView *selectTabView;//选项卡视图
@property(nonatomic,strong) CSlidingViewController *slidingVC;//选项卡
@property(nonatomic,strong) HGoodsDescriptionsViewController *goodsDescriptionsVC;//商品信息VC
@property(nonatomic,strong) HGoodsImageInfoViewController *goodsImageInfoVC;//商品图文信息VC

@end

@implementation HGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"商品详情";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //注册添加购物车通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShoppingCart:) name:@"add_shopping_cart" object:nil];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //商品详情容器
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-50)];
    self.scrollView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.scrollView.scrollEnabled=NO;
    [self.view addSubview:self.scrollView];
    
    //初始化幻灯片数据源
    _imagePlayerList=[[NSMutableArray alloc] init];
    
    //初始化操作栏
    [self initOperateView];
    
    //初始化幻灯片视图
    [self initImagePlayerView];
    
    //获取数据
    [self loadData];
}

#pragma mark 初始化视图
/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏上购物车按钮
    self.navigationShoppingButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationShoppingButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationShoppingButton setImageEdgeInsets:UIEdgeInsetsMake(0, 26, 0, 0)];
    [self.navigationShoppingButton setImage:[UIImage imageNamed:@"navigation_shopping"] forState:UIControlStateNormal];
    [self.navigationShoppingButton addTarget:self action:@selector(navigationShoppingButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:self.navigationShoppingButton];
    self.navigationItem.rightBarButtonItem=right;
    
    //导航栏上购物车数量
    self.navigationShoppingCountLabel=[UILabel new];
    self.navigationShoppingCountLabel.frame=CGRectMake(35, 5, 14, 14);
    self.navigationShoppingCountLabel.font=[UIFont systemFontOfSize:10.0];
    self.navigationShoppingCountLabel.textColor=[UIColor whiteColor];
    self.navigationShoppingCountLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationShoppingCountLabel.backgroundColor=[UIColor redColor];
    self.navigationShoppingCountLabel.layer.masksToBounds=YES;
    self.navigationShoppingCountLabel.layer.cornerRadius=self.navigationShoppingCountLabel.width/2;
    [self.navigationShoppingButton addSubview:self.navigationShoppingCountLabel];
    
    //获取商品购物车数量
    NSString *count=[UserData objectForKey:@"total_shopping_cart"];
    self.navigationShoppingCountLabel.text=count ? count : @"";
    self.navigationShoppingCountLabel.hidden=count ? NO : YES;
}

/**
 *  初始化操作栏
 */
-(void)initOperateView{
    //操作栏视图
    self.operateView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:self.operateView];
    
    //添加购物车按钮
    self.addShoppingCartButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addShoppingCartButton.frame=CGRectMake(0, 0, self.operateView.width/2, self.operateView.height);
    self.addShoppingCartButton.backgroundColor=ThemeYellow;
    self.addShoppingCartButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.addShoppingCartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addShoppingCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addShoppingCartButton addTarget:self action:@selector(addShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
    self.addShoppingCartButton.showsTouchWhenHighlighted=YES;
    [self.operateView addSubview:self.addShoppingCartButton];
    
    //立即购买按钮
    self.buyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.frame=CGRectMake(self.addShoppingCartButton.right, self.addShoppingCartButton.top, self.addShoppingCartButton.width, self.addShoppingCartButton.height);
    self.buyButton.backgroundColor=ThemeRed;
    self.buyButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyButton addTarget:self action:@selector(buyButton:) forControlEvents:UIControlEventTouchUpInside];
    self.buyButton.showsTouchWhenHighlighted=YES;
    [self.operateView addSubview:self.buyButton];
}

/**
 *  初始化幻灯片视图
 */
-(void)initImagePlayerView{
    //幻灯片视图
    self.imagePlayerView=[[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.width/16*9)];
    self.imagePlayerView.imagePlayerViewDelegate=self;
    self.imagePlayerView.pageControlPosition=ICPageControlPosition_BottomCenter;
    self.imagePlayerView.scrollInterval=3;
    [self.scrollView addSubview:self.imagePlayerView];
}

/**
 *  初始化商品信息视图
 */
-(void)initGoodsInfoView{
    //商品信息视图
    self.goodsInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.imagePlayerView.bottom, self.imagePlayerView.width, 77)];
    self.goodsInfoView.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:self.goodsInfoView];
    
    //底部线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.goodsInfoView.height-0.5, self.goodsInfoView.width, 0.5)];
    bottomLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.goodsInfoView addSubview:bottomLine];
    
    //竖线
    UIView *verticalLine=[[UIView alloc] initWithFrame:CGRectMake(self.goodsInfoView.width-44-1, (self.goodsInfoView.height-18)/2, 1, 18)];
    verticalLine.backgroundColor=bottomLine.backgroundColor;
    [self.goodsInfoView addSubview:verticalLine];
    
    //收藏按钮
    self.starButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.starButton.frame=CGRectMake(verticalLine.right, (self.goodsInfoView.height-44)/2, 44, 44);
    [self.starButton setImageEdgeInsets:UIEdgeInsetsMake(3.5, 0, 22.5, 0)];
    [self.starButton setImage:[UIImage imageNamed:@"home_collection"] forState:UIControlStateNormal];
    [self.starButton addTarget:self action:@selector(starButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.goodsInfoView addSubview:self.starButton];
    
    //收藏文字
    self.starLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 24.5, self.starButton.width, 14)];
    self.starLabel.font=[UIFont systemFontOfSize:12.0];
    self.starLabel.textColor=UIColorFromRGB(0x666666);
    self.starLabel.text=@"收藏";
    self.starLabel.textAlignment=NSTextAlignmentCenter;
    [self.starButton addSubview:self.starLabel];
    
    //商品名称
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.goodsInfoView.width-15-verticalLine.width-self.starButton.width, 18)];
    self.nameLabel.font=[UIFont systemFontOfSize:16.0];
    self.nameLabel.textColor=[UIColor blackColor];
    self.nameLabel.text=[_resultDic objectForKey:@"title"];
    [self.goodsInfoView addSubview:self.nameLabel];
    
    //本店零售价
    self.price2=[[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom+8, 0, 26)];
    self.price2.font=[UIFont systemFontOfSize:24.0];
    self.price2.textColor=ThemeRed;
    [self.price2 setTextWidth:[NSString stringWithFormat:@"¥%@",[_resultDic objectForKey:@"price2"]] size:CGSizeMake(100, 26)];
    [self.goodsInfoView addSubview:self.price2];
    
    //修改字体大小
    NSMutableAttributedString *price2String=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[_resultDic objectForKey:@"price2"]]];
    [price2String addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    self.price2.attributedText=price2String;
    
    //零售价
    self.price1=[[UILabel alloc] initWithFrame:CGRectMake(self.price2.right, self.goodsInfoView.height-15-13-2, self.goodsInfoView.width-self.price2.right-verticalLine.width-self.starButton.width, 13)];
    self.price1.font=[UIFont systemFontOfSize:11.0];
    self.price1.textColor=ThemeGray;
    [self.goodsInfoView addSubview:self.price1];
    
    //添加删除
    NSMutableAttributedString *price1String=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价 ¥%@，已销%@笔",[_resultDic objectForKey:@"price1"],[_resultDic objectForKey:@"xiaoliang"]]];
    [price1String addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(3, [[_resultDic objectForKey:@"price1"] stringValue].length+1)];
    self.price1.attributedText=price1String;
}

/**
 *  初始化选项卡视图
 */
-(void)initSelectTabView{
    //选项卡视图
    self.selectTabView=[[UIView alloc] initWithFrame:CGRectMake(0, self.goodsInfoView.bottom+10, self.goodsInfoView.width, self.scrollView.height)];
    self.selectTabView.layer.masksToBounds=YES;
    [self.scrollView addSubview:self.selectTabView];
    
    //商品信息VC
    self.goodsDescriptionsVC=[[HGoodsDescriptionsViewController alloc] initWithHeight:self.selectTabView.height-39];
    self.goodsDescriptionsVC.title=@"商品信息";
    self.goodsDescriptionsVC.dic=_resultDic;
    self.goodsDescriptionsVC.delegate=self;
    
    //商品图文信息VC
    self.goodsImageInfoVC=[[HGoodsImageInfoViewController alloc] initWithHeight:self.selectTabView.height-39];
    self.goodsImageInfoVC.title=@"图文详情";
    self.goodsImageInfoVC.dic=_resultDic;
    self.goodsImageInfoVC.delegate=self;
    
    //选项卡
    self.slidingVC=[CSlidingViewController new];
    self.slidingVC.view.backgroundColor=[UIColor whiteColor];
    
    [self addChildViewController:self.slidingVC];
    [self.slidingVC didMoveToParentViewController:self];
    
    [self.selectTabView addSubview:self.slidingVC.view];
}

#pragma mark UIButton 按钮事件
/**
 *  加入购物车
 *
 *  @param sender 按钮对象
 */
-(void)addShoppingCartButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    //添加到购物车
    [self addShoppingCart];
    
    //加入购物车动画
    if (!self.shoppingAnimationImage) {
        //加入购物车动画图片
        self.shoppingAnimationImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        self.shoppingAnimationImage.layer.masksToBounds=YES;
        self.shoppingAnimationImage.layer.cornerRadius=5.0;
        [self.shoppingAnimationImage sd_setImageWithURL:[NSURL URLWithString:_imagePlayerList.count>0 ? [_imagePlayerList[0] objectForKey:@"pic"] : @""] placeholderImage:[UIImage imageNamed:@"image_default"]];
    }
    [self.navigationController.view addSubview:self.shoppingAnimationImage];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.4;
    pathAnimation.repeatCount = 1;
    pathAnimation.delegate=self;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, SCREEN_WIDTH/4, SCREEN_HEIGHT-self.addShoppingCartButton.height/2);
    CGPathAddQuadCurveToPoint(curvedPath, NULL,SCREEN_WIDTH/4, SCREEN_HEIGHT/2, self.navigationShoppingButton.left+30, 40);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    [self.shoppingAnimationImage.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
}

/**
 *  立即购买
 *
 *  @param sender 按钮对象
 */
-(void)buyButton:(UIButton *)sender{
    if (![self isLogin]) {
        [self.navigationController pushViewController:[ULLoginViewController new] animated:YES];
        
        return;
    }
    
    //刷新数据
    self.isRefresh=YES;
    
    //添加到购物车
    [self addShoppingCart];
    
    SCShoppingCartViewController *vc=[[SCShoppingCartViewController alloc] initWithStyle:ShoppingCartStyleDefault];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  收藏
 *
 *  @param sender 按钮对象
 */
-(void)starButton:(UIButton *)sender{
    NSLog(@"收藏");
}

/**
 *  导航栏上购物车按钮
 *
 *  @param sender 按钮对象
 */
-(void)navigationShoppingButton:(UIButton *)sender{
    //刷新数据
    self.isRefresh=YES;
    
    SCShoppingCartViewController *vc=[[SCShoppingCartViewController alloc] initWithStyle:ShoppingCartStyleDefault];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 自定义方法
/**
 *  获取数据
 */
-(void)loadData{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"获取中...";
    
    //构造参数
    NSString *url=@"goods";
    NSDictionary *parameters=@{@"token":Token,
                               @"gid":self.gid};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        [hud hide:YES];
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;//获取数据
            _resultDic=[NSDictionary dictionaryWithDictionary:dic];//商品信息数据
            
            //获取幻灯片
            NSArray *imageArray=[_resultDic objectForKey:@"img"];
            [_imagePlayerList addObjectsFromArray:imageArray];
            [self.imagePlayerView reloadData];
            
            //初始化商品信息视图
            [self initGoodsInfoView];
            
            //初始化选项卡视图
            [self initSelectTabView];
            
            //配置选项卡
            [self.slidingVC configureWithViewControllers:@[self.goodsDescriptionsVC,self.goodsImageInfoVC] segmentedViewHeight:39.0 segmentedViewY:0.0 isSliding:NO selectIndex:0];
            
            //显示选项卡
            [self.slidingVC show];
        }
        else{
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  添加到购物车
 */
-(void)addShoppingCart{
    //构造参数
    NSString *url=@"add_to_car";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"gid":self.gid,
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            //设置购物车商品数量
            [self setShoppingCount:[dic objectForKey:@"count"] sid:self.gid fid:self.fid isAdd:YES];
            
            //获取商品购物车数量
            NSString *count=[UserData objectForKey:@"total_shopping_cart"];
            self.navigationShoppingCountLabel.text=count ? count : @"";
            self.navigationShoppingCountLabel.hidden=count ? NO : YES;
        }
        else{
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  添加购物车通知回调
 *
 *  @param notification 通知信息
 */
-(void)addShoppingCart:(NSNotification *)notification{
    //获取商品购物车数量
    NSString *count=[UserData objectForKey:@"total_shopping_cart"];
    self.navigationShoppingCountLabel.text=count ? count : @"";
    self.navigationShoppingCountLabel.hidden=count ? NO : YES;
}

#pragma mark 商品信息委托
-(void)changeGoodsDescriptionsScrollViewContentOffset:(CGFloat)offsetY{
    if (self.scrollView.contentOffset.y>=self.selectTabView.frame.origin.y) {
        self.scrollView.contentOffset=CGPointMake(0, self.selectTabView.frame.origin.y);
    }
    else{
        self.scrollView.contentOffset=CGPointMake(0, offsetY);
    }
}

-(void)setGoodsDescriptionsScrollViewContentOffset:(CGFloat)offsetY{
    if (offsetY>10) {
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.contentOffset=CGPointMake(0, self.selectTabView.frame.origin.y);
        }];
    }
    else if(offsetY<-20){
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.contentOffset=CGPointZero;
        }];
    }
}

#pragma mark 商品图文信息委托
-(void)changeGoodsImageInfoScrollViewContentOffset:(CGFloat)offsetY{
    [self changeGoodsDescriptionsScrollViewContentOffset:offsetY];
}

-(void)setGoodsImageInfoScrollViewContentOffset:(CGFloat)offsetY{
    [self setGoodsDescriptionsScrollViewContentOffset:offsetY];
}

#pragma mark CAKeyframeAnimation委托
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self.shoppingAnimationImage removeFromSuperview];
    }
}

#pragma mark ImagePlayerViewDelegate
- (NSInteger)numberOfItems{
    return _imagePlayerList.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    
    if (_imagePlayerList.count>0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[_imagePlayerList[index] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"image_default"]];
    }
}

- (void)dealloc{
    // clear
    [self.imagePlayerView stopTimer];
    self.imagePlayerView.imagePlayerViewDelegate = nil;
    self.imagePlayerView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
