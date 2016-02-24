//
//  TLTimeLimitViewController.h
//  Mai
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@protocol TLTimeLimitViewControllerDelegate <NSObject>

/**
 *  选中类型
 *
 *  @param index 选中类型id
 */
-(void)selectType:(NSString *)fid;

@end

@interface TLTimeLimitViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) id<TLTimeLimitViewControllerDelegate> delegate;

@end
