//
//  BackViewTransition.m
//  WirelessOrder
//
//  Created by eteng on 15/2/26.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "BackViewTransition.h"

@interface BackViewTransition ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL shouldComplete;

@end

@implementation BackViewTransition

-(void)wireToViewController:(UIViewController *)viewController
{
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.delegate=self;
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1-self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interacting = YES;
            [self.delegate popSwipeBackControllerNavigation];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = translation.x / [UIScreen mainScreen].bounds.size.width;
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.3);
            
            [self.delegate moveTabBar:fraction moveState:1];
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.interacting = NO;
            if (!self.shouldComplete) {
                [self.delegate moveTabBar:0 moveState:2];
                
                [self cancelInteractiveTransition];
            } else {
                [self.delegate moveTabBar:0 moveState:3];
                
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 输出点击的view的类名
//    NSLog(@"所点击view的类名：%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

@end
