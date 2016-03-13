//
//  MPPointsTableViewCell.m
//  Mai
//
//  Created by freedom on 16/3/13.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "MPPointsTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

#import "UIImageView+WebCache.h"

@implementation MPPointsTableViewCell{
    UIImageView *_logoImage;//积分类型logo
    UILabel *_nameLabel;//积分类型名称
    UILabel *_descriptionLabel;//积分类型简介
    UILabel *_pointsLabel;//积分
    UIView *_lineView;//线
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

-(void)initCustomCell{
    //积分类型logo
    _logoImage=[UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    //积分类型名称
    _nameLabel=[UILabel new];
    [self.contentView addSubview:_nameLabel];
    
    //积分类型简介
    _descriptionLabel=[UILabel new];
    [self.contentView addSubview:_descriptionLabel];
    
    //积分
    _pointsLabel=[UILabel new];
    [self.contentView addSubview:_pointsLabel];
    
    //线
    _lineView=[UIView new];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.backgroundColor=[UIColor whiteColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //积分类型logo
    _logoImage.frame=CGRectMake(15, (self.height-28)/2, 28, 28);
    _logoImage.image=[UIImage imageNamed:@"checkin"];
    
    //积分类型名称
    _nameLabel.frame=CGRectMake(_logoImage.right+10, 15, 100, 16);
    _nameLabel.font=[UIFont systemFontOfSize:14.0];
    _nameLabel.textColor=UIColorFromRGB(0x292f33);
    _nameLabel.text=[self.dicPoint objectForKey:@"title"];
    
    //积分类型简介
    _descriptionLabel.frame=CGRectMake(_nameLabel.left, _nameLabel.bottom+5, 200, 15);
    _descriptionLabel.font=[UIFont systemFontOfSize:13.0];
    _descriptionLabel.textColor=UIColorFromRGB(0xaab8c2);
    _descriptionLabel.text=[self.dicPoint objectForKey:@"tip"];
    
    //积分
    _pointsLabel.font=[UIFont systemFontOfSize:22.0];
    _pointsLabel.textColor=UIColorFromRGB(0xef4235);
    [_pointsLabel setTextWidth:[NSString stringWithFormat:@"+%@",[self.dicPoint objectForKey:@"total"]] size:CGSizeMake(100, 24)];
    _pointsLabel.frame=CGRectMake(self.width-15-_pointsLabel.width, (self.height-24)/2, _pointsLabel.width, 24);
    
    //线
    _lineView.frame=CGRectMake(_descriptionLabel.left, _descriptionLabel.bottom+15, self.width-_descriptionLabel.left, 0.5);
    _lineView.backgroundColor=UIColorFromRGB(0xf2f2f2);
}

@end
