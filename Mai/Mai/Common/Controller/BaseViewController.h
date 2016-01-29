//
//  BaseViewController.h
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic,getter=isShowMenu) BOOL showMenu;

/**
 *  设置购物车商品数量
 *
 *  @param count 购物车数量
 *  @param sid   商品id
 *  @param fid   商品类型id
 */
-(void)setShoppingCount:(NSString *)count sid:(NSString *)sid fid:(NSString *)fid;

/**
 *  清除购物车
 */
-(void)clearShoppingCart;

@end
