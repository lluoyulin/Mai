//
//  LBLeftBarViewController.m
//  Mai
//
//  Created by freedom on 16/2/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "LBLeftBarViewController.h"

#import "Const.h"
#import "NSObject+Utils.h"

#import "LBLeftBarTableViewCell.h"

@interface LBLeftBarViewController (){
    NSMutableArray *_list;
}

@property(nonatomic,strong) UIImageView *bgImage;//背景图

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation LBLeftBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0x13112b);
    
    //注册点击汉堡包通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu:) name:@"showmenu" object:nil];
    
    //初始化数据
    [self initData];
    
    //初始化背景图
    [self initBGImage];
    
    //初始化tablebview
    [self initTableView];
}

#pragma mark 初始化视图
/**
 *  初始化背景图
 */
-(void)initBGImage{
    //背景图
    self.bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    self.bgImage.image=[UIImage imageNamed:@"leftbar_image"];
    [self.view addSubview:self.bgImage];
}

/**
 *  初始化tablebview
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.bgImage.bottom-30, self.view.width*2/3, SCREEN_HEIGHT-self.bgImage.bottom+30)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=UIColorFromRGB(0x13112b);
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark 自定义方法
/**
 *  初始化数据
 */
-(void)initData{
    _list=[[NSMutableArray alloc] init];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"name":@"商城",@"logo":@"leftbar_store",@"isselect":@"1"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"name":@"蚤市",@"logo":@"leftbar_market",@"isselect":@"0"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"name":@"社区",@"logo":@"leftbar_community",@"isselect":@"0"}]];
}

/**
 *  刷新列表
 *
 *  @param index 选中索引
 */
-(void)refresh:(NSInteger)index{
    for (int i=0; i<_list.count; i++) {
        if (i==index) {
            [_list[i] setObject:@"1" forKey:@"isselect"];
        }
        else{
            [_list[i] setObject:@"0" forKey:@"isselect"];
        }
    }
    
    [self.tableView reloadData];
}

/**
 *  退出
 */
-(void)userLogout{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定退出" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self logout];
        
        [_list removeLastObject];//移除退出
        
        [self.tableView reloadData];
        
        //点击汉堡包发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showmenu" object:nil];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 通知
/**
 *  显示左边视图
 */
-(void)showMenu:(NSNotification *)notification{
    //去掉选中效果
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if ([self isLogin] && _list.count<4) {
        [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"name":@"退出",@"logo":@"leftbar_log_out",@"isselect":@"0"}]];
        
        [self.tableView reloadData];
    }
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    LBLeftBarTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[LBLeftBarTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_list[indexPath.row];
    
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
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:@{@"title":@""}];
    
    switch (indexPath.row) {
        case 0:
            [dic setObject:@"商城" forKey:@"title"];
            break;
        case 1:
            [dic setObject:@"蚤市" forKey:@"title"];
            break;
        case 2:
            [dic setObject:@"社区" forKey:@"title"];
            break;
        case 3://退出
            [self userLogout];
            break;
    }
    
    if (indexPath.row!=3) {
        //刷新列表
        [self refresh:indexPath.row];
        
        //切换栏目发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"load_center_view" object:nil userInfo:dic];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除所有通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
