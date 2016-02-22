//
//  UCOrderListTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCOrderListTableViewCell.h"

#import "Const.h"

@implementation UCOrderListTableViewCell{
    UILabel *countLabel;//商品数量
    UILabel *payLabel;//实付款
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

-(void)initCustomCell{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor=ThemeWhite;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

@end
