//
//  TLTimeLimitDetailsViewController.h
//  Mai
//
//  Created by freedom on 16/2/24.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

#import "TLTimeLimitViewController.h"

@interface TLTimeLimitDetailsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,TLTimeLimitViewControllerDelegate>

/**
 *  刷新购物车block
 */
@property(nonatomic,copy) void(^RefreshShoppingCartBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;

@end
