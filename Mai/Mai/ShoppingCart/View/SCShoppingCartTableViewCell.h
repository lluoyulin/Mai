//
//  SCShoppingCartTableViewCell.h
//  Mai
//
//  Created by freedom on 16/2/1.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCShoppingCartTableViewCell : UITableViewCell

@property(nonatomic,strong) NSMutableDictionary *dic;

/**
 *  选择商品block
 */
@property(nonatomic,copy) void(^SelectBlock)(void);

/**
 *  商品相加block
 */
@property(nonatomic,copy) void(^addGoodsBlock)(void);

/**
 *  商品相减block
 */
@property(nonatomic,copy) void(^subtractGoodsBlock)(void);

@end
