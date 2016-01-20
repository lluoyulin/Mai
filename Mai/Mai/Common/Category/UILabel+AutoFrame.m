//
//  UILabel+AutoFrame.m
//  Mai
//
//  Created by freedom on 16/1/20.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UILabel+AutoFrame.h"

@implementation UILabel (AutoFrame)

/**
 *  动态改变文本的高度
 *
 *  @param text 文本
 *  @param size 文本最大size
 */
-(void)setTextHeight:(NSString *)text size:(CGSize)size{
    self.text=text;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self CalculationSize:size].height);
}

/**
 *  动态改变文本的宽度
 *
 *  @param text 文本
 *  @param size 文本最大size
 */
-(void)setTextWidth:(NSString *)text size:(CGSize)size{
    self.text=text;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, [self CalculationSize:size].width, self.frame.size.height);
}

/**
 *  动态改变文本的宽高
 *
 *  @param text 文本
 *  @param size 文本最大size
 */
-(void)setText:(NSString *)text size:(CGSize)size{
    self.text=text;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, [self CalculationSize:size].width, [self CalculationSize:size].height);
}

/**
 *  动态计算文本size
 *
 *  @param size 文本最大的size
 *
 *  @return 最合适的size
 */
-(CGSize)CalculationSize:(CGSize)size{
    //自动调整高度
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    
    CGSize lblFontSize=[self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return lblFontSize;
}

@end
