//
//  NSObject+DataConvert.m
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "NSObject+DataConvert.h"

@implementation NSObject (DataConvert)

/**
 *  数组转化成JSon字符串
 *
 *  @param arry 数组
 *
 *  @return JSon字符串
 */
-(NSString *)toJSonWithNSArrayOrNSDictionary:(id)data{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

/**
 *  JSon字符串转化成数组或字典
 *
 *  @param json JSon字符串
 *
 *  @return 数组或字典
 */
-(id)toNSArryOrNSDictionaryWithJSon:(NSString *)json{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        return nil;
    }
}

@end
