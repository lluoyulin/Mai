//
//  UCEditProfileTableViewCell.h
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCEditProfileTableViewCell : UITableViewCell

@property(nonatomic,strong) NSDictionary *dic;
@property(nonatomic,getter=isLast) BOOL last;

@end
