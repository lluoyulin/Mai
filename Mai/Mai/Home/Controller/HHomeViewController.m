//
//  HHomeViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HHomeViewController.h"

#import "Const.h"
#import "UIView+Frame.h"
#import "NSObject+DataConvert.h"
#import "NSObject+HttpTask.h"

#import "HGoodsDetailsViewController.h"
#import "HHomeTableViewCell.h"
#import "HHomeDetailsViewController.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface HHomeViewController (){
    NSMutableArray *_typeList;//列表数据源
    NSInteger _selectIndex;//选中的索引
    CGRect _frame;
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *homeDetailListView;//右边商品列表

@end

@implementation HHomeViewController

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super init];
    
    if (self) {
        _frame=frame;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeWhite;
    
    self.showMenu=YES;
    
    //初始化数据
    [self initData];
    
    _selectIndex=0;
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 87, _frame.size.height)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.homeDetailListView=[[UIView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x+self.tableView.frame.size.width, self.tableView.frame.origin.y, _frame.size.width-self.tableView.frame.size.width, self.tableView.frame.size.height)];
    self.homeDetailListView.layer.masksToBounds=YES;
    [self.view addSubview:self.homeDetailListView];
    
    HHomeDetailsViewController *homeDetailListViewVC=[[HHomeDetailsViewController alloc] initWithFrame:CGRectMake(0, 0, self.homeDetailListView.frame.size.width, self.tableView.frame.size.height)];
    
    [self addChildViewController:homeDetailListViewVC];
    [homeDetailListViewVC didMoveToParentViewController:self];
    
    [self.homeDetailListView addSubview:homeDetailListViewVC.view];
    
    self.delegate=homeDetailListViewVC;
}

/**
 *  初始化数据
 */
-(void)initData{
    //构造参数
    NSDictionary *parm=@{@"token":@"71583E074D967903000B5618E4693918s"};
    
    [self post:@"http://chulai-mai.com/index.php?m=Home&c=App&a=fenlei" parameters:parm cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSArray *array=(NSArray *)result;
            if (array.count>0) {//有数据
                [UserData setObject:[self toJSonWithNSArrayOrNSDictionary:array] forKey:@"typelist"];//保存数据到本地
                
                [_typeList removeAllObjects];//移除全部数据
                
                [_typeList addObjectsFromArray:array];//把返回的数据添加到数据源中
            }
        }
        else{
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"失败:%@",error);
        
    }];
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    HHomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[HHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_typeList[indexPath.row];
    cell.selectIndex=_selectIndex;
    cell.index=indexPath.row;
    
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
    _selectIndex=indexPath.row;
    [self.tableView reloadData];
    
    [self.delegate selectType:_selectIndex];
}

@end
