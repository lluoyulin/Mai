//
//  HGoodsDescriptionsViewController.h
//  Mai
//
//  Created by freedom on 16/1/30.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@protocol HGoodsDescriptionsViewControllerDelegate <NSObject>

@optional
/**
 *  修改ScrollView的滚动坐标
 *
 *  @param offsetY Y坐标
 */
-(void)changeGoodsDescriptionsScrollViewContentOffset:(CGFloat)offsetY;

/**
 *  设置ScrollView的滚动坐标
 *
 *  @param offsetY Y坐标
 */
-(void)setGoodsDescriptionsScrollViewContentOffset:(CGFloat)offsetY;

@end

@interface HGoodsDescriptionsViewController : BaseViewController

@property(nonatomic,strong) NSDictionary *dic;//商品信息

@property(nonatomic,weak) id<HGoodsDescriptionsViewControllerDelegate> delegate;

-(instancetype)initWithHeight:(CGFloat )height;

@end
