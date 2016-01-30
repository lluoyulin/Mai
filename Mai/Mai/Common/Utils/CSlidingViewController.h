//
//  CSlidingViewController.h
//  Mai
//
//  Created by freedom on 16/1/30.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSlidingViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

/**
 *  初始化选项卡
 *
 *  @param viewControllers     加载VC数组
 *  @param segmentedViewHeight 选项卡高度
 *  @param segmentedViewY      选项卡Y坐标
 *  @param isSliding           选项卡是否滚动
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers segmentedViewHeight:(CGFloat)segmentedViewHeight segmentedViewY:(CGFloat)segmentedViewY isSliding:(BOOL)isSliding;

/**
 *  配置选项卡
 *
 *  @param viewControllers     加载VC数组
 *  @param segmentedViewHeight 选项卡高度
 *  @param segmentedViewY      选项卡Y坐标
 *  @param isSliding           选项卡是否滚动
 *  @param selectIndex         默认选中VC索引
 */
-(void)configureWithViewControllers:(NSArray *)viewControllers segmentedViewHeight:(CGFloat)segmentedViewHeight segmentedViewY:(CGFloat)segmentedViewY isSliding:(BOOL)isSliding selectIndex:(NSInteger)index;

/**
 *  显示选项卡
 */
-(void)show;

@end
