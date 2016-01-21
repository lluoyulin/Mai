//
//  BackViewTransition.h
//  WirelessOrder
//
//  Created by eteng on 15/2/26.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackViewTransitionDelegate <NSObject>

-(void)popSwipeBackControllerNavigation;

-(void)moveTabBar:(CGFloat) translation moveState:(int) state;

@end

@interface BackViewTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
@property(nonatomic,weak)id<BackViewTransitionDelegate>delegate;

- (void)wireToViewController:(UIViewController*)viewController;

@end
