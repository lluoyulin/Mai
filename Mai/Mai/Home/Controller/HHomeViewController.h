//
//  HHomeViewController.h
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@protocol HHomeViewControllerDelegate <NSObject>

/**
 *  选中类型
 *
 *  @param index 选中类型索引
 */
-(void)selectType:(NSInteger)index;

@end

@interface HHomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) id<HHomeViewControllerDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;

@end
