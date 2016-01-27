//
//  BaseViewController.m
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

#import "Const.h"
#import "NSObject+DataConvert.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor=ThemeYellow;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:ThemeBlack};
    [self.navigationController.navigationBar setTranslucent:NO];
}

/**
 *  setter
 *
 *  @param showMenu
 */
-(void)setShowMenu:(BOOL)showMenu{
    _showMenu=showMenu;
    
    if (self.isShowMenu) {
        UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame=CGRectMake(0, 0, 44, 44);
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 22)];
        [leftButton setImage:[UIImage imageNamed:@"navigation_menu"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        self.navigationItem.leftBarButtonItem=leftItem;
    }
}

/**
 *  左边按钮
 *
 *  @param sender 按钮对象
 */
-(void)leftButton:(UIButton *)sender{
    if (self.isShowMenu) {
        //点击汉堡包发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showmenu" object:nil];
    }
}

/**
 *  设置购物车商品数量
 *
 *  @param count 购物车数量
 *  @param sid   商品id
 *  @param fid   商品类型id
 */
-(void)setShoppingCount:(NSString *)count sid:(NSString *)sid fid:(NSString *)fid{
    //缓存购物车中商品数量
    NSString *key=[NSString stringWithFormat:@"sid_%@",sid];//生成对应商品id的缓存key
    
    [UserData setObject:count forKey:key];
    
    //缓存购物车中商品id集合数据
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSString *json=[UserData objectForKey:@"sid_list"];//商品类型id集合数据
    if (json) {
        [array addObjectsFromArray:[self toNSArryOrNSDictionaryWithJSon:json]];
        if (![array containsObject:key]) {
            [array addObject:key];
        }
    }
    else{
        [array addObject:key];
    }
    
    [UserData setObject:[self toJSonWithNSArrayOrNSDictionary:array] forKey:@"sid_list"];
    [UserData synchronize];
    
    if (![fid isEqualToString:@""]) {//不是所有商品类型
        //设置购物车中商品所属类型总数量
        [self setTypeWithFid:fid];
    }
}

/**
 *  设置购物车中商品所属类型总数量
 *
 *  @param count 购物车数量
 */
-(void)setTypeWithFid:(NSString *)fid{
    //缓存商品类型总数量
    NSString *key=[NSString stringWithFormat:@"fid_%@",fid];//生成商品所属类型id的缓存key
    NSString *sum=[UserData objectForKey:key];//商品类型总数量
    if (sum) {
        NSInteger sumCount=[sum integerValue]+1;
        sum=[NSString stringWithFormat:@"%ld",(long)sumCount];
    }
    else{
        sum=@"1";
    }
    
    [UserData setObject:sum forKey:key];
    
    //缓存购物车中商品类型id集合数据
    NSMutableArray *array=[[NSMutableArray alloc] init];
    NSString *json=[UserData objectForKey:@"fid_list"];//商品类型id集合数据
    if (json) {
        [array addObjectsFromArray:[self toNSArryOrNSDictionaryWithJSon:json]];
        if (![array containsObject:key]) {
            [array addObject:key];
        }
    }
    else{
        [array addObject:key];
    }
    
    [UserData setObject:[self toJSonWithNSArrayOrNSDictionary:array] forKey:@"fid_list"];
    [UserData synchronize];
}

/**
 *  清除购物车商品数量
 */
-(void)clearShoppingCount{
    //清除商品id集合
    NSString *goodsJson=[UserData objectForKey:@"sid_list"];
    if (goodsJson) {
        NSArray *array=[self toNSArryOrNSDictionaryWithJSon:goodsJson];
        for (NSString *key in array) {
            [UserData setObject:nil forKey:key];
        }
        [UserData setObject:nil forKey:@"sid_list"];
        [UserData synchronize];
    }
    
    //清除商品类型集合
    NSString *typeJson=[UserData objectForKey:@"fid_list"];
    if (typeJson) {
        NSArray *array=[self toNSArryOrNSDictionaryWithJSon:typeJson];
        for (NSString *key in array) {
            [UserData setObject:nil forKey:key];
        }
        [UserData setObject:nil forKey:@"fid_list"];
        [UserData synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
