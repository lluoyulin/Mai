//
//  UCOrderListTableViewCell.h
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCOrderListTableViewCell : UITableViewCell

@property(nonatomic,strong) NSDictionary *dic;
@property(nonatomic,strong) UIView *goodsList;

/**
 *  取消订单
 */
@property(nonatomic,copy) void(^cancelOrderBlock)(NSString *orderNO);

/**
 *  支付订单
 */
@property(nonatomic,copy) void(^payOrderBlock)(void);

/**
 *  查看订单
 */
@property(nonatomic,copy) void(^queryOrderBlock)(void);

@end
