//
//  SCShoppingCartViewController.h
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,ShoppingCartStyle) {
    ShoppingCartStyleDefault,
    ShoppingCartStyleInTabBar
};

@interface SCShoppingCartViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

-(instancetype)initWithStyle:(ShoppingCartStyle)style;

@end
