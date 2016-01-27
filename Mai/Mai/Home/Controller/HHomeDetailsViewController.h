//
//  HHomeDetailsViewController.h
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

#import "HHomeViewController.h"

@interface HHomeDetailsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,HHomeViewControllerDelegate>

/**
 *  刷新购物车block
 */
@property(nonatomic,copy) void(^RefreshShoppingCartBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;

@end
