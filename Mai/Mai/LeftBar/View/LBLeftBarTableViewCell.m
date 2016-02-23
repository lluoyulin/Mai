//
//  LBLeftBarTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "LBLeftBarTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

@implementation LBLeftBarTableViewCell{
    UIImageView *logoImage;
    UILabel *nameLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

-(void)initCustomCell{
    logoImage=[UIImageView new];
    [self.contentView addSubview:logoImage];
    
    nameLabel=[UILabel new];
    [self.contentView addSubview:nameLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor=UIColorFromRGB(0x13112b);
    
    nameLabel.font=[UIFont systemFontOfSize:14.0];
    [nameLabel setTextWidth:[self.dic objectForKey:@"name"] size:CGSizeMake(150, 16)];
    
    logoImage.frame=CGRectMake((self.width-28-15-nameLabel.width)/2, (self.height-28)/2, 28, 28);
    logoImage.tintColor=ThemeYellow;
    
    nameLabel.frame=CGRectMake(logoImage.right+15, (self.height-16)/2, nameLabel.width, 16);
    
    if ([[self.dic objectForKey:@"isselect"] integerValue]==1) {//选中栏目
        nameLabel.textColor=ThemeYellow;
        logoImage.image=[[UIImage imageNamed:[self.dic objectForKey:@"logo"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else{//未选中栏目
        nameLabel.textColor=ThemeWhite;
        logoImage.image=[UIImage imageNamed:[self.dic objectForKey:@"logo"]];
    }
}

@end
