//
//  CWebViewController.m
//  DongJing
//
//  Created by freedom on 16/4/14.
//  Copyright © 2016年 李红(lh.coder@foxmail.com). All rights reserved.
//

#import "CWebViewController.h"

#import "Const.h"
#import "UIView+Frame.h"
#import "UILabel+AutoFrame.h"

#import "NJKWebViewProgressView.h"

@interface CWebViewController ()

@property(nonatomic,strong) UIView *navigationBarView;//导航栏
@property(nonatomic,strong) UILabel *titleLabel;//标题
@property(nonatomic,strong) UIButton *backBarButton;//返回按钮
@property(nonatomic,strong) UIButton *closeBarButton;//关闭按钮
@property(nonatomic,strong) UIButton *reloadBarButton;//刷新按钮
@property(nonatomic,strong) NSString *navigationBarTitle;//标题字符串
@property(nonatomic,strong) UIView *bottomLine;//分割线

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) NJKWebViewProgressView *progressView;
@property(nonatomic,strong) NJKWebViewProgress *progressProxy;

@end

@implementation CWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化WebView
    [self initWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationBarView addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.progressView removeFromSuperview];
}

#pragma mark 初始化视图
/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏
    self.navigationBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT)];
    self.navigationBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.navigationBarView];
    
    //左边按钮
    self.backBarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.backBarButton.frame=CGRectMake(0, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-44)/2, 44, 44);
    [self.backBarButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:self.backBarButton];
    
    //标题
    self.titleLabel=[UILabel new];
    self.titleLabel.font=[UIFont systemFontOfSize:18.0];
    self.titleLabel.textColor=UIColorFromRGB(0x292f33);
    [self.navigationBarView addSubview:self.titleLabel];
    
    //分割线
    self.bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.height-0.5, self.navigationBarView.width, 0.5)];
    self.bottomLine.backgroundColor=UIColorFromRGB(0xaab8c2);
    [self.navigationBarView addSubview:self.bottomLine];
    
    //刷新按钮
    self.reloadBarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadBarButton.frame=CGRectMake(SCREEN_WIDTH-44, self.backBarButton.top, self.backBarButton.width, self.backBarButton.height);
    [self.reloadBarButton setImage:[UIImage imageNamed:@"navigation_refresh"] forState:UIControlStateNormal];
    [self.reloadBarButton addTarget:self action:@selector(reloadBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:self.reloadBarButton];
    
    //关闭按钮
    self.closeBarButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBarButton.frame=CGRectMake(self.reloadBarButton.left-44, self.backBarButton.top, self.backBarButton.width, self.backBarButton.height);
    [self.closeBarButton setImage:[UIImage imageNamed:@"navigation_close"] forState:UIControlStateNormal];
    [self.closeBarButton addTarget:self action:@selector(closeBarButton:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBarButton.hidden=YES;
    [self.navigationBarView addSubview:self.closeBarButton];
}

/**
 *  初始化WebView
 */
-(void)initWebView{
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.webView.backgroundColor=UIColorFromRGB(0xf0f2f5);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:self.webView];
    
    self.progressProxy=[[NJKWebViewProgress alloc] init];
    self.progressProxy.webViewProxyDelegate=self;
    self.progressProxy.progressDelegate=self;
    self.webView.delegate=self.progressProxy;
    
    self.progressView=[[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.height-2, self.navigationBarView.width, 2)];
    self.progressView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark 属性设置
-(NSString *)navigationBarTitle{
    return self.titleLabel.text;
}

-(void)setNavigationBarTitle:(NSString *)navigationBarTitle{
    [self.titleLabel setTextWidth:navigationBarTitle size:CGSizeMake(self.navigationBarView.width-self.backBarButton.width*(self.closeBarButton.isHidden ? 2 : 3), 20)];
    
    self.titleLabel.frame=CGRectMake(self.backBarButton.right+(self.navigationBarView.width-self.backBarButton.width*(self.closeBarButton.isHidden ? 2 : 3)-self.titleLabel.width)/2, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-20)/2,self.titleLabel.width, 20);
}

#pragma mark 重新系统方法
/**
 *  状态栏样式
 *
 *  @return 状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark 按钮事件
/**
 *  返回按钮
 *
 *  @param sender
 */
-(void)backBarButton:(UIButton *)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 *  关闭按钮
 *
 *  @param sender
 */
-(void)closeBarButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  刷新按钮
 *
 *  @param sender
 */
-(void)reloadBarButton:(UIButton *)sender{
    [self.webView reload];
}

#pragma mark NJKWebViewProgress委托
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [self.progressView setProgress:progress animated:YES];
    
    if (self.webView.canGoBack) {
        self.closeBarButton.hidden=NO;
    }
    else{
        self.closeBarButton.hidden=YES;
    }
    
    self.navigationBarTitle=[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark webView委托
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
