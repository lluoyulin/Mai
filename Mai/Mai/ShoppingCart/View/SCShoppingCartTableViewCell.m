//
//  SCShoppingCartTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/1.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "SCShoppingCartTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

#import "UIImageView+WebCache.h"

@interface SCShoppingCartTableViewCell (){
    UIButton *_selectButton;//商品选择按钮
    UIImageView *_goodsImage;//商品图片
    UILabel *_nameLabel;//商品名称
    UILabel *_descriptionLabel;//简述
    UILabel *_price1Label;//零售价
    UILabel *_price2Label;//本店零售价
    UIButton *_subtractButton;//相减
    UIButton *_addButton;//相加
    UILabel *_countLabel;//商品数量
}

@end

@implementation SCShoppingCartTableViewCell

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
    
    //商品选择按钮
    _selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_selectButton];
    
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
    
    //相减
    _subtractButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_subtractButton];
    
    //相加
    _addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_addButton];
    
    //商品数量
    _countLabel=[UILabel new];
    [self.contentView addSubview:_countLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //商品选择按钮
    _selectButton.frame=CGRectMake(0, (self.height-44)/2, 44, 44);
    _selectButton.tintColor=ThemeRed;
    [_selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 16)];
    [_selectButton setImage:[UIImage imageNamed:@"shopping_cart_list_no_select"] forState:UIControlStateNormal];
    [_selectButton setImage:[[UIImage imageNamed:@"shopping_cart_list_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //商品图片
    _goodsImage.frame=CGRectMake(_selectButton.right-6, 15, 80, 80);
    _goodsImage.layer.masksToBounds=YES;
    _goodsImage.layer.cornerRadius=3;
    _goodsImage.layer.borderColor=[UIColorFromRGB(0xdddddd) CGColor];
    _goodsImage.layer.borderWidth=0.5;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[[self.dic objectForKey:@"gs"] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    //商品名称
    _nameLabel.frame=CGRectMake(_goodsImage.right+10, _goodsImage.top, self.width-_goodsImage.right-10-10, 16);
    _nameLabel.font=[UIFont systemFontOfSize:14.0];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text=[[self.dic objectForKey:@"gs"] objectForKey:@"title"];
    
    //简述
    _descriptionLabel.frame=CGRectMake(_nameLabel.left, _nameLabel.bottom+5, _nameLabel.width, 13);
    _descriptionLabel.font=[UIFont systemFontOfSize:11.0];
    _descriptionLabel.textColor=ThemeRed;
    _descriptionLabel.text=[[self.dic objectForKey:@"gs"] objectForKey:@"jianshu"];
    
    //零售价
    _price1Label.font=[UIFont systemFontOfSize:11.0];
    _price1Label.textColor=ThemeGray;
    [_price1Label setTextWidth:[NSString stringWithFormat:@"¥%@",[[self.dic objectForKey:@"gs"] objectForKey:@"price1"]] size:CGSizeMake(100, 13)];
    _price1Label.frame=CGRectMake(_nameLabel.left, self.height-13-15, _price1Label.width, 13);
    
    //添加删除线
    NSMutableAttributedString *price1AttributedString=[[NSMutableAttributedString alloc] initWithString:_price1Label.text];
    [price1AttributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(0, _price1Label.text.length)];
    
    _price1Label.attributedText=price1AttributedString;
    
    //本店零售价
    _price2Label.font=[UIFont systemFontOfSize:20.0];
    _price2Label.textColor=ThemeRed;
    _price2Label.text=[NSString stringWithFormat:@"¥%@",[[self.dic objectForKey:@"gs"] objectForKey:@"price2"]];
    _price2Label.frame=CGRectMake(_nameLabel.left, _price1Label.top-5-22, 100, 22);
    
    //改变字体大小
    NSMutableAttributedString *price2AttributedString=[[NSMutableAttributedString alloc] initWithString:_price1Label.text];
    [price2AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    
    _price2Label.attributedText=price2AttributedString;
    
    //相减
    
    //相加
    
    //商品数量
}

/**
 *  选择商品按钮
 *
 *  @param sender 按钮对象
 */
-(void)selectButton:(UIButton *)sender{
    sender.selected=sender.isSelected ? NO : YES;
}

@end
