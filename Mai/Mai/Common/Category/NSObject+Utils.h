//
//  NSObject+Utils.h
//  Mai
//
//  Created by freedom on 16/2/2.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)

/**
 *  设置购物车商品数量
 *
 *  @param count 购物车数量
 *  @param sid   商品id
 *  @param fid   商品类型id
 *  @param isAdd 是否为添加
 */
-(void)setShoppingCount:(NSString *)count sid:(NSString *)sid fid:(NSString *)fid isAdd:(BOOL)isAdd;

/**
 *  清除购物车
 */
-(void)clearShoppingCart;

/**
 *  是否登录
 *
 *  @return 登录返回yes，未登录返回no
 */
-(BOOL)isLogin;

/**
 *  获取用户id
 *
 *  @return 用户id
 */
-(NSString *)getUid;

@end
