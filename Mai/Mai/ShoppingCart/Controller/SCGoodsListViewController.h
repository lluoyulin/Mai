//
//  SCGoodsListViewController.h
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGoodsListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSArray *goodsList;//购买商品数据源

@end
