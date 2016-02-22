//
//  UCOrderListViewController.m
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCOrderListViewController.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"
#import "NSObject+HttpTask.h"
#import "CAlertView.h"
#import "NSObject+Utils.h"

#import "UCOrderListTableViewCell.h"
#import "SCGoodsListViewController.h"

#import "MBProgressHUD.h"

@interface UCOrderListViewController (){
    NSMutableArray *_list;//用户全部订单数据
    NSMutableArray *_orderList;//筛选后的订单数据
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *orderOperateView;//订单状态操作栏视图

@end

@implementation UCOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的订单";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //用户全部订单数据
    _list=[[NSMutableArray alloc] init];
    
    //筛选后的订单数据
    _orderList=[[NSMutableArray alloc] init];
    
    //初始化订单状态操作栏视图
    [self initOrderOperateView];
    
    //初始化表格
    [self initTableView];
    
    //获取数据
    [self loadData];
}

#pragma mark 初始化视图
/**
 *  初始化订单状态操作栏视图
 */
-(void)initOrderOperateView{
    //订单状态操作栏视图
    self.orderOperateView=[[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 45)];
    self.orderOperateView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.orderOperateView];
    
    //订单状态操作栏视图分割线
    UIView *orderOperateLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.orderOperateView.height-0.5, self.orderOperateView.width, 0.5)];
    orderOperateLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.orderOperateView addSubview:orderOperateLine];
    
    //初始化订单状态操作栏按钮
    [self initOrderOperateButton];
}

/**
 *  初始化订单状态操作栏按钮
 */
-(void)initOrderOperateButton{
    //按钮名称
    NSArray *titleArray=@[@"待付款",@"待抢单",@"已接单",@"配送中",@"已完成"];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i+1;
        btn.frame=CGRectMake(self.orderOperateView.width/5*i, 0, self.orderOperateView.width/5, self.orderOperateView.height);
        btn.titleLabel.font=[UIFont systemFontOfSize:14.0];
        [btn setTitleColor:ThemeGray forState:UIControlStateNormal];
        [btn setTitleColor:ThemeRed forState:UIControlStateSelected];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(orderOperateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderOperateView addSubview:btn];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(btn.width, (btn.height-16)/2, 1, 16)];
        line.backgroundColor=UIColorFromRGB(0xdddddd);
        [btn addSubview:line];
        
        btn.selected=btn.tag==self.selectIndex ? YES : NO;
    }
}

/**
 *  初始化表格
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,self.orderOperateView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.orderOperateView.bottom)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.tableView.separatorColor=UIColorFromRGB(0xdddddd);
    [self.view addSubview:self.tableView];
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
    NSString *url=@"uer_order";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];
            
            if (array.count>0) {
                [_list addObjectsFromArray:array];
                
                //筛选数据
                [self filterDataWithSelectIndex:self.selectIndex];
            }
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
 *  筛选数据
 *
 *  @param index 选择筛选数据条件索引
 */
-(void)filterDataWithSelectIndex:(NSInteger )index{
    NSInteger status;
    switch (index) {
        case 1:
            status=1;
            break;
        case 2:
            status=2;
            break;
        case 3:
            status=1;
            break;
        case 4:
            status=4;
            break;
        case 5:
            status=5;
            break;
    }
    
    //通过谓词筛选数据
    NSPredicate *predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"status=='%ld'",(long)index]];
    NSArray *orderArray=[_list filteredArrayUsingPredicate:predicate];//获取订单数据
    
    [_orderList removeAllObjects];//移除全部数据
    
    [_orderList addObjectsFromArray:orderArray];//添加数据
    
    [self.tableView reloadData];//刷新tableView
}

#pragma mark 按钮事件
/**
 *  订单状态操作栏按钮
 *
 *  @param sender
 */
-(void)orderOperateButton:(UIButton *)sender{
    for (int i=0; i<5; i++) {
        UIButton *btn=(UIButton *)[self.orderOperateView viewWithTag:i+1];
        
        if (btn.tag==sender.tag) {
            btn.selected=YES;
            
            //筛选数据
            [self filterDataWithSelectIndex:btn.tag];
        }
        else{
            btn.selected=NO;
        }
    }
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    UCOrderListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[UCOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    //商品列表
    SCGoodsListViewController *goodsListVC=[SCGoodsListViewController new];
    goodsListVC.goodsList=[_orderList[indexPath.row] objectForKey:@"gs"];
    
    [self addChildViewController:goodsListVC];
    [goodsListVC didMoveToParentViewController:self];
    
    cell.dic=_orderList[indexPath.row];
    cell.goodsList=goodsListVC.view;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 176;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
