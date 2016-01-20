//
//  UILabel+AutoFrame.h
//  Mai
//
//  Created by freedom on 16/1/20.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AutoFrame)

/**
 *  动态改变文本的高度
 *
 *  @param text 文本
 *  @param size 文本最大size
 */
-(void)setTextHeight:(NSString *)text size:(CGSize)size;

/**
 *  动态改变文本的宽度
 *
 *  @param text 文本
 *  @param size 文本最大size
 */
-(void)setTextWidth:(NSString *)text size:(CGSize)size;

/**
 *  动态改变文本的宽高
 *
 *  @param text 文本
 *  @param size 文本最大size
 */
-(void)setText:(NSString *)text size:(CGSize)size;

@end
