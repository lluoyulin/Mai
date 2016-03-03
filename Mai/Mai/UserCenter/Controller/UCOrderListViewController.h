//
//  UCOrderListViewController.h
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@interface UCOrderListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,strong) NSString *flag;

@end
