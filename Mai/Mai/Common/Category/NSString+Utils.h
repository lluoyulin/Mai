//
//  NSString+Utils.h
//  Mai
//
//  Created by freedom on 16/1/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 *  md5加密
 *
 *  @return 加密后的字符串
 */
-(NSString *)md5;

/**
 *  验证手机格式
 *
 *  @return 是或否
 */
-(BOOL)isValidPhoneNumber;

/**
 *  是否为空
 *
 *  @return 是或否
 */
-(BOOL)isEmpty;

@end
