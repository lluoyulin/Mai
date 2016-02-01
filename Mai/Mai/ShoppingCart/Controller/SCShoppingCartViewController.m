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

@property(nonatomic,strong) UIView *operateView;//操作栏
@property(nonatomic,strong) UIButton *selectAllButton;//全选按钮
@property(nonatomic,strong) UILabel *allTagLabel;//全选文字
@property(nonatomic,strong) UILabel *totalTagLabel;//合计文字
@property(nonatomic,strong) UILabel *totalLabel;//总价
@property(nonatomic,strong) UIButton *payButton;//去结算按钮

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
    
    self.title=@"购物车";
    
    self.view.backgroundColor=ThemeWhite;
    
    self.showMenu=_style==ShoppingCartStyleDefault ? NO : YES;
    
    _goodsList=[[NSMutableArray alloc] init];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化表格
    [self initTableView];
    
    //初始化操作栏
    [self initOperateView];
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
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-50-(_style==ShoppingCartStyleDefault ? 0 : TAB_BAR_HEIGHT))];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=ThemeWhite;
    self.tableView.separatorColor=UIColorFromRGB(0xdddddd);
    [self.view addSubview:self.tableView];
}

/**
 *  初始化操作栏
 */
-(void)initOperateView{
    //操作栏
    self.operateView=[[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, self.tableView.width, 50)];
    self.operateView.backgroundColor=ThemeWhite;
    [self.view addSubview:self.operateView];
    
    //顶部线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.operateView.width, 0.5)];
    line.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.operateView addSubview:line];
    
    //全选按钮
    self.selectAllButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllButton.frame=CGRectMake(2, (self.operateView.height-44)/2, 44, 44);
    self.selectAllButton.tintColor=ThemeRed;
    [self.selectAllButton setImage:[UIImage imageNamed:@"shopping_cart_list_no_select"] forState:UIControlStateNormal];
    [self.selectAllButton setImage:[[UIImage imageNamed:@"shopping_cart_list_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.selectAllButton addTarget:self action:@selector(selectAllButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.operateView addSubview:self.selectAllButton];
    
    //全选文字
    self.allTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(38, (self.operateView.height-16)/2, 30, 16)];
    self.allTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.allTagLabel.textColor=ThemeGray;
    self.allTagLabel.text=@"全选";
    [self.operateView addSubview:self.allTagLabel];
    
    //去结算按钮
    self.payButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame=CGRectMake(self.operateView.width-90-15, (self.operateView.height-39)/2, 90, 39);
    self.payButton.layer.masksToBounds=YES;
    self.payButton.layer.cornerRadius=2;
    self.payButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
    self.payButton.backgroundColor=ThemeRed;
    [self.payButton setTitleColor:ThemeWhite forState:UIControlStateNormal];
    [self.payButton setTitle:@"去结算(0)" forState:UIControlStateNormal];
    [self.operateView addSubview:self.payButton];
    
    //合计文字
    self.totalTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.allTagLabel.right+20, (self.operateView.height-16)/2, 51, 18)];
    self.totalTagLabel.font=[UIFont systemFontOfSize:16.0];
    self.totalTagLabel.textColor=[UIColor blackColor];
    self.totalTagLabel.text=@"合计：";
    [self.operateView addSubview:self.totalTagLabel];
    
    //总价
    self.totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.totalTagLabel.right,(self.operateView.height-24)/2,self.operateView.width-self.totalTagLabel.right-10-self.payButton.width-15,24)];
    self.totalLabel.font=[UIFont systemFontOfSize:22.0];
    self.totalLabel.textColor=ThemeRed;
    self.totalLabel.text=@"¥0";
    [self.operateView addSubview:self.totalLabel];
    
    //修改字体大小
    NSMutableAttributedString *totalAttributedString=[[NSMutableAttributedString alloc] initWithString:self.totalLabel.text];
    [totalAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    
    self.totalLabel.attributedText=totalAttributedString;
}

#pragma mark 按钮事件
/**
 *  导航栏删除按钮
 *
 *  @param sender 按钮对象
 */
-(void)navigationDeleteButton:(UIButton *)sender{

}

/**
 *  全选按钮
 *
 *  @param sender 按钮对象
 */
-(void)selectAllButton:(UIButton *)sender{
    sender.selected=sender.isSelected ? NO : YES;
}

/**
 *  去结算按钮
 *
 *  @param sender 按钮对象
 */
-(void)payButton:(UIButton *)sender{
    
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
                
                for (NSDictionary *dicList in array) {
                    NSMutableDictionary *mutableDic=[NSMutableDictionary dictionaryWithDictionary:dicList];
                    [mutableDic setObject:@"0" forKey:@"isselect"];//动态添加一个key
                    
                    [_goodsList addObject:mutableDic];//添加到列表数据源
                }
                
                [self.tableView reloadData];//刷新tableView
            }
            
            //总价
            self.totalLabel.text=[NSString stringWithFormat:@"¥%@",[dic objectForKey:@"zongjia"]];
            
            //商品数量
            [self.payButton setTitle:[NSString stringWithFormat:@"去结算(%lu)",(unsigned long)_goodsList.count] forState:UIControlStateNormal];
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
