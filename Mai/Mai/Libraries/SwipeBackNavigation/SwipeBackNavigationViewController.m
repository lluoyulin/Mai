//
//  SwipeBackNavigationViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/2/26.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "SwipeBackNavigationViewController.h"
#import "PushViewAnimation.h"
#import "BackViewTransition.h"
#import "BackViewAnimation.h"

#import "UCOrderListViewController.h"

@interface SwipeBackNavigationViewController (){
    NSArray *_disablePanGestureInViewControllerClassList;//不添加返回手势的VC集合
}

@property(nonatomic,strong) PushViewAnimation *pushAnimation;
@property(nonatomic,strong) BackViewTransition *interactionController;
@property(nonatomic,strong) BackViewAnimation *backAnimation;
@property(nonatomic,strong) UIView *tarBar;

@end

@implementation SwipeBackNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate=self;
    self.pushAnimation=[PushViewAnimation new];
    self.interactionController=[BackViewTransition new];
    self.backAnimation=[BackViewAnimation new];
    self.interactionController.delegate=self;
    
    //不添加返回手势的VC集合
    _disablePanGestureInViewControllerClassList=@[@"SCShoppingCartViewController",@"UCUserAddressViewController"];
}

//重写push
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count==1) {
        self.tarBar =(UIView *)[self.tabBarController.view viewWithTag:99];
        self.tarBar.hidden=YES;
    }
    
    if (![_disablePanGestureInViewControllerClassList containsObject:NSStringFromClass([viewController class])]) {
        //添加VC返回手势
//        [self.interactionController wireToViewController:viewController];
    }
    
    [super pushViewController:viewController animated:animated];
}

//重写pop
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.viewControllers.count==2) {
        self.tarBar.alpha=1;
        self.tarBar.hidden=NO;
    }
    
//    if ([[[self.viewControllers lastObject] class] isSubclassOfClass:[UCOrderListViewController class]]) {
//        
//        UCOrderListViewController *vc=[self.viewControllers lastObject];
//        if ([vc.flag isEqualToString:@"pay_success"]) {
//            [self popToRootViewControllerAnimated:YES];
//        }
//    }
    
    return [super popViewControllerAnimated:animated];
}

//重写popToRoot
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    self.tarBar.alpha=1;
    self.tarBar.hidden=NO;
    
    return [super popToRootViewControllerAnimated:animated];
}

#pragma BackViewTransition 委托
-(void)popSwipeBackControllerNavigation{
    [self popViewControllerAnimated:YES];
}

-(void)moveTabBar:(CGFloat)translation moveState:(int)state{
    switch (state) {
        case 1:
            self.tarBar.alpha=translation;
            break;
        case 2:
            self.tarBar.alpha=0;
            self.tarBar.hidden=YES;
            break;
        case 3:
            self.tarBar.alpha=1;
            break;
    }
}

#pragma UINavigationControllerDelegate 委托
//动画
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else if(operation == UINavigationControllerOperationPop){
        return self.backAnimation;
    }else{
        return nil;
    }
}

//交互
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    if (self.interactionController.interacting) {
        self.tarBar.alpha=0;
        return self.interactionController;
    }
    else{
        return nil;
    }
}

@end
