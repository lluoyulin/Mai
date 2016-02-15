//
//  CKeyboardToolBar.h
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKeyboardToolBar : UIToolbar

@property(nonatomic,copy) void(^resignKeyboardBlock)(void);

@end
