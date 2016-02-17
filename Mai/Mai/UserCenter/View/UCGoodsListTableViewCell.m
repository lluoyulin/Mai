//
//  UCGoodsListTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/17.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCGoodsListTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

#import "UIImageView+WebCache.h"

@implementation UCGoodsListTableViewCell{
    UIImageView *logoImage;//商品图片
    UILabel *nameLabel;//商品名称
    UILabel *priceLabel;//商品价格
    UILabel *numLabel;//商品数量
    UIView *line;//分割线
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

/**
 *  自定义cell
 */
-(void)initCustomCell{
    //商品图片
    logoImage=[UIImageView new];
    [self.contentView addSubview:logoImage];
    
    //商品名称
    nameLabel=[UILabel new];
    [self.contentView addSubview:nameLabel];
    
    //商品价格
    priceLabel=[UILabel new];
    [self.contentView addSubview:priceLabel];
    
    //商品数量
    numLabel=[UILabel new];
    [self.contentView addSubview:numLabel];
    
    //分割线
    line=[UIView new];
    [self.contentView addSubview:line];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //商品图片
    logoImage.frame=CGRectMake(15, 10, 70, 70);
    logoImage.layer.masksToBounds=YES;
    logoImage.layer.borderColor=[UIColorFromRGB(0xdddddd) CGColor];
    logoImage.layer.borderWidth=0.5;
    logoImage.layer.cornerRadius=3;
    [logoImage sd_setImageWithURL:[NSURL URLWithString:[[self.dic objectForKey:@"gs"] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    //商品名称
    nameLabel.frame=CGRectMake(logoImage.right+10, 20, self.width-logoImage.right-10-15, 16);
    nameLabel.font=[UIFont systemFontOfSize:14.0];
    nameLabel.textColor=ThemeBlack;
    nameLabel.text=[[self.dic objectForKey:@"gs"] objectForKey:@"title"];
    
    //商品价格
    priceLabel.frame=CGRectMake(nameLabel.left, nameLabel.bottom+8, 0, 15);
    priceLabel.font=[UIFont systemFontOfSize:13.0];
    priceLabel.textColor=ThemeGray;
    [priceLabel setTextWidth:[NSString stringWithFormat:@"¥%.2f",[[[self.dic objectForKey:@"gs"] objectForKey:@"price2"] floatValue]] size:CGSizeMake(100, 15)];
    
    //商品数量
    numLabel.frame=CGRectMake(priceLabel.right+10, priceLabel.top, self.width-priceLabel.right-10-15, 15);
    numLabel.font=[UIFont systemFontOfSize:13.0];
    numLabel.textColor=ThemeRed;
    
    NSString *num=[self.dic objectForKey:@"num"];
    numLabel.text=[NSString stringWithFormat:@"X %@",num];
    
//    //修改字体大小
//    NSMutableAttributedString *numlAttributedString=[[NSMutableAttributedString alloc] initWithString:numLabel.text];
//    [numlAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(2, num.length)];
//    
//    numLabel.attributedText=numlAttributedString;
    
    //分割线
    line.frame=CGRectMake(15, self.height-0.5, self.width-15-15, 0.5);
    line.backgroundColor=UIColorFromRGB(0xdddddd);
}

@end
