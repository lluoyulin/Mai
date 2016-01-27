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
#import "UILabel+AutoFrame.h"

#import "HHomeDetailsTableViewCell.h"

#import "MJRefresh.h"
#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"

@interface HHomeDetailsViewController ()<ImagePlayerViewDelegate>{
    NSMutableArray *_goodsList;//列表数据源
    NSMutableArray *_sortList;//排序列表数据源
    NSMutableArray *_imagePlayerList;//幻灯片数据源
    CGRect _frame;
    int _pageIndex;//页数
    NSString *_fid;//商品类型id
    NSString *_sort;//排序
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *tableHeader;//表头
@property(nonatomic,strong) ImagePlayerView *imagePlayerView;//幻灯片视图
@property(nonatomic,strong) UIView *toolBarView;//排序操作栏视图
@property(nonatomic,strong) UIButton *defaultButton;//默认按钮
@property(nonatomic,strong) UIButton *salesButton;//销量按钮
@property(nonatomic,strong) UIButton *priceButton;//价格按钮
@property(nonatomic,strong) UIImageView *salesImage;//销量排序图标
@property(nonatomic,strong) UIImageView *priceImage;//价格排序图标
@property(nonatomic,strong) UIView *line;//线

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
    self.tableView.tableHeaderView=self.tableHeader;
    
    //排序操作栏视图
    self.toolBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 98, self.tableHeader.width, self.tableHeader.height-98)];
    self.toolBarView.backgroundColor=[UIColor whiteColor];
    [self.tableHeader addSubview:self.toolBarView];
    
    //默认按钮
    self.defaultButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.defaultButton.frame=CGRectMake(0, 0, self.toolBarView.width/3.0, self.toolBarView.height);
    self.defaultButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [self.defaultButton setTitleColor:ThemeRed forState:UIControlStateSelected];
    [self.defaultButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [self.defaultButton setTitle:@"默认" forState:UIControlStateNormal];
    [self.defaultButton addTarget:self action:@selector(defaultButton:) forControlEvents:UIControlEventTouchUpInside];
    self.defaultButton.selected=YES;
    [self.toolBarView addSubview:self.defaultButton];
    
    //销量按钮
    self.salesButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.salesButton.frame=CGRectMake(self.defaultButton.right, self.defaultButton.top, self.defaultButton.width, self.defaultButton.height);
    self.salesButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [self.salesButton setTitleColor:ThemeRed forState:UIControlStateSelected];
    [self.salesButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [self.salesButton setTitle:@"销量" forState:UIControlStateNormal];
    [self.salesButton addTarget:self action:@selector(salesButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.salesButton];
    
    //销量排序图标
    self.salesImage=[[UIImageView alloc] initWithFrame:CGRectMake((self.salesButton.width-26)/2+26, (self.salesButton.height-12)/2, 12, 12)];
    self.salesImage.image=[UIImage imageNamed:@"home_arrow"];
    [self.salesButton addSubview:self.salesImage];
    
    //价格按钮
    self.priceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.priceButton.frame=CGRectMake(self.salesButton.right, self.salesButton.top, self.salesButton.width, self.salesButton.height);
    self.priceButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [self.priceButton setTitleColor:ThemeRed forState:UIControlStateSelected];
    [self.priceButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [self.priceButton setTitle:@"价格" forState:UIControlStateNormal];
    [self.priceButton addTarget:self action:@selector(priceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.priceButton];
    
    //价格排序图标
    self.priceImage=[[UIImageView alloc] initWithFrame:CGRectMake((self.priceButton.width-26)/2+26, (self.priceButton.height-12)/2, 12, 12)];
    self.priceImage.image=[UIImage imageNamed:@"home_arrow"];
    [self.priceButton addSubview:self.priceImage];
    
    //线
    self.line=[[UIView alloc] initWithFrame:CGRectMake(0, self.toolBarView.height-0.5, self.toolBarView.width, 0.5)];
    self.line.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.toolBarView addSubview:self.line];
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
    
    _sortList=[[NSMutableArray alloc] init];//排序列表数据源
    
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
            [_goodsList addObjectsFromArray:array];
        }
    }
    
    [self.tableView reloadData];//刷新tableView
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
                
                if (self.salesButton.isSelected) {//数据为销量排序
                    [self sortWithKey:@"xl" ascending:[_sort isEqualToString:@"desc"] ? NO : YES];
                }
                else if (self.priceButton.isSelected) {//数据为价格排序
                    [self sortWithKey:@"price2" ascending:[_sort isEqualToString:@"desc"] ? NO : YES];
                }
                else{
                    [_sortList removeAllObjects];//移除所有排序数据
                    
                    [self.tableView reloadData];//刷新tableView
                }
                
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
                
                if (self.salesButton.isSelected) {//数据为销量排序
                    NSArray *tempArray=[self sortArray:array key:@"xl" ascending:[_sort isEqualToString:@"desc"] ? NO : YES];
                    [_sortList addObjectsFromArray:tempArray];
                }
                else if (self.priceButton.isSelected) {//数据为价格排序
                    NSArray *tempArray=[self sortArray:array key:@"price2" ascending:[_sort isEqualToString:@"desc"] ? NO : YES];
                    [_sortList addObjectsFromArray:tempArray];
                }
                else{
                    [_sortList removeAllObjects];//移除所有排序数据
                }
                
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
    //重置商品列表为默认排序
    self.tableView.mj_footer.hidden=YES;
    self.defaultButton.selected=YES;
    self.salesButton.selected=NO;
    self.priceButton.selected=NO;
    [_sortList removeAllObjects];//移除全部排序数据
    [_goodsList removeAllObjects];//移除所有数据
    
    //商品类型id
    _fid=fid;
    
    //获取缓存数据
    [self cacheData];
    
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  排序
 *
 *  @param key       需要排序的字段名
 *  @param ascending 是否升序
 */
-(void)sortWithKey:(NSString *)key ascending:(BOOL)ascending{
    //排序
    NSArray *array = [_goodsList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        //得到想要排序字段的NSNumber对象
        NSNumber *number1=[NSNumber numberWithInteger:[[obj1 objectForKey:key] integerValue]];
        NSNumber *number2=[NSNumber numberWithInteger:[[obj2 objectForKey:key] integerValue]];
        
        NSComparisonResult result=[number1 compare:number2];
        
        return ascending ? result==NSOrderedDescending : result==NSOrderedAscending;
        
    }];
    
    [_sortList removeAllObjects];
    
    [_sortList addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

/**
 *  数组排序
 *
 *  @param array     需要排序的数组
 *  @param key       需要排序的字段名
 *  @param ascending 是否升序
 *
 *  @return 排序后的数组
 */
-(NSArray *)sortArray:(NSArray *)array key:(NSString *)key ascending:(BOOL)ascending{
    NSArray *tempArray=[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        //得到想要排序字段的NSNumber对象
        NSNumber *number1=[NSNumber numberWithInteger:[[obj1 objectForKey:key] integerValue]];
        NSNumber *number2=[NSNumber numberWithInteger:[[obj2 objectForKey:key] integerValue]];
        
        NSComparisonResult result=[number1 compare:number2];
        
        return ascending ? result==NSOrderedDescending : result==NSOrderedAscending;
        
    }];
    
    return tempArray;
}

#pragma mark 按钮事件
/**
 *  默认按钮
 *
 *  @param sender 按钮对象
 */
-(void)defaultButton:(UIButton *)sender{
    self.defaultButton.selected=YES;
    self.salesButton.selected=NO;
    self.priceButton.selected=NO;
    
    [_sortList removeAllObjects];//移除全部排序数据
    
    [self.tableView reloadData];
}

/**
 *  销量按钮
 *
 *  @param sender 按钮对象
 */
-(void)salesButton:(UIButton *)sender{
    if (self.salesButton.isSelected) {//选中(当前在数据是以销量排序)
        _sort=[_sort isEqualToString:@"desc"] ? @"asc" : @"desc";
    }
    else{//未选中(当前在数据不是以销量排序)
        self.defaultButton.selected=NO;
        self.salesButton.selected=YES;
        self.priceButton.selected=NO;
        
        _sort=@"desc";
    }
    
    //排序图标动画
    [UIView animateWithDuration:0.2 animations:^{
        self.salesImage.transform=[_sort isEqualToString:@"desc"] ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
    }];
    
    //排序
    [self sortWithKey:@"xl" ascending:[_sort isEqualToString:@"desc"] ? NO : YES];
}

/**
 *  价格按钮
 *
 *  @param sender 按钮对象
 */
-(void)priceButton:(UIButton *)sender{
    if (self.priceButton.isSelected) {//选中(当前在数据是以价格排序)
        _sort=[_sort isEqualToString:@"desc"] ? @"asc" : @"desc";
    }
    else{//未选中(当前在数据不是以价格排序)
        self.defaultButton.selected=NO;
        self.salesButton.selected=NO;
        self.priceButton.selected=YES;
        
        _sort=@"desc";
    }
    
    //排序图标动画
    [UIView animateWithDuration:0.2 animations:^{
        self.priceImage.transform=[_sort isEqualToString:@"desc"] ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
    }];
    
    //排序
    [self sortWithKey:@"price2" ascending:[_sort isEqualToString:@"desc"] ? NO : YES];
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sortList.count>0 ? _sortList.count : _goodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    HHomeDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[HHomeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_sortList.count>0 ? _sortList[indexPath.row] : _goodsList[indexPath.row];
    
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

- (void)dealloc{
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
