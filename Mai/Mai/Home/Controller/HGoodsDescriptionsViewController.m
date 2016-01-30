//
//  HGoodsDescriptionsViewController.m
//  Mai
//
//  Created by freedom on 16/1/30.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HGoodsDescriptionsViewController.h"

#import "Const.h"

@interface HGoodsDescriptionsViewController (){
    CGFloat _height;
}

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation HGoodsDescriptionsViewController

-(instancetype)initWithHeight:(CGFloat)height{
    self=[super init];
    
    if (self) {
        _height=height;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeRed;
    
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.webView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.webView.scalesPageToFit=NO;
    [self.view addSubview:self.webView];
    
    //加载商品信息
    [self.webView loadHTMLString:[self.dic objectForKey:@"miaoshu"] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
