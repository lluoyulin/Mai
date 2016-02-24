//
//  LBWebViewViewController.m
//  Mai
//
//  Created by freedom on 16/2/23.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "LBWebViewViewController.h"

#import "Const.h"

#import "NJKWebViewProgressView.h"

@interface LBWebViewViewController ()

@property(nonatomic,strong) UIWebView *webView;

@property(nonatomic,strong) NJKWebViewProgressView *progressView;
@property(nonatomic,strong) NJKWebViewProgress *progressProxy;

@end

@implementation LBWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    self.showMenu=YES;
    
    //初始化WebView
    [self initWebView];
    
    //初始化进度条
    [self initWebViewProgress];
    
    //加载url地址
    [self loadUrl];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
}

#pragma mark 初始化视图
/**
 *  初始化WebView
 */
-(void)initWebView{
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.webView.scalesPageToFit=NO;
    self.webView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.webView];
}

/**
 *  初始化进度条
 */
-(void)initWebViewProgress{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark 自定义方法
/**
 *  加载url地址
 */
-(void)loadUrl{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://chulai-mai.com"]];
    [self.webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
