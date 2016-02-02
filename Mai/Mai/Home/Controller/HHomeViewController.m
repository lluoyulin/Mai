//
//  HHomeViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HHomeViewController.h"

#import "Const.h"
#import "NSObject+DataConvert.h"
#import "NSObject+HttpTask.h"

#import "HGoodsDetailsViewController.h"
#import "HHomeTableViewCell.h"
#import "HHomeDetailsViewController.h"

#import "MJRefresh.h"

@interface HHomeViewController (){
    NSMutableArray *_typeList;//列表数据源
    NSInteger _selectIndex;//选中的索引
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *homeDetailListView;//右边商品列表

@end

@implementation HHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeWhite;
    
    self.showMenu=YES;
    
    //注册添加购物车通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShoppingCart:) name:@"add_shopping_cart" object:nil];
    
    //初始化数据
    [self initData];
    
    _selectIndex=0;
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, 80, SCREEN_HEIGHT-TAB_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor=UIColorFromRGB(0xdddddd);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.tableView];
    
    self.homeDetailListView=[[UIView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x+self.tableView.frame.size.width, self.tableView.frame.origin.y, SCREEN_WIDTH-self.tableView.frame.size.width, self.tableView.frame.size.height)];
    self.homeDetailListView.layer.masksToBounds=YES;
    [self.view addSubview:self.homeDetailListView];
    
    HHomeDetailsViewController *homeDetailListViewVC=[[HHomeDetailsViewController alloc] initWithFrame:CGRectMake(0, 0, self.homeDetailListView.frame.size.width, self.tableView.frame.size.height)];
    
    [self addChildViewController:homeDetailListViewVC];
    [homeDetailListViewVC didMoveToParentViewController:self];
    
    [self.homeDetailListView addSubview:homeDetailListViewVC.view];
    
    self.delegate=homeDetailListViewVC;
    
    //刷新购物车block
    homeDetailListViewVC.RefreshShoppingCartBlock=^(){
        [self.tableView reloadData];//刷新tableView
    };
}

/**
 *  初始化数据
 */
-(void)initData{
    _typeList=[[NSMutableArray alloc] init];
    
    //构造参数
    NSString *url=@"fenlei";
    NSDictionary *parameters=@{@"token":Token};
    
    //获取缓存数据
    NSString *cacheData=[self cacheWithUrl:url parameters:parameters];
    if (cacheData) {
        NSArray *array=[self toNSArryOrNSDictionaryWithJSon:cacheData];
        if (array.count>0) {
            [_typeList addObject:@{@"id":@"",@"name":@"所有商品",@"stank":@""}];
            [_typeList addObjectsFromArray:array];
        }
    }
    
    //获取服务器数据
    [self post:url parameters:parameters cache:YES success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSArray *array=(NSArray *)result;
            if (array.count>0) {//有数据
                [_typeList removeAllObjects];//移除全部数据
                
                [_typeList addObject:@{@"id":@"",@"name":@"所有商品",@"stank":@""}];
                [_typeList addObjectsFromArray:array];//把返回的数据添加到数据源中
                
                [self.tableView reloadData];//刷新tableView
            }
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  添加购物车通知回调
 *
 *  @param notification 通知信息
 */
-(void)addShoppingCart:(NSNotification *)notification{
    [self.tableView reloadData];//刷新tableView
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    HHomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[HHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_typeList[indexPath.row];
    cell.selectIndex=_selectIndex;
    cell.index=indexPath.row;
    
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
    return 50;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex=indexPath.row;
    [self.tableView reloadData];
    
    [self.delegate selectType:[_typeList[indexPath.row] objectForKey:@"id"]];
}

@end
