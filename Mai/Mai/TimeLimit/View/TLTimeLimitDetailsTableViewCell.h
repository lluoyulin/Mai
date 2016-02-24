//
//  TLTimeLimitDetailsTableViewCell.h
//  Mai
//
//  Created by freedom on 16/2/24.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTimeLimitDetailsTableViewCell : UITableViewCell

@property(nonatomic,strong) NSMutableDictionary *dic;

/**
 *  添加购物车成功Block
 */
@property(nonatomic,copy) void(^ShoppingBlock)(NSString *sid,NSString *count,NSString *fid);

@end
