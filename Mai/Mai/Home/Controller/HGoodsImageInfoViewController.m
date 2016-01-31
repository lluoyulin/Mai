//
//  HGoodsImageInfoViewController.m
//  Mai
//
//  Created by freedom on 16/1/30.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "HGoodsImageInfoViewController.h"

#import "Const.h"

@interface HGoodsImageInfoViewController ()<UIScrollViewDelegate>{
    CGFloat _height;
    BOOL _isChangeContentOffset;//是否改变滚动坐标
    BOOL _isSetContentOffset;//是否设置滚动坐标
}

@property(nonatomic,strong) UIWebView *webView;


@end

@implementation HGoodsImageInfoViewController

-(instancetype)initWithHeight:(CGFloat)height{
    self=[super init];
    
    if (self) {
        _height=height;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=ThemeWhite;
    
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.webView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.webView.scalesPageToFit=NO;
    self.webView.scrollView.delegate=self;
    [self.view addSubview:self.webView];
    
    //加载商品图文信息
    [self.webView loadHTMLString:[self.dic objectForKey:@"tuwen"] baseURL:nil];
}

#pragma mark 当scrollView正在滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>0 && _isChangeContentOffset) {
        [self.delegate changeGoodsImageInfoScrollViewContentOffset:scrollView.contentOffset.y];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isChangeContentOffset=YES;
    _isSetContentOffset=YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_isSetContentOffset) {
        _isChangeContentOffset=NO;
        _isSetContentOffset=NO;
        
        [self.delegate setGoodsImageInfoScrollViewContentOffset:scrollView.contentOffset.y];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
