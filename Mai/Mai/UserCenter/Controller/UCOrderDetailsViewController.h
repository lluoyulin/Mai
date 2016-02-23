//
//  UCOrderDetailsViewController.h
//  Mai
//
//  Created by freedom on 16/2/17.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@interface UCOrderDetailsViewController : BaseViewController

@property(nonatomic,strong) NSDictionary *dic;//订单信息
@property(nonatomic,getter=isPayViewHidden) BOOL payViewHidden;//是否隐藏支付视图

@end
