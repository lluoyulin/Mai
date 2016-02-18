//
//  NSString+Utils.m
//  Mai
//
//  Created by freedom on 16/1/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "NSString+Utils.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utils)

/**
 *  md5加密
 *
 *  @return 加密后的字符串
 */
-(NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 *  验证手机格式
 *
 *  @return 是或否
 */
-(BOOL)isValidPhoneNumber{
    NSString * MOBILE = @"^1\\d{10}$";
    
    NSPredicate *predicateMO = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [predicateMO evaluateWithObject:self];
}

/**
 *  验证空
 *
 *  @return 是或否
 */
-(BOOL)isEmpty{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""];
}

@end
