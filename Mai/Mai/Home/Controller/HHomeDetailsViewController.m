//
//  HHomeDetailsViewController.m
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HHomeDetailsViewController.h"

#import "Const.h"
#import "UIView+Frame.h"
#import "NSObject+DataConvert.h"
#import "NSObject+HttpTask.h"

#import "HHomeDetailsTableViewCell.h"

#import "MJRefresh.h"

@interface HHomeDetailsViewController (){
    NSMutableArray *_goodsList;//列表数据源
    CGRect _frame;
    int _pageIndex;//页数
}

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation HHomeDetailsViewController

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super init];
    
    if (self) {
        _frame=frame;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化数据
    [self initData];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, _frame.size.width, _frame.size.height)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=UIColorFromRGB(0xfafafa);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self refreshTableViewWithType:0];//默认选中第一个
    
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    self.tableView.mj_footer.hidden=YES;
}

/**
 *  初始化数据
 */
-(void)initData{
    _pageIndex=1;
    
    _goodsList=[[NSMutableArray alloc] init];
    
    //构造参数
    NSString *url=@"good_list";
    NSDictionary *parameters=@{@"token":Token,
                               @"fid":@"",
                               @"p":[NSString stringWithFormat:@"%d",_pageIndex],
                               @"l":@"10"};
    
    //获取缓存数据
    NSString *cacheData=[self cacheWithUrl:url parameters:parameters];
    if (cacheData) {
        NSDictionary *dic=[self toNSArryOrNSDictionaryWithJSon:cacheData];
        NSArray *array=[dic objectForKey:@"list"];
        if (array.count>0) {
            [_goodsList addObjectsFromArray:array];
        }
    }
}

/**
 *  下拉刷新数据
 */
- (void)loadNewData{
    _pageIndex=1;
    
    //构造参数
    NSString *url=@"good_list";
    NSDictionary *parameters=@{@"token":Token,
                               @"fid":@"",
                               @"p":[NSString stringWithFormat:@"%d",_pageIndex],
                               @"l":@"10"};
    
    //获取服务器数据
    [self post:url parameters:parameters cache:YES success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];//数据集合
            NSInteger page=[[dic objectForKey:@"page"] integerValue];//总条数
            if (array.count>0) {//有数据
                [_goodsList removeAllObjects];//移除全部数据
                
                [_goodsList addObjectsFromArray:array];//把返回的数据添加到数据源中
                
                [self.tableView reloadData];
                
                self.tableView.mj_footer.hidden=NO;
                
                if (_goodsList.count>=page) {//没有更多的数据
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        NSLog(@"失败:%@",error);
        
    }];
}

/**
 *  上拉加载更多数据
 */
- (void)loadMoreData{
    _pageIndex+=1;
    
    //构造参数
    NSString *url=@"good_list";
    NSDictionary *parameters=@{@"token":Token,
                               @"fid":@"",
                               @"p":[NSString stringWithFormat:@"%d",_pageIndex],
                               @"l":@"10"};
    
    //获取服务器数据
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];//数据集合
            NSInteger page=[[dic objectForKey:@"page"] integerValue];//总条数
            if (array.count>0) {//有数据
                [_goodsList addObjectsFromArray:array];//把返回的数据添加到数据源中
                
                [self.tableView reloadData];
                
                if (_goodsList.count>=page) {//没有更多的数据
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
        NSLog(@"失败:%@",error);
        
    }];
}

/**
 *  根据选中类型刷新tableView
 *
 *  @param index 选中类型索引
 */
-(void)refreshTableViewWithType:(NSInteger)index{
//    if (_cityList.count>0) {
//        [_locationDetailList removeAllObjects];//移除全部数据
//        
//        NSDictionary *dicCity=_cityList[index];//获取该索引区级节点
//        NSArray *arr=[dicCity objectForKey:@"children"];//获取该区的路级节点
//        
//        for (NSDictionary *dic in arr) {
//            [_locationDetailList addObject:dic];
//        }
//        
//        self.title=[dicCity objectForKey:@"name"];
//        
//        [self.tableView reloadData];//刷新tableView
//        
//        [self.tableView setContentOffset:CGPointZero animated:YES];//返回到顶部
//    }
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    HHomeDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[HHomeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_goodsList[indexPath.row];
    
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
    return 120;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *location=[NSString stringWithFormat:@"%@-%@",self.title,[_locationDetailList[indexPath.row] objectForKey:@"name"]];
//    
//    //发送选中地址通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLocation" object:nil userInfo:@{@"cid":[_locationDetailList[indexPath.row] objectForKey:@"id"],@"location":location}];
}

#pragma mark ZHLocationListViewControllerDelegate动作委托
-(void)selectType:(NSInteger)index{
    [self refreshTableViewWithType:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
