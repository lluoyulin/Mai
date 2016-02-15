//
//  CKeyboardToolBar.m
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "CKeyboardToolBar.h"

#import "Const.h"

@implementation CKeyboardToolBar

-(instancetype)init{
    self=[super init];
    
    if (self) {
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, 30);
        [self setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        [self setItems:buttonsArray];
    }
    
    return self;
}

-(void)resignKeyboard
{
    self.resignKeyboardBlock();
}

@end
