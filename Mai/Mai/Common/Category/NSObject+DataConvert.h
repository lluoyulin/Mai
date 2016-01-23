//
//  NSObject+DataConvert.h
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DataConvert)

/**
 *  数组或字典转化成JSon字符串
 *
 *  @param arry 数组
 *
 *  @return JSon字符串
 */
-(NSString *)toJSonWithNSArrayOrNSDictionary:(id)data;

/**
 *  JSon字符串转化成数组或字典
 *
 *  @param json JSon字符串
 *
 *  @return 数组或字典
 */
-(id)toNSArryOrNSDictionaryWithJSon:(NSString *)json;

@end
