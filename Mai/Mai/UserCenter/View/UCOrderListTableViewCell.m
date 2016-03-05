//
//  UCOrderListTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCOrderListTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

#import "SCGoodsListViewController.h"

@implementation UCOrderListTableViewCell{
    UIView *topView;//顶部视图
    UILabel *countLabel;//商品数量
    UIView *topLine;//顶部分割线
    
    UIView *middleView;//中间视图
    
    UIView *bottomView;//底部视图
    UILabel *payLabel;//实付款
    UIButton *cancelButton;//取消订单按钮
    UIButton *payButton;//去支付按钮
    UIButton *queryOrderButton;//查看订单按钮
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

-(void)initCustomCell{
    //顶部视图
    topView=[UIView new];
    [self.contentView addSubview:topView];
    
    //商品数量
    countLabel=[UILabel new];
    [topView addSubview:countLabel];
    
    //顶部分割线
    topLine=[UIView new];
    [topView addSubview:topLine];
    
    //中间视图
    middleView=[UIView new];
    [self.contentView addSubview:middleView];
    
    //底部视图
    bottomView=[UIView new];
    [self.contentView addSubview:bottomView];
    
    //实付款
    payLabel=[UILabel new];
    [bottomView addSubview:payLabel];
    
    //取消订单按钮
    cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:cancelButton];
    
    //去支付按钮
    payButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:payButton];
    
    //查看订单按钮
    queryOrderButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:queryOrderButton];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //顶部视图
    topView.frame=CGRectMake(0, 10, self.width, 38);
    topView.backgroundColor=ThemeWhite;
    
    //商品数量
    countLabel.frame=CGRectMake(15, (topView.height-16)/2, topView.width-15-15, 16);
    countLabel.font=[UIFont systemFontOfSize:14.0];
    countLabel.textColor=UIColorFromRGB(0x666666);
    
    NSArray *goodsList=[self.dic objectForKey:@"gs"];
    countLabel.text=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsList.count];
    
    //顶部分割线
    topLine.frame=CGRectMake(0, 0, topView.width, 0.5);
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    
    //中间视图
    middleView.frame=CGRectMake(0, topView.bottom, topView.width, 90);
    middleView.backgroundColor=UIColorFromRGB(0xf9f9f9);
    middleView.layer.masksToBounds=YES;
    [middleView addSubview:self.goodsList];
    
    //底部视图
    bottomView.frame=CGRectMake(0, middleView.bottom, topView.width, topView.height);
    bottomView.backgroundColor=topView.backgroundColor;
    
    //实付款
    payLabel.frame=CGRectMake(15, (bottomView.height-15)/2, 0, 15);
    payLabel.font=[UIFont systemFontOfSize:14.0];
    payLabel.textColor=UIColorFromRGB(0x666666);
    [payLabel setTextWidth:[NSString stringWithFormat:@"实付款：¥%.2f",[[self.dic objectForKey:@"totalprice"] floatValue]] size:CGSizeMake(200,15)];
    
    //去支付按钮
    payButton.frame=CGRectMake(bottomView.width-56-15, (bottomView.height-24)/2, 56, 24);
    payButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [payButton setTitleColor:ThemeRed forState:UIControlStateNormal];
    payButton.layer.masksToBounds=YES;
    payButton.layer.borderWidth=0.5;
    payButton.layer.borderColor=[ThemeRed CGColor];
    payButton.layer.cornerRadius=2;
    payButton.hidden=[[self.dic objectForKey:@"status"] integerValue]==1 ? NO : YES;
    [payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消订单按钮
    cancelButton.frame=CGRectMake(payButton.left-15-66, payButton.top, 66, payButton.height);
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [cancelButton setTitleColor:ThemeGray forState:UIControlStateNormal];
    cancelButton.layer.masksToBounds=YES;
    cancelButton.layer.borderWidth=0.5;
    cancelButton.layer.borderColor=[ThemeGray CGColor];
    cancelButton.layer.cornerRadius=2;
    cancelButton.hidden=payButton.hidden;
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //查看订单按钮
    queryOrderButton.frame=CGRectMake(bottomView.width-66-15, (bottomView.height-24)/2, 66, 24);
    queryOrderButton.titleLabel.font=[UIFont systemFontOfSize:13.0];
    [queryOrderButton setTitleColor:ThemeYellow forState:UIControlStateNormal];
    queryOrderButton.layer.masksToBounds=YES;
    queryOrderButton.layer.borderWidth=0.5;
    queryOrderButton.layer.borderColor=[ThemeYellow CGColor];
    queryOrderButton.layer.cornerRadius=2;
    queryOrderButton.hidden=!payButton.hidden;
    [queryOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [queryOrderButton addTarget:self action:@selector(queryOrderButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 按钮事件
/**
 *  去支付按钮
 *
 *  @param sender
 */
-(void)payButton:(UIButton *)sender{
    self.payOrderBlock(self.dic);
}

/**
 *  取消订单按钮
 *
 *  @param sender
 */
-(void)cancelButton:(UIButton *)sender{
    //取消订单block
    self.cancelOrderBlock([self.dic objectForKey:@"id"]);
}

/**
 *  查看订单按钮
 *
 *  @param sender
 */
-(void)queryOrderButton:(UIButton *)sender{
    self.queryOrderBlock(self.dic);
}

@end
