//
//  NSObject+Utils.m
//  Mai
//
//  Created by freedom on 16/2/2.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "NSObject+Utils.h"

#import "Const.h"
#import "NSObject+DataConvert.h"

@implementation NSObject (Utils)

/**
 *  设置购物车商品数量
 *
 *  @param count 购物车数量
 *  @param sid   商品id
 *  @param fid   商品类型id
 *  @param isAdd 是否为添加
 */
-(void)setShoppingCount:(NSString *)count sid:(NSString *)sid fid:(NSString *)fid isAdd:(BOOL)isAdd{
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
        [self setTypeWithFid:fid isAdd:isAdd];
    }
}

/**
 *  设置购物车中商品所属类型总数量
 *
 *  @param count 购物车数量
 *  @param isAdd 是否为添加
 */
-(void)setTypeWithFid:(NSString *)fid isAdd:(BOOL)isAdd{
    //缓存商品类型总数量
    NSString *key=[NSString stringWithFormat:@"fid_%@",fid];//生成商品所属类型id的缓存key
    NSString *sum=[UserData objectForKey:key];//商品类型总数量
    if (sum) {
        NSInteger sumCount=[sum integerValue]+(isAdd ? 1 : -1);
        sum=[NSString stringWithFormat:@"%ld",(long)sumCount];
    }
    else{
        sum=@"1";
    }
    
    [UserData setObject:[sum isEqualToString:@"0"] ? nil : sum forKey:key];
    
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
    
    //添加购物车商品数量
    [self addShoppingCountIsAdd:isAdd];
}

/**
 *  添加购物车商品数量
 *  @param isAdd 是否为添加
 */
-(void)addShoppingCountIsAdd:(BOOL)isAdd{
    NSString *sum=[UserData objectForKey:@"total_shopping_cart"];//商品类型总数量
    if (sum) {
        NSInteger sumCount=[sum integerValue]+(isAdd ? 1 : -1);
        sum=[NSString stringWithFormat:@"%ld",(long)sumCount];
    }
    else{
        sum=@"1";
    }
    
    [UserData setObject:[sum isEqualToString:@"0"] ? nil : sum forKey:@"total_shopping_cart"];
    [UserData synchronize];
    
    //发送添加购物车通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"add_shopping_cart" object:nil];
}

/**
 *  清除购物车
 */
-(void)clearShoppingCart{
    //清除商品id集合
    NSString *goodsJson=[UserData objectForKey:@"sid_list"];
    if (goodsJson) {
        NSArray *array=[self toNSArryOrNSDictionaryWithJSon:goodsJson];
        for (NSString *key in array) {
            [UserData setObject:nil forKey:key];
        }
        [UserData setObject:nil forKey:@"sid_list"];
    }
    
    //清除商品类型集合
    NSString *typeJson=[UserData objectForKey:@"fid_list"];
    if (typeJson) {
        NSArray *array=[self toNSArryOrNSDictionaryWithJSon:typeJson];
        for (NSString *key in array) {
            [UserData setObject:nil forKey:key];
        }
        [UserData setObject:nil forKey:@"fid_list"];
    }
    
    //清除商品总数量
    [UserData setObject:nil forKey:@"total_shopping_cart"];
    [UserData synchronize];
    
    //发送添加购物车通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"add_shopping_cart" object:nil];
}

/**
 *  是否登录
 *
 *  @return 登录返回yes，未登录返回no
 */
-(BOOL)isLogin{
    [UserData setObject:@"1" forKey:@"islogin"];
    [UserData synchronize];
    return [UserData objectForKey:@"islogin"] ? YES : NO;
}

/**
 *  获取用户id
 *
 *  @return 用户id
 */
-(NSString *)getUid{
    [UserData setObject:@"113" forKey:@"uid"];
    [UserData synchronize];
    return [UserData objectForKey:@"uid"] ? [UserData objectForKey:@"uid"] : @"";
}

@end
