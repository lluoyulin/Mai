//
//  MPPointsViewController.m
//  Mai
//
//  Created by freedom on 16/3/13.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "MPPointsViewController.h"

#import "Const.h"
#import "NSObject+HttpTask.h"
#import "UILabel+AutoFrame.h"
#import "CAlertView.h"
#import "NSObject+Utils.h"

#import "MPPointsTableViewCell.h"

#import "MBProgressHUD.h"

@interface MPPointsViewController (){
    NSMutableArray *_pointsList;
}

@property(nonatomic,strong) UIView *navigationBarView;//导航栏
@property(nonatomic,strong) UIButton *leftBarButton;//左边按钮

@property(nonatomic,strong) UIView *topView;//上面部分视图
@property(nonatomic,strong) UILabel *pointLabel;//总积分文字
@property(nonatomic,strong) UILabel *myPointsLabel;//我的积分

@property(nonatomic,strong) UIView *bottomView;//下面部分视图
@property(nonatomic,strong) UIButton *exchangeButton;//积分兑换按钮按钮
@property(nonatomic,strong) UITableView *tableView;//积分数据表格
@property(nonatomic,strong) UIView *tableHeaderView;//表头
@property(nonatomic,strong) UILabel *titleLabel;//表头中的标题
@property(nonatomic,strong) UIImageView *titleImage;//表头中标题的图标

@end

@implementation MPPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的积分";
    
    self.view.backgroundColor=ThemeWhite;
    
    //初始化导航栏
    [self initNavigationBarView];
    
    //初始化上面部分视图
    [self initTopView];
    
    //初始化下面部分视图
    [self initBottomView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 初始化视图
/**
 *  初始化导航栏
 */
-(void)initNavigationBarView{
    //导航栏
    self.navigationBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT)];
    self.navigationBarView.backgroundColor=ThemeYellow;
    [self.view addSubview:self.navigationBarView];
    
    //左边按钮
    self.leftBarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBarButton.frame=CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-44)/2, 44, 44);
    [self.leftBarButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [self.leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 26)];
    [self.leftBarButton addTarget:self action:@selector(leftBarButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:self.leftBarButton];
}

/**
 *  初始化上面部分视图
 */
-(void)initTopView{
    //上面部分视图
    self.topView=[[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.bottom, self.navigationBarView.width, 160)];
    self.topView.backgroundColor=ThemeYellow;
    [self.view addSubview:self.topView];
    
    //总积分文字
    self.pointLabel=[[UILabel alloc] initWithFrame:CGRectMake((self.topView.width-50)/2, 0, 50, 16)];
    self.pointLabel.font=[UIFont systemFontOfSize:14.0];
    self.pointLabel.textColor=ThemeBlack;
    self.pointLabel.text=@"总积分";
    self.pointLabel.textAlignment=NSTextAlignmentCenter;
    [self.topView addSubview:self.pointLabel];
    
    //我的积分
    self.myPointsLabel=[UILabel new];
    self.myPointsLabel.font=[UIFont systemFontOfSize:98.0];
    self.myPointsLabel.textColor=ThemeBlack;
    [self.myPointsLabel setTextWidth:@"0" size:CGSizeMake(self.topView.width, 100)];
    self.myPointsLabel.frame=CGRectMake((self.topView.width-self.myPointsLabel.width)/2, self.pointLabel.bottom+20, self.myPointsLabel.width, 100);
    [self.topView addSubview:self.myPointsLabel];
}

/**
 *  初始化下面部分视图
 */
-(void)initBottomView{
    //下面部分视图
    self.bottomView=[[UIView alloc] initWithFrame:CGRectMake(self.topView.left, self.topView.bottom, self.topView.width, SCREEN_HEIGHT-self.topView.bottom)];
    self.bottomView.backgroundColor=UIColorFromRGB(0xf0f2f5);
    [self.view addSubview:self.bottomView];
    
    //积分兑换按钮
    self.exchangeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.exchangeButton.frame=CGRectMake(15, self.bottomView.height-44-10, self.bottomView.width-15-15, 44);
    self.exchangeButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
    self.exchangeButton.backgroundColor=ThemeYellow;
    self.exchangeButton.layer.masksToBounds=YES;
    self.exchangeButton.layer.cornerRadius=4;
    [self.exchangeButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.exchangeButton setTitle:@"积分兑换" forState:UIControlStateNormal];
    [self.exchangeButton addTarget:self action:@selector(exchangeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.exchangeButton];
    
    //积分数据表格
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.width, self.bottomView.height-10-self.exchangeButton.height-10)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.layer.borderColor=[UIColorFromRGB(0xccd6dd) CGColor];
    [self.bottomView addSubview:self.tableView];
    
    //表头
    self.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 45)];
    self.tableHeaderView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=self.tableHeaderView;
    
    UIView *headerLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.tableHeaderView.bottom, self.tableHeaderView.width, 0.5)];
    headerLine.backgroundColor=UIColorFromRGB(0xf2f2f2);
    [self.tableHeaderView addSubview:headerLine];
    
    //表头中标题的图标
    self.titleImage=[[UIImageView alloc] initWithFrame:CGRectMake((self.tableHeaderView.width-24-3-76)/2, (self.tableHeaderView.height-24)/2, 24, 24)];
    self.titleImage.image=[UIImage imageNamed:@"points_diamond"];
    [self.tableHeaderView addSubview:self.titleImage];
    
    //表头中的标题
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.titleImage.right+3, (self.tableHeaderView.height-20)/2, 76, 20)];
    self.titleLabel.font=[UIFont systemFontOfSize:18.0];
    self.titleLabel.textColor=ThemeGray;
    self.titleLabel.text=@"积分详情";
    [self.tableHeaderView addSubview:self.titleLabel];
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
    NSString *url=@"qiandao";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            [self.myPointsLabel setTextWidth:[[[dic objectForKey:@"result"] objectForKey:@"total"] stringValue] size:CGSizeMake(self.topView.width, 100)];
            self.myPointsLabel.frame=CGRectMake((self.topView.width-self.myPointsLabel.width)/2, self.pointLabel.bottom+20, self.myPointsLabel.width, 100);
            
            NSArray *today=[[dic objectForKey:@"result"] objectForKey:@"today"];
            if (today.count>0) {
                [_pointsList addObjectsFromArray:today];
                
                [self.tableView reloadData];
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

#pragma mark 按钮事件
/**
 *  左边按钮
 *
 *  @param sender 按钮
 */
-(void)leftBarButtonTouch:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  积分兑换按钮
 */
-(void)exchangeButton:(UIButton *)sender{
    [CAlertView alertTarget:self message:@"积分兑换功能即将开放，敬请期待！" handler:nil];
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pointsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    MPPointsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[MPPointsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dicPoint=_pointsList[indexPath.row];
    
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
    return 66;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
