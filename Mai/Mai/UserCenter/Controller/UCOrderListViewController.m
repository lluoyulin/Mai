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

#import "UCOrderListTableViewCell.h"

@interface UCOrderListViewController (){
    NSMutableArray *_orderList;
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *orderOperateView;//订单状态操作栏视图

@property(nonatomic,strong) UIView *tableViewLine;//表格分割线

@end

@implementation UCOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的订单";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    _orderList=[[NSMutableArray alloc] init];
    [_orderList addObject:@""];
    [_orderList addObject:@""];
    [_orderList addObject:@""];
    [_orderList addObject:@""];
    [_orderList addObject:@""];
    
    //初始化订单状态操作栏视图
    [self initOrderOperateView];
    
    //初始化表格
    [self initTableView];
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
    
    //表格分割线
    self.tableViewLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.orderOperateView.bottom+10, self.orderOperateView.width, 0.5)];
    self.tableViewLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.view addSubview:self.tableViewLine];
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
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,self.tableViewLine.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.tableViewLine.bottom)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark 自定义方法

#pragma mark 按钮事件
/**
 *  订单状态操作栏按钮
 *
 *  @param sender
 */
-(void)orderOperateButton:(UIButton *)sender{
    
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
    
    cell.dic=_orderList[indexPath.row];
    
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
    return 166;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
