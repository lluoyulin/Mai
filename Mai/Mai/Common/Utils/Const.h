//
//  Const.h
//  freedom
//
//  Created by freedom on 16/1/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UIView+Frame.h"

#ifndef Const_h
#define Const_h

#define TAB_BAR_HEIGHT 49.0
#define STATUS_BAR_HEIGHT 20.0
#define NAVIGATION_BAR_HEIGHT 44.0

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define COLOUR_FROM_HEX(hex) [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0 green:((hex >> 8) & 0xFF)/255.0 blue:(hex & 0xFF)/255.0 alpha:1.0]

//颜色值转换
#define UIColorFromRGB(rgbValue) COLOUR_FROM_HEX(rgbValue)

//接口地址
#define HttpUrl @"http://chulai-mai.com/index.php?m=Home&c=App&a="

//用户数据
#define UserData [NSUserDefaults standardUserDefaults]

//数据库地址
#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/zhihuiguizhou.sqlite"]

//判断是否为空
#define CheckNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

/**
 *  获取UDID
 */
#define UUID [[UIDevice currentDevice] identifierForVendor].UUIDString

/**
 *  网络错误
 */
#define NetErrorMessage @"网络故障"

/**
 *  白色
 */
#define ThemeWhite [UIColor whiteColor]

/**
 *  黄色
 */
#define ThemeYellow UIColorFromRGB(0xffd943)

/**
 *  黑色
 */
#define ThemeBlack UIColorFromRGB(0x333333)

/**
 *  红色
 */
#define ThemeRed UIColorFromRGB(0xfe3425)

/**
 *  灰色
 */
#define ThemeGray UIColorFromRGB(0x999999)

#define Token @"71583E074D967903000B5618E4693918"

#endif /* Const_h */
