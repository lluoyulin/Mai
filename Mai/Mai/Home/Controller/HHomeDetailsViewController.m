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

#import "HHomeDetailsTableViewCell.h"

@interface HHomeDetailsViewController (){
    NSMutableArray *_locationDetailList;//列表数据源
    NSMutableArray *_cityList;//城市数据源
    CGRect _frame;
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
}

/**
 *  初始化数据
 */
-(void)initData{
    NSString *json=[UserData objectForKey:@"locationlist"];
    if (json!=nil) {
        NSArray *arr=[self toNSArryOrNSDictionaryWithJSon:json];
        
        NSDictionary *dicCity=arr[0];//获取市级节点
        NSArray *locationArr=[dicCity objectForKey:@"children"];//获取区级节点
        
        _cityList=[[NSMutableArray alloc] initWithArray:locationArr];
    }
    else{
        _cityList=[[NSMutableArray alloc] init];
    }
    
    _locationDetailList=[[NSMutableArray alloc] init];
}

/**
 *  根据选中类型刷新tableView
 *
 *  @param index 选中类型索引
 */
-(void)refreshTableViewWithType:(NSInteger)index{
    if (_cityList.count>0) {
        [_locationDetailList removeAllObjects];//移除全部数据
        
        NSDictionary *dicCity=_cityList[index];//获取该索引区级节点
        NSArray *arr=[dicCity objectForKey:@"children"];//获取该区的路级节点
        
        for (NSDictionary *dic in arr) {
            [_locationDetailList addObject:dic];
        }
        
        self.title=[dicCity objectForKey:@"name"];
        
        [self.tableView reloadData];//刷新tableView
        
        [self.tableView setContentOffset:CGPointZero animated:YES];//返回到顶部
    }
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _locationDetailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    HHomeDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[HHomeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_locationDetailList[indexPath.row];
    
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
    return 55;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *location=[NSString stringWithFormat:@"%@-%@",self.title,[_locationDetailList[indexPath.row] objectForKey:@"name"]];
    
    //发送选中地址通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectLocation" object:nil userInfo:@{@"cid":[_locationDetailList[indexPath.row] objectForKey:@"id"],@"location":location}];
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
