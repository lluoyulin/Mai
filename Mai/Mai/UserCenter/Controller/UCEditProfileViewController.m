//
//  UCEditProfileViewController.m
//  Mai
//
//  Created by freedom on 16/2/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCEditProfileViewController.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

#import "UIImageView+WebCache.h"

@interface UCEditProfileViewController (){
    NSMutableArray *_list;
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *tableHeaderView;//表格头部视图
@property(nonatomic,strong) UIButton *headButton;//头像按钮
@property(nonatomic,strong) UILabel *headTagLabel;//头像标签
@property(nonatomic,strong) UIImageView *headImage;//头像
@property(nonatomic,strong) UIImageView *headButtonFlag;//头像按钮标志

@end

@implementation UCEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改资料";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);

    //初始化表格
    [self initTableView];
    
    //初始化表格头部视图
    [self initTableHeaderView];
}

#pragma mark 初始化视图
/**
 *  初始化表格
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

/**
 *  初始化表格头部视图
 */
-(void)initTableHeaderView{
    //表格头部视图
    self.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 107)];
    self.tableHeaderView.backgroundColor=self.tableView.backgroundColor;
    self.tableView.tableHeaderView=self.tableHeaderView;
    
    //头像按钮
    self.headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.headButton.frame=CGRectMake(0, 15, self.tableHeaderView.width, 77);
    self.headButton.backgroundColor=ThemeWhite;
    [self.headButton addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeaderView addSubview:self.headButton];
    
    //顶部分割线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headButton.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.headButton addSubview:topLine];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.headButton.height-0.5, topLine.width, topLine.height)];
    bottomLine.backgroundColor=topLine.backgroundColor;
    [self.headButton addSubview:bottomLine];
    
    //头像标签
    self.headTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, (self.headButton.height-16)/2, 0, 16)];
    self.headTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.headTagLabel.textColor=ThemeGray;
    [self.headTagLabel setTextWidth:@"头像" size:CGSizeMake(100, 16)];
    [self.headButton addSubview:self.headTagLabel];
    
    //头像按钮标志
    self.headButtonFlag=[[UIImageView alloc] initWithFrame:CGRectMake(self.headButton.width-16-15, (self.headButton.height-16)/2, 16, 16)];
    self.headButtonFlag.image=[UIImage imageNamed:@"order_address_arrow"];
    [self.headButton addSubview:self.headButtonFlag];
    
    //头像
    self.headImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.headButtonFlag.left-15-56, (self.headButton.height-56)/2, 56, 56)];
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=self.headImage.width/2;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"image_default"]];
    [self.headButton addSubview:self.headImage];
}

#pragma mark 自定义方法

#pragma mark 按钮事件
/**
 *  头像按钮
 *
 *  @param sender
 */
-(void)headButton:(UIButton *)sender{
    NSLog(@"aaaaaa");
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
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
//    cell.dic=_list[indexPath.row];
    
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
    return 44;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
