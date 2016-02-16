//
//  UCUserAddressViewController.m
//  Mai
//
//  Created by freedom on 16/2/16.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCUserAddressViewController.h"

#import "Const.h"
#import "NSObject+HttpTask.h"
#import "NSObject+DataConvert.h"
#import "NSObject+Utils.h"
#import "CAlertView.h"

#import "UCAddressDetailsViewController.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface UCUserAddressViewController (){
    NSMutableArray *_addressList;
}

@property(nonatomic,strong) UIButton *navigationAddButton;//添加地址按钮

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *addAddressView;//添加地址视图
@property(nonatomic,strong) UIImageView *addLogoImage;//添加地址logo
@property(nonatomic,strong) UILabel *addAddressTagLabel;//添加地址标签
@property(nonatomic,strong) UIButton *addAddressButton;//添加地址按钮

@end

@implementation UCUserAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"收货地址";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    _addressList=[[NSMutableArray alloc] init];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化tablebview
    [self initTableView];
    
    //初始化添加地址视图
    [self initAddAddressView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取数据
    [self loadData];
}

#pragma mark 初始化视图
/**
 *  初始化tablebview
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor=UIColorFromRGB(0xdddddd);
    self.tableView.hidden=YES;
    [self.view addSubview:self.tableView];
}

/**
 *  初始化添加地址视图
 */
-(void)initAddAddressView{
    //添加地址视图
    self.addAddressView=[[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 170)];
    self.addAddressView.backgroundColor=self.view.backgroundColor;
    self.addAddressView.hidden=YES;
    [self.view addSubview:self.addAddressView];
    
    //添加地址logo
    self.addLogoImage=[[UIImageView alloc] initWithFrame:CGRectMake((self.addAddressView.width-60)/2, 0, 60, 60)];
    self.addLogoImage.image=[UIImage imageNamed:@"order_address_non"];
    [self.addAddressView addSubview:self.addLogoImage];
    
    //添加地址标签
    self.addAddressTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.addLogoImage.bottom+15, self.addAddressView.width, 15)];
    self.addAddressTagLabel.font=[UIFont systemFontOfSize:13.0];
    self.addAddressTagLabel.textColor=ThemeGray;
    self.addAddressTagLabel.textAlignment=NSTextAlignmentCenter;
    self.addAddressTagLabel.text=@"还没有收货地址";
    [self.addAddressView addSubview:self.addAddressTagLabel];
    
    //添加地址按钮
    self.addAddressButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addAddressButton.frame=CGRectMake((self.addAddressView.width-110)/2, self.addAddressTagLabel.bottom+30.5, 110, 45);
    self.addAddressButton.layer.masksToBounds=YES;
    self.addAddressButton.layer.cornerRadius=4;
    self.addAddressButton.backgroundColor=ThemeYellow;
    self.addAddressButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [self.addAddressButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.addAddressButton setTitle:@"添加收货地址" forState:UIControlStateNormal];
    [self.addAddressButton addTarget:self action:@selector(addAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.addAddressView addSubview:self.addAddressButton];
}

/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏删除按钮
    self.navigationAddButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationAddButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationAddButton setImageEdgeInsets:UIEdgeInsetsMake(0, 26, 0, 0)];
    [self.navigationAddButton setImage:[UIImage imageNamed:@"navigation_add"] forState:UIControlStateNormal];
    [self.navigationAddButton addTarget:self action:@selector(navigationAddButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationAddButton.hidden=YES;
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:self.navigationAddButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
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
    NSString *url=@"address_list";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            NSArray *list=[dic objectForKey:@"list"];//获取地址
            
            [_addressList removeAllObjects];//移除所有数据
            [_addressList addObjectsFromArray:list];//添加数据
            
            if (_addressList.count>0) {
                self.tableView.hidden=NO;
                self.addAddressView.hidden=YES;
                self.navigationAddButton.hidden=NO;
                
                [self.tableView reloadData];//刷新tableView
            }
            else{
                self.tableView.hidden=YES;
                self.addAddressView.hidden=NO;
                self.navigationAddButton.hidden=YES;
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
 *  删除地址
 *
 *  @param aid 地址id
 */
-(void)deleteAddress:(NSString *)aid{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //构造参数
    NSString *url=@"address_del";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0",
                               @"id":aid};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            hud.mode=MBProgressHUDModeText;
            hud.labelText=@"删除成功";
            [hud hide:YES afterDelay:1.5];
            
            //获取数据
            [self loadData];
        }
        else{
            [hud hide:YES];
            
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

#pragma mark 按钮事件
/**
 *  添加地址按钮
 *
 *  @param sender
 */
-(void)addAddressButton:(UIButton *)sender{
    UCAddressDetailsViewController *vc=[UCAddressDetailsViewController new];
    vc.title=@"添加地址";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  添加地址按钮
 *
 *  @param sender
 */
-(void)navigationAddButton:(UIButton *)sender{
    UCAddressDetailsViewController *vc=[UCAddressDetailsViewController new];
    vc.title=@"添加地址";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewCellIdentifier];
    }
    
    //收货人
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor=ThemeBlack;
    cell.textLabel.text=[NSString stringWithFormat:@"收货人：%@(%@) | %@",[_addressList[indexPath.row] objectForKey:@"name"],[[_addressList[indexPath.row] objectForKey:@"sex"] integerValue]==1 ? @"男" : @"女",[_addressList[indexPath.row] objectForKey:@"mobile"]];
    
    //收货地址
    cell.detailTextLabel.font=[UIFont systemFontOfSize:13.0];
    cell.detailTextLabel.textColor=ThemeGray;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"收货地址：%@",[_addressList[indexPath.row] objectForKey:@"address"]];
    
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

#pragma mark 表格编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {//删除
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"删除选中地址" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            //删除地址
            [self deleteAddress:[_addressList[indexPath.row] objectForKey:@"id"]];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCAddressDetailsViewController *vc=[UCAddressDetailsViewController new];
    vc.title=@"修改地址";
    vc.dic=_addressList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
