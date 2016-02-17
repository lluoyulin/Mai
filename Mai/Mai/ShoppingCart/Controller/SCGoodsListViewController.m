//
//  SCGoodsListViewController.m
//  Mai
//
//  Created by freedom on 16/2/15.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "SCGoodsListViewController.h"

#import "Const.h"

#import "UIImageView+WebCache.h"

@interface SCGoodsListViewController ()

@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation SCGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor=ThemeWhite;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionView数据委托
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _goodsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    if ([cell.contentView subviews].count==0) {
        //商品图片
        UIImageView *logoImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        logoImage.tag=1;
        logoImage.layer.masksToBounds=YES;
        logoImage.layer.borderWidth=0.5;
        logoImage.layer.borderColor=[UIColorFromRGB(0xdddddd) CGColor];
        logoImage.layer.cornerRadius=3;
        [cell.contentView addSubview:logoImage];
        
        //商品数量
        UILabel *countLabel=[[UILabel alloc] initWithFrame:CGRectMake(logoImage.width-7, -7, 14, 14)];
        countLabel.tag=2;
        countLabel.backgroundColor=ThemeRed;
        countLabel.font=[UIFont systemFontOfSize:10.0];
        countLabel.textColor=ThemeWhite;
        countLabel.textAlignment=NSTextAlignmentCenter;
        countLabel.layer.masksToBounds=YES;
        countLabel.layer.cornerRadius=countLabel.width/2;
        [cell.contentView addSubview:countLabel];
        
        //商品价格
        UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, logoImage.height-16, logoImage.width, 16)];
        priceLabel.tag=3;
        priceLabel.alpha=0.64;
        priceLabel.backgroundColor=ThemeBlack;
        priceLabel.font=[UIFont systemFontOfSize:11.0];
        priceLabel.textColor=ThemeWhite;
        priceLabel.textAlignment=NSTextAlignmentCenter;
        [logoImage addSubview:priceLabel];
    }
    
    //商品图片
    UIImageView *logoImage=(UIImageView *)[cell viewWithTag:1];
    [logoImage sd_setImageWithURL:[NSURL URLWithString:[[_goodsList[indexPath.row] objectForKey:@"gs"] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    //商品数量
    UILabel *countLabel=(UILabel *)[cell viewWithTag:2];
    countLabel.text=[UserData objectForKey:[NSString stringWithFormat:@"sid_%@",[_goodsList[indexPath.row] objectForKey:@"sid"]]];
    
    //商品价格
    UILabel *priceLabel=(UILabel *)[logoImage viewWithTag:3];
    priceLabel.text=[NSString stringWithFormat:@"¥%@",[[_goodsList[indexPath.row] objectForKey:@"gs"] objectForKey:@"price2"]];
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
//定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0;
}

#pragma mark UICollectionView 动作委托
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
