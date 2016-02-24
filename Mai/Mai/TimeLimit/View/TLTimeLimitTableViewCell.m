//
//  TLTimeLimitTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/24.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "TLTimeLimitTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

@implementation TLTimeLimitTableViewCell{
    UILabel *_name;//商品名称
    UIView *_line;//右边线
    UILabel *_countLabel;//购买数量
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

-(void)initCustomCell{
    //商品名称
    _name=[UILabel new];
    [self.contentView addSubview:_name];
    
    //右边线
    _line=[UIView new];
    [self.contentView addSubview:_line];
    
    //购买数量
    _countLabel=[UILabel new];
    [self.contentView addSubview:_countLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor=UIColorFromRGB(0xf9f9f9);
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //商品名称
    _name.font=[UIFont systemFontOfSize:11.0];
    _name.textColor=ThemeBlack;
    [_name setTextWidth:[self.dic objectForKey:@"name"] size:CGSizeMake(self.width, 13)];
    _name.frame=CGRectMake((self.width-_name.width)/2, (self.height-_name.height)/2, _name.width, 13);
    
    //右边线
    _line.frame=CGRectMake(self.width-0.5, 0, 0.5, self.height);
    _line.backgroundColor=UIColorFromRGB(0xdddddd);
    
    //购买数量
    _countLabel.frame=CGRectMake(10, 5, 14, 14);
    _countLabel.font=[UIFont systemFontOfSize:10.0];
    _countLabel.textColor=[UIColor whiteColor];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.backgroundColor=[UIColor redColor];
    _countLabel.layer.masksToBounds=YES;
    _countLabel.layer.cornerRadius=_countLabel.width/2;
    
    //获取商品购物车数量
    NSString *count=[UserData objectForKey:[NSString stringWithFormat:@"fid_%@",[self.dic objectForKey:@"id"]]];
    _countLabel.text=count ? count : @"";
    _countLabel.hidden=count ? NO : YES;
    
    //是否选中该单元格
    if (self.index==self.selectIndex) {
        [self setSelected:YES animated:YES];
    }
    else{
        [self setSelected:NO animated:YES];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        _name.textColor=ThemeRed;
    }
    else{
        _name.textColor=ThemeBlack;
    }
}

@end
