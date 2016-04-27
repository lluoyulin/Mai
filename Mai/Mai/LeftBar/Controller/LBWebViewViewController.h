//
//  LBWebViewViewController.h
//  Mai
//
//  Created by freedom on 16/2/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NJKWebViewProgress.h"

@interface LBWebViewViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

/**
 *  加载网页地址
 */
@property(nonatomic,strong) NSString *url;

@end
