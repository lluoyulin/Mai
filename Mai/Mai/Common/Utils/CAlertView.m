//
//  CAlertView.m
//  freedom
//
//  Created by freedom on 15/12/4.
//  Copyright © 2015年 freedom_luo. All rights reserved.
//

#import "CAlertView.h"

@implementation CAlertView

+(void)alertTarget:(id)target message:(NSString *)message handler:(void(^)(void))handler{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    
    [target presentViewController:alert animated:YES completion:nil];
}

+(void)alertMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alert show];
}

@end
