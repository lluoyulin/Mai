//
//  UCEditProfileTableViewCell.m
//  Mai
//
//  Created by freedom on 16/2/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCEditProfileTableViewCell.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"

@implementation UCEditProfileTableViewCell{
    UILabel *tagLabel;//文本标签
    UILabel *textLabel;//文本
    UIView *line;//线
    UIImageView *buttonFlagImage;//按钮标志
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initCustomCell];
    }
    
    return self;
}

-(void)initCustomCell{
    //文本标签
    tagLabel=[UILabel new];
    [self.contentView addSubview:tagLabel];
    
    //文本
    textLabel=[UILabel new];
    [self.contentView addSubview:textLabel];
    
    //线
    line=[UIView new];
    [self.contentView addSubview:line];
    
    //按钮标志
    buttonFlagImage=[UIImageView new];
    [self.contentView addSubview:buttonFlagImage];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //文本标签
    tagLabel.frame=CGRectMake(15, (self.height-16)/2, 0, 16);
    tagLabel.font=[UIFont systemFontOfSize:14.0];
    tagLabel.textColor=ThemeGray;
    [tagLabel setTextWidth:[self.dic objectForKey:@"tag"] size:CGSizeMake(100, 16)];
    
    //按钮标志
    buttonFlagImage.frame=CGRectMake(self.width-16-15, (self.height-16)/2, 16, 16);
    buttonFlagImage.image=[UIImage imageNamed:@"order_address_arrow"];
    
    //文本
    textLabel.font=[UIFont systemFontOfSize:14.0];
    textLabel.textColor=ThemeBlack;
    
    NSString *text=@"";
    if ([tagLabel.text isEqualToString:@"性别"]) {
        if (![[self.dic objectForKey:@"text"] isEqualToString:@""]) {
            text=[[self.dic objectForKey:@"text"] integerValue]==1 ? @"男" : @"女";
        }
    }
    else{
        text=[self.dic objectForKey:@"text"];
    }
    [textLabel setTextWidth:text size:CGSizeMake(200, 16)];
    textLabel.frame=CGRectMake(buttonFlagImage.left-15-textLabel.width, (self.height-16)/2, textLabel.width, 16);
    
    //线
    line.frame=CGRectMake(self.isLast ? 0 : tagLabel.left, self.height-0.5, self.width-(self.isLast ? 0 : 15+15), 0.5);
    line.backgroundColor=UIColorFromRGB(0xcdcdcd);
}

@end
