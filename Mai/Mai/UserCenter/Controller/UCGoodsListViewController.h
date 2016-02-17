//
//  UCGoodsListViewController.h
//  Mai
//
//  Created by freedom on 16/2/17.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@interface UCGoodsListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *goodsList;//商品信息数据源

@end
