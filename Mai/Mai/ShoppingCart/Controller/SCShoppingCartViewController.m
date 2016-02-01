//
//  SCShoppingCartViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "SCShoppingCartViewController.h"

#import "Const.h"
#import "CAlertView.h"
#import "NSObject+HttpTask.h"

#import "SCShoppingCartTableViewCell.h"

#import "MBProgressHUD.h"

@interface SCShoppingCartViewController (){
    ShoppingCartStyle _style;
    NSMutableArray *_goodsList;//列表数据源
}

@property(nonatomic,strong) UIButton *navigationDeleteButton;//导航栏删除按钮

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation SCShoppingCartViewController

-(instancetype)initWithStyle:(ShoppingCartStyle)style{
    self=[super init];
    
    if (self) {
        _style=style;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeWhite;
    
    self.showMenu=YES;
    
    _goodsList=[[NSMutableArray alloc] init];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化表格
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取数据
    [self loadData];
}

#pragma mark 初始化视图
/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏删除按钮
    self.navigationDeleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationDeleteButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationDeleteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 26, 0, 0)];
    [self.navigationDeleteButton setImage:[UIImage imageNamed:@"navigation_delete"] forState:UIControlStateNormal];
    [self.navigationDeleteButton addTarget:self action:@selector(navigationDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:self.navigationDeleteButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

/**
 *  初始化表格
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=ThemeWhite;
    self.tableView.separatorColor=UIColorFromRGB(0xdddddd);
    [self.view addSubview:self.tableView];
}

#pragma mark 按钮事件
/**
 *  导航栏删除按钮
 *
 *  @param sender 按钮对象
 */
-(void)navigationDeleteButton:(UIButton *)sender{

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
    NSString *url=@"cart";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *array=[dic objectForKey:@"list"];//添加到购物车中的商品列表
            if (array.count>0) {
                [_goodsList removeAllObjects];//移除所有数据
                
                [_goodsList addObjectsFromArray:array];//添加到列表数据源
                
                [self.tableView reloadData];//刷新tableView
            }
        }
        else{
            [CAlertView alertMessage:error];
        }
        
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
        NSLog(@"失败:%@",error);
        
    }];
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
    
    SCShoppingCartTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[SCShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
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
    return 110;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
