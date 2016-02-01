//
//  HHomeDetailsTableViewCell.m
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HHomeDetailsTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"
#import "NSObject+HttpTask.h"
#import "CAlertView.h"

#import "UIImageView+WebCache.h"

@implementation HHomeDetailsTableViewCell{
    UIImageView *_goodsImage;//商品图片
    UILabel *_nameLabel;//商品名称
    UILabel *_descriptionLabel;//简述
    UILabel *_price1Label;//本店零售价
    UILabel *_price2Label;//零售价
    UILabel *_salesLabel;//销量
    UIButton *_shoppingButton;//购买
    UIView *_line;//单元格分割线
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
    //商品图片
    _goodsImage=[UIImageView new];
    [self.contentView addSubview:_goodsImage];
    
    //商品名称
    _nameLabel=[UILabel new];
    [self.contentView addSubview:_nameLabel];
    
    //简述
    _descriptionLabel=[UILabel new];
    [self.contentView addSubview:_descriptionLabel];
    
    //零售价
    _price1Label=[UILabel new];
    [self.contentView addSubview:_price1Label];
    
    //本店零售价
    _price2Label=[UILabel new];
    [self.contentView addSubview:_price2Label];
    
    //销量
    _salesLabel=[UILabel new];
    [self.contentView addSubview:_salesLabel];
    
    //购买
    _shoppingButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_shoppingButton];
    
    //单元格分割线
    _line=[UIView new];
    [self.contentView addSubview:_line];
    
    //购买数量
    _countLabel=[UILabel new];
    [_shoppingButton addSubview:_countLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //商品图片
    _goodsImage.frame=CGRectMake(15, 15, 90, 90);
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[self.dic objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    //商品名称
    _nameLabel.frame=CGRectMake(_goodsImage.right+10, _goodsImage.top, self.width-_goodsImage.right-10-15, 16);
    _nameLabel.font=[UIFont systemFontOfSize:14.0];
    _nameLabel.textColor=ThemeBlack;
    _nameLabel.text=[self.dic objectForKey:@"title"];
    
    //简述
    _descriptionLabel.frame=CGRectMake(_nameLabel.left, _nameLabel.bottom+5, _nameLabel.width, 13);
    _descriptionLabel.font=[UIFont systemFontOfSize:11.0];
    _descriptionLabel.textColor=ThemeRed;
    _descriptionLabel.text=[self.dic objectForKey:@"jianshu"];
    
    //零售价
    _price2Label.font=[UIFont systemFontOfSize:11.0];
    _price2Label.textColor=ThemeGray;
    [_price2Label setTextWidth:[NSString stringWithFormat:@"¥%@",[self.dic objectForKey:@"price1"]] size:CGSizeMake(40, 13)];
    _price2Label.frame=CGRectMake(_nameLabel.left, _goodsImage.bottom-13, _price2Label.width, 13);
    
    //添加删除线
    NSMutableAttributedString *price2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",[self.dic objectForKey:@"price1"]]];
    [price2 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, price2.length)];
    _price2Label.attributedText = price2;
    
    //销量
    _salesLabel.font=[UIFont systemFontOfSize:11.0];
    _salesLabel.textColor=ThemeGray;
    [_salesLabel setTextWidth:[NSString stringWithFormat:@"已销%@笔",[self.dic objectForKey:@"xl"]] size:CGSizeMake(self.width-_price2Label.right-5, 13)];
    _salesLabel.frame=CGRectMake(_price2Label.right+5, _price2Label.top, _salesLabel.width, 13);
    
    //购买
    _shoppingButton.frame=CGRectMake(self.width-44, _descriptionLabel.bottom, 44, 44);
    _shoppingButton.tintColor=ThemeRed;
    [_shoppingButton setImage:[UIImage imageNamed:@"home_shopping"] forState:UIControlStateNormal];
    [_shoppingButton setImage:[[UIImage imageNamed:@"home_shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [_shoppingButton addTarget:self action:@selector(shoppingButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //购买数量
    _countLabel.frame=CGRectMake(_shoppingButton.width-14-6, 6, 14, 14);
    _countLabel.font=[UIFont systemFontOfSize:10.0];
    _countLabel.textColor=[UIColor whiteColor];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.backgroundColor=[UIColor redColor];
    _countLabel.layer.masksToBounds=YES;
    _countLabel.layer.cornerRadius=_countLabel.width/2;
    
    //获取商品购物车数量
    NSString *count=[UserData objectForKey:[NSString stringWithFormat:@"sid_%@",[self.dic objectForKey:@"sid"]]];
    _countLabel.text=count ? count : @"";
    _countLabel.hidden=count ? NO : YES;
    
    _shoppingButton.selected=!_countLabel.isHidden;
    
    //本店零售价
    _price1Label.frame=CGRectMake(_nameLabel.left, _price2Label.top-22-10, _nameLabel.width-_shoppingButton.width, 22);
    _price1Label.font=[UIFont systemFontOfSize:20.0];
    _price1Label.textColor=ThemeRed;
    
    //修改字体大小
    NSMutableAttributedString *price1=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[self.dic objectForKey:@"price2"]]];
    [price1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    _price1Label.attributedText=price1;
    
    //单元格分割线
    _line.frame=CGRectMake(_nameLabel.left, self.height-0.5, self.width-_goodsImage.right-10, 0.5);
    _line.backgroundColor=UIColorFromRGB(0xdddddd);
}

/**
 *  添加购物车
 *
 *  @param sender 按钮对象
 */
-(void)shoppingButton:(UIButton *)sender{
    //构造参数
    NSString *url=@"add_to_car";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[UserData objectForKey:@"uid"] ? [UserData objectForKey:@"uid"] : @"",
                               @"gid":[self.dic objectForKey:@"sid"],
                               @"isLogin":[UserData objectForKey:@"islogin"] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            //添加购物车成功
            self.ShoppingBlock([self.dic objectForKey:@"sid"],[dic objectForKey:@"count"],[self.dic objectForKey:@"fid"]);
            
            //发送添加购物车通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"add_shopping_cart" object:nil];
        }
        else{
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [CAlertView alertMessage:NetErrorMessage];
        
        NSLog(@"失败:%@",error);
        
    }];
}

@end
