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
#import "NSObject+HttpTask.h"
#import "CAlertView.h"
#import "NSObject+Utils.h"

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
    _selectButton.selected=[[self.dic objectForKey:@"isselect"] isEqualToString:@"0"] ? NO : YES;
    
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
    [_price1Label setTextWidth:[NSString stringWithFormat:@"¥%.2f",[[[self.dic objectForKey:@"gs"] objectForKey:@"price1"] floatValue]] size:CGSizeMake(100, 13)];
    _price1Label.frame=CGRectMake(_nameLabel.left, self.height-13-15, _price1Label.width, 13);
    
    //添加删除线
    NSMutableAttributedString *price1AttributedString=[[NSMutableAttributedString alloc] initWithString:_price1Label.text];
    [price1AttributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(0, _price1Label.text.length)];
    
    _price1Label.attributedText=price1AttributedString;
    
    //本店零售价
    _price2Label.font=[UIFont systemFontOfSize:20.0];
    _price2Label.textColor=ThemeRed;
    _price2Label.text=[NSString stringWithFormat:@"¥%.2f",[[[self.dic objectForKey:@"gs"] objectForKey:@"price2"] floatValue]];
    _price2Label.frame=CGRectMake(_nameLabel.left, _price1Label.top-5-22, 100, 22);
    
    //改变字体大小
    NSMutableAttributedString *price2AttributedString=[[NSMutableAttributedString alloc] initWithString:_price2Label.text];
    [price2AttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, 1)];
    
    _price2Label.attributedText=price2AttributedString;
    
    //相加
    _addButton.frame=CGRectMake(self.width-27-10, self.height-27-10, 27, 27);
    _addButton.titleLabel.font=[UIFont systemFontOfSize:11.0];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"shopping_cart_add_btn"] forState:UIControlStateNormal];
    [_addButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [_addButton setTitle:@"＋" forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
    _addButton.selected=YES;
    
    //商品数量
    _countLabel.frame=CGRectMake(_addButton.left-40, _addButton.top, 40, 27);
    _countLabel.font=[UIFont systemFontOfSize:16.0];
    _countLabel.textColor=ThemeRed;
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.layer.masksToBounds=YES;
    _countLabel.layer.borderColor=[ThemeGray CGColor];
    _countLabel.layer.borderWidth=0.5;
    _countLabel.text=[self.dic objectForKey:@"num"];
    
    //相减
    _subtractButton.frame=CGRectMake(_countLabel.left-27, _addButton.top, _addButton.width, _addButton.height);
    _subtractButton.titleLabel.font=[UIFont systemFontOfSize:11.0];
    [_subtractButton setBackgroundImage:[UIImage imageNamed:@"shopping_cart_minus_btn"] forState:UIControlStateNormal];
    [_subtractButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    [_subtractButton setTitle:@"－" forState:UIControlStateNormal];
    [_subtractButton addTarget:self action:@selector(subtractButton:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  选择商品按钮
 *
 *  @param sender 按钮对象
 */
-(void)selectButton:(UIButton *)sender{
    sender.selected=sender.isSelected ? NO : YES;
    
    [self.dic setObject:sender.isSelected ? @"1" : @"0" forKey:@"isselect"];
    
    //选择商品block
    self.SelectBlock();
}

/**
 *  相加按钮
 *
 *  @param sender 按钮对象
 */
-(void)addButton:(UIButton *)sender{
    sender.enabled=NO;
    
    //构造参数
    NSString *url=@"cart_jia";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"sid":[self.dic objectForKey:@"sid"],
                               @"isLogin":[self isLogin] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            //设置商品数量
            _countLabel.text=[[dic objectForKey:@"count"] stringValue];
            
            //修改数据列表中的值
            [self.dic setObject:_countLabel.text forKey:@"num"];
            
            //设置购物车商品数量
            [self setShoppingCount:_countLabel.text sid:[self.dic objectForKey:@"sid"] fid:[[self.dic objectForKey:@"gs"] objectForKey:@"fid"] isAdd:YES];
            
            //商品相加block
            self.addGoodsBlock();
        }
        else{
            [CAlertView alertMessage:error];
        }
        
        sender.enabled=YES;
        
    } failure:^(NSError *error) {
        
        sender.enabled=YES;
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  相减按钮
 *
 *  @param sender 按钮对象
 */
-(void)subtractButton:(UIButton *)sender{
    if ([_countLabel.text isEqualToString:@"1"]) {
        [CAlertView alertMessage:@"商品数量至少1个"];
        return;
    }
    
    sender.enabled=NO;
    
    //构造参数
    NSString *url=@"cart_jian";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[UserData objectForKey:@"uid"] ? [UserData objectForKey:@"uid"] : @"",
                               @"sid":[self.dic objectForKey:@"sid"],
                               @"isLogin":[UserData objectForKey:@"islogin"] ? @"1" : @"0"};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            //设置商品数量
            _countLabel.text=[[dic objectForKey:@"count"] stringValue];
            
            //修改数据列表中的值
            [self.dic setObject:_countLabel.text forKey:@"num"];
            
            //设置购物车商品数量
            [self setShoppingCount:_countLabel.text sid:[self.dic objectForKey:@"sid"] fid:[[self.dic objectForKey:@"gs"] objectForKey:@"fid"] isAdd:NO];
            
            //商品相减block
            self.subtractGoodsBlock();
        }
        else{
            [CAlertView alertMessage:error];
        }
        
        sender.enabled=YES;
        
    } failure:^(NSError *error) {
        
        sender.enabled=YES;
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

@end
