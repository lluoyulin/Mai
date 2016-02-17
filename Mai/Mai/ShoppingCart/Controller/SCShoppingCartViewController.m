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
#import "NSObject+Utils.h"

#import "SCShoppingCartTableViewCell.h"
#import "SCConfirmOrderViewController.h"

#import "MBProgressHUD.h"

@interface SCShoppingCartViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate>{
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
    self.selectAllButton.enabled=YES;
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
    [self.payButton addTarget:self action:@selector(payButton:) forControlEvents:UIControlEventTouchUpInside];
    self.payButton.showsTouchWhenHighlighted=YES;
    [self.operateView addSubview:self.payButton];
    
    //合计文字
    self.totalTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.allTagLabel.right+20, (self.operateView.height-15)/2, 30, 15)];
    self.totalTagLabel.font=[UIFont systemFontOfSize:13.0];
    self.totalTagLabel.textColor=[UIColor blackColor];
    self.totalTagLabel.text=@"合计:";
    [self.operateView addSubview:self.totalTagLabel];
    
    //总价
    self.totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.totalTagLabel.right,(self.operateView.height-22)/2,self.operateView.width-self.totalTagLabel.right-10-self.payButton.width-15,22)];
    self.totalLabel.font=[UIFont systemFontOfSize:20.0];
    self.totalLabel.textColor=ThemeRed;
    self.totalLabel.text=@"¥0.00";
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
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dic in _goodsList) {
        if ([[dic objectForKey:@"isselect"] isEqualToString:@"1"]) {
            [array addObject:@{@"sid":[dic objectForKey:@"sid"],
                               @"fid":[[dic objectForKey:@"gs"] objectForKey:@"fid"],
                               @"num":[dic objectForKey:@"num"]}];
        }
    }
    
    if (array.count==0) {
        [CAlertView alertMessage:@"至少选择一个商品"];
        return;
    }
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"删除选中商品" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //删除购物车商品
        [self deleteShoppingCart:array];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  全选按钮
 *
 *  @param sender 按钮对象
 */
-(void)selectAllButton:(UIButton *)sender{
    sender.selected=sender.isSelected ? NO : YES;
    
    for (NSMutableDictionary *dic in _goodsList) {
        [dic setObject:sender.isSelected ? @"1" : @"0" forKey:@"isselect"];
    }
    
    [self.tableView reloadData];//刷新tableView
    
    //计算总价
    [self calculateTotal];
}

/**
 *  去结算按钮
 *
 *  @param sender 按钮对象
 */
-(void)payButton:(UIButton *)sender{
    //通过谓词筛选数据
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isselect=='1'"];
    NSArray *selectArray=[_goodsList filteredArrayUsingPredicate:predicate];//获取选中商品数据
    
    NSDictionary *dic=@{@"total":[self.totalLabel.text substringFromIndex:1],
                        @"list":selectArray,
                        @"count":[NSString stringWithFormat:@"%lu",(unsigned long)selectArray.count]};//封装购买商品信息
    
    if (selectArray.count==0) {
        [CAlertView alertMessage:@"请至少选择一个商品"];
        return;
    }
    
    SCConfirmOrderViewController *vc=[SCConfirmOrderViewController new];
    vc.dic=dic;
    [self.navigationController pushViewController:vc animated:YES];
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
            
            [_goodsList removeAllObjects];//移除所有数据
            
            for (NSDictionary *dicList in array) {
                NSMutableDictionary *mutableDic=[NSMutableDictionary dictionaryWithDictionary:dicList];
                [mutableDic setObject:@"1" forKey:@"isselect"];//动态添加一个key
                
                [_goodsList addObject:mutableDic];//添加到列表数据源
            }
            
            [self.tableView reloadData];//刷新tableView
            
            //总价
            self.totalLabel.text=[NSString stringWithFormat:@"¥%.2f",[[dic objectForKey:@"zongjia"] floatValue]];
            
            //修改字体大小
            NSMutableAttributedString *totalAttributedString=[[NSMutableAttributedString alloc] initWithString:self.totalLabel.text];
            [totalAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
            
            self.totalLabel.attributedText=totalAttributedString;
            
            //商品数量
            [self.payButton setTitle:[NSString stringWithFormat:@"去结算(%lu)",(unsigned long)_goodsList.count] forState:UIControlStateNormal];
            
            //全选
            self.selectAllButton.enabled=_goodsList.count>0 ? YES : NO;
            self.selectAllButton.selected=_goodsList.count>0 ? YES : NO;
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
 *  计算总价
 */
-(void)calculateTotal{
    //通过谓词筛选数据
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isselect=='1'"];
    NSArray *selectArray=[_goodsList filteredArrayUsingPredicate:predicate];//获取选中商品数据
    
    float total=0;//总价
    NSInteger count=0;//选中商品数量
    for (NSMutableDictionary *dic in selectArray) {
        NSInteger num=[[dic objectForKey:@"num"] integerValue];//商品数量
        float price=[[[dic objectForKey:@"gs"] objectForKey:@"price2"] floatValue];//商品价格
        float specialPrice=[[[dic objectForKey:@"gs"] objectForKey:@"tejia"] floatValue];//商品特价
        
        if ([[[dic objectForKey:@"gs"] objectForKey:@"cuxiao"] integerValue]==2 && [[[dic objectForKey:@"gs"] objectForKey:@"cxlx"] integerValue]==1) {//促销商品
            total+=num*specialPrice;
        }
        else{//正常商品
            total+=num*price;
        }
        
        count++;
    }
    
    //全选
    if (count==_goodsList.count) {
        self.selectAllButton.selected=YES;
    }
    
    //总价
    self.totalLabel.text=[NSString stringWithFormat:@"¥%.2f",total];
    
    //修改字体大小
    NSMutableAttributedString *totalAttributedString=[[NSMutableAttributedString alloc] initWithString:self.totalLabel.text];
    [totalAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    
    self.totalLabel.attributedText=totalAttributedString;
    
    //去结算
    [self.payButton setTitle:[NSString stringWithFormat:@"去结算(%ld)",(long)count] forState:UIControlStateNormal];
}

/**
 *  删除购物车商品
 *
 *  @param array 商品id集合
 */
-(void)deleteShoppingCart:(NSArray *)array{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //封装商品id集合
    NSMutableString *sidList=[[NSMutableString alloc] init];
    for (NSDictionary *dic in array) {
        [sidList appendFormat:@",%@",[dic objectForKey:@"sid"]];
    }
    
    //构造参数
    NSString *url=@"clear_chose_cart";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0",
                               @"sid":[sidList substringFromIndex:1]};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            if (_goodsList.count==array.count) {//清空购物车
                [self clearShoppingCart];
            }
            else{//设置购物车商品数量
                for (NSDictionary *dic in array) {
                    [self clearShoppingCartWithId:[dic objectForKey:@"sid"] fid:[dic objectForKey:@"fid"] count:[dic objectForKey:@"num"]];
                }
            }
            
            //获取数据
            [self loadData];
            
            hud.mode=MBProgressHUDModeText;
            hud.labelText=@"删除成功";
            [hud hide:YES afterDelay:1.5];
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
        
        //选择商品block
        cell.SelectBlock=^(){
            self.selectAllButton.selected=NO;
            
            //计算总价
            [self calculateTotal];
        };
        
        //商品相加block
        cell.addGoodsBlock=^(){
            //计算总价
            [self calculateTotal];
        };
        
        //商品相减block
        cell.subtractGoodsBlock=^(){
            //计算总价
            [self calculateTotal];
        };
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
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"删除选中商品" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            //删除购物车商品
            [self deleteShoppingCart:@[[_goodsList[indexPath.row] objectForKey:@"sid"]]];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
