//
//  CWebViewController.h
//  DongJing
//
//  Created by freedom on 16/4/14.
//  Copyright © 2016年 李红(lh.coder@foxmail.com). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NJKWebViewProgress.h"

@interface CWebViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

/**
 *  加载网页地址
 */
@property(nonatomic,strong) NSString *url;

@end
