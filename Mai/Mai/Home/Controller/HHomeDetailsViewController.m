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
#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"

@interface HHomeDetailsViewController ()<ImagePlayerViewDelegate>{
    NSMutableArray *_goodsList;//列表数据源
    NSMutableArray *_imagePlayerList;//幻灯片数据源
    CGRect _frame;
    int _pageIndex;//页数
    NSString *_fid;//商品类型id
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *tableHeader;//表头
@property(nonatomic,strong) ImagePlayerView *imagePlayerView;//幻灯片视图
@property(nonatomic,strong) UIButton *defaultButton;//默认
@property(nonatomic,strong) UIButton *salesButton;//销量
@property(nonatomic,strong) UIButton *priceButton;//价格

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
    
    //初始化表格
    [self initTableView];
    
    //初始化幻灯片视图
    [self initImagePlayerView];
    
    //初始化数据
    [self initData];
    
    //初始化表格刷新
    [self initRefreshing];
}

/**
 *  初始化表格
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, _frame.size.width, _frame.size.height)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=UIColorFromRGB(0xfafafa);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //表头
    self.tableHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 136)];
    self.tableHeader.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=self.tableHeader;
}

/**
 *  初始化幻灯片视图
 */
-(void)initImagePlayerView{
    //幻灯片视图
    self.imagePlayerView=[[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.tableHeader.width, 98)];
    self.imagePlayerView.imagePlayerViewDelegate=self;
    self.imagePlayerView.pageControlPosition=ICPageControlPosition_BottomCenter;
    self.imagePlayerView.scrollInterval=3;
    [self.tableHeader addSubview:self.imagePlayerView];
}

/**
 *  初始化表格刷新功能
 */
-(void)initRefreshing{
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
    _fid=@"";//所有商品
    
    _pageIndex=1;//页数
    
    _goodsList=[[NSMutableArray alloc] init];//列表数据源
    
    _imagePlayerList=[[NSMutableArray alloc] init];//幻灯片数据源
    
    //获取幻灯片数据
    [self imagePlayerData];
    
    //获取缓存数据
    [self cacheData];
}

/**
 *  获取幻灯片数据
 */
-(void)imagePlayerData{
    //构造参数
    NSString *url=@"piclist";
    NSDictionary *parameters=@{@"token":Token};
    
    //获取缓存数据
    NSString *cacheData=[self cacheWithUrl:url parameters:parameters];
    if (cacheData) {
        NSArray *array=[self toNSArryOrNSDictionaryWithJSon:cacheData];
        if (array.count) {
            [_imagePlayerList addObjectsFromArray:array];
            
            [self.imagePlayerView reloadData];
        }
    }
    
    //获取服务器数据
    [self post:url parameters:parameters cache:YES success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSArray *array=(NSArray *)result;
            if (array.count>0) {
                [_imagePlayerList removeAllObjects];
                
                [_imagePlayerList addObjectsFromArray:array];
                
                [self.imagePlayerView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"失败:%@",error);
        
    }];
}

/**
 *  获取缓存数据
 */
-(void)cacheData{
    //构造参数
    NSString *url=@"good_list";
    NSDictionary *parameters=@{@"token":Token,
                               @"fid":_fid,
                               @"p":[NSString stringWithFormat:@"%d",_pageIndex],
                               @"l":@"10"};
    
    //获取缓存数据
    NSString *cacheData=[self cacheWithUrl:url parameters:parameters];
    if (cacheData) {
        NSDictionary *dic=[self toNSArryOrNSDictionaryWithJSon:cacheData];
        NSArray *array=[dic objectForKey:@"list"];
        if (array.count>0) {
            [_goodsList removeAllObjects];//移除所有数据
            
            [_goodsList addObjectsFromArray:array];
            
            [self.tableView reloadData];//刷新tableView
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
                               @"fid":_fid,
                               @"p":[NSString stringWithFormat:@"%d",_pageIndex],
                               @"l":@"10"};
    
    //获取服务器数据
    [self post:url parameters:parameters cache:YES success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];//数据集合
            if (array.count>0) {//有数据
                [_goodsList removeAllObjects];//移除全部数据
                
                [_goodsList addObjectsFromArray:array];//把返回的数据添加到数据源中
                
                [self.tableView reloadData];//刷新tableView
                
                self.tableView.mj_footer.hidden=NO;
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        
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
                               @"fid":_fid,
                               @"p":[NSString stringWithFormat:@"%d",_pageIndex],
                               @"l":@"10"};
    
    //获取服务器数据
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];//数据集合
            if (array.count>0) {//有数据
                [_goodsList addObjectsFromArray:array];//把返回的数据添加到数据源中
                
                [self.tableView reloadData];//刷新tableView
                
                [self.tableView.mj_footer endRefreshing];
            }
            else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
        NSLog(@"失败:%@",error);
        
    }];
}

/**
 *  根据选中类型刷新tableView
 *
 *  @param fid 选中类型id
 */
-(void)refreshTableViewWithType:(NSString *)fid{
    _fid=fid;
    
    //获取缓存数据
    [self cacheData];
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
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
-(void)selectType:(NSString *)fid{
    [self refreshTableViewWithType:fid];
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

- (void)dealloc
{
    // clear
    [self.imagePlayerView stopTimer];
    self.imagePlayerView.imagePlayerViewDelegate = nil;
    self.imagePlayerView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
