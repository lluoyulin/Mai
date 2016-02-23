//
//  LBWebViewViewController.m
//  Mai
//
//  Created by freedom on 16/2/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "LBWebViewViewController.h"

#import "Const.h"

@interface LBWebViewViewController ()

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation LBWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeYellow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
