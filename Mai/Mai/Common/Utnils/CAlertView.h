//
//  CAlertView.h
//  freedom
//
//  Created by freedom on 15/12/4.
//  Copyright © 2015年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAlertView : UIView

+(void)alertTarget:(id)target message:(NSString *)message handler:(void(^)(void))handler;

@end
