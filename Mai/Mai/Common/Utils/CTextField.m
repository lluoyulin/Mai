//
//  CTextField.m
//  Mai
//
//  Created by freedom on 16/2/18.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "CTextField.h"

@implementation CTextField

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    return self.leftView.frame;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    return self.rightView.frame;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect=[super textRectForBounds:bounds];
    rect.origin.x+=10;
    
    if (self.leftView) {
        rect.size.width-=10;
    }
    
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect=[super textRectForBounds:bounds];
    rect.origin.x+=10;
    
    if (self.leftView) {
        rect.size.width-=10;
    }
    
    return rect;
}

@end
