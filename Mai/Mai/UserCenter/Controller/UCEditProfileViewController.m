//
//  UCEditProfileViewController.m
//  Mai
//
//  Created by freedom on 16/2/21.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "UCEditProfileViewController.h"

#import "Const.h"
#import "UILabel+AutoFrame.h"
#import "NSObject+Utils.h"
#import "NSObject+HttpTask.h"
#import "CAlertView.h"

#import "UCEditProfileTableViewCell.h"
#import "UCEditViewController.h"

#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface UCEditProfileViewController (){
    NSMutableArray *_list;
}

@property(nonatomic,strong) UIButton *navigationSaveButton;//保存按钮

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *tableHeaderView;//表格头部视图
@property(nonatomic,strong) UIButton *headButton;//头像按钮
@property(nonatomic,strong) UILabel *headTagLabel;//头像标签
@property(nonatomic,strong) UIImageView *headImage;//头像
@property(nonatomic,strong) UIImageView *headButtonFlag;//头像按钮标志

@property(nonatomic,strong) UIImagePickerController *pickerImage;
@property (nonatomic) NSData *avatarData;//用户头像数据

@end

@implementation UCEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改资料";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    //注册用户资料保存成功发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editProfile:) name:@"edit_profile" object:nil];
    
    //初始化导航栏
    [self initNavigationBar];
    
    //初始化数据
    [self initData];

    //初始化表格
    [self initTableView];
    
    //初始化表格头部视图
    [self initTableHeaderView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark 初始化视图
/**
 *  初始化表格
 */
-(void)initTableView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

/**
 *  初始化表格头部视图
 */
-(void)initTableHeaderView{
    //表格头部视图
    self.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 107)];
    self.tableHeaderView.backgroundColor=self.tableView.backgroundColor;
    self.tableView.tableHeaderView=self.tableHeaderView;
    
    //头像按钮
    self.headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.headButton.frame=CGRectMake(0, 15, self.tableHeaderView.width, 77);
    self.headButton.backgroundColor=ThemeWhite;
    [self.headButton addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeaderView addSubview:self.headButton];
    
    //顶部分割线
    UIView *topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headButton.width, 0.5)];
    topLine.backgroundColor=UIColorFromRGB(0xdddddd);
    [self.headButton addSubview:topLine];
    
    //底部分割线
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.headButton.height-0.5, topLine.width, topLine.height)];
    bottomLine.backgroundColor=topLine.backgroundColor;
    [self.headButton addSubview:bottomLine];
    
    //头像标签
    self.headTagLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, (self.headButton.height-16)/2, 0, 16)];
    self.headTagLabel.font=[UIFont systemFontOfSize:14.0];
    self.headTagLabel.textColor=ThemeGray;
    [self.headTagLabel setTextWidth:@"头像" size:CGSizeMake(100, 16)];
    [self.headButton addSubview:self.headTagLabel];
    
    //头像按钮标志
    self.headButtonFlag=[[UIImageView alloc] initWithFrame:CGRectMake(self.headButton.width-16-15, (self.headButton.height-16)/2, 16, 16)];
    self.headButtonFlag.image=[UIImage imageNamed:@"order_address_arrow"];
    [self.headButton addSubview:self.headButtonFlag];
    
    //头像
    self.headImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.headButtonFlag.left-15-56, (self.headButton.height-56)/2, 56, 56)];
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=self.headImage.width/2;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.userHead] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [self.headButton addSubview:self.headImage];
    
    //头部视图分割线
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.tableHeaderView.height-0.5, self.tableHeaderView.width, 0.5)];
    line.backgroundColor=UIColorFromRGB(0xcdcdcd);
    [self.tableHeaderView addSubview:line];
}

/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    //导航栏删除按钮
    self.navigationSaveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationSaveButton.frame=CGRectMake(0, 0, 44, 44);
    [self.navigationSaveButton setTitleColor:ThemeBlack forState:UIControlStateNormal];
    [self.navigationSaveButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.navigationSaveButton addTarget:self action:@selector(navigationSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:self.navigationSaveButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
}

#pragma mark 自定义方法
/**
 *  初始化数据
 */
-(void)initData{
    _list=[[NSMutableArray alloc] init];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.nickName,@"tag":@"昵称"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.sex,@"tag":@"性别"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.mail,@"tag":@"邮箱"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.province,@"tag":@"省份"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.city,@"tag":@"城市"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.area,@"tag":@"区"}]];
    [_list addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"text":self.address,@"tag":@"地址"}]];
}

/**
 *  保存数据
 */
-(void)saveData{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType=MBProgressHUDAnimationZoom;
    hud.labelText=@"提交中...";
    
    //构造参数
    NSString *url=@"user_edit";
    NSDictionary *parameters=@{@"token":Token,
                               @"uid":[self getUid],
                               @"isLogin":[self isLogin] ? @"1" : @"0",
                               @"nickname":[_list[0] objectForKey:@"text"],
                               @"mail":[_list[2] objectForKey:@"text"],
                               @"sex":[_list[1] objectForKey:@"text"],
                               @"province":[_list[3] objectForKey:@"text"],
                               @"city":[_list[4] objectForKey:@"text"],
                               @"area":[_list[5] objectForKey:@"text"],
                               @"address":[_list[6] objectForKey:@"text"],
                               @"img":self.avatarData.length==0 ? @"" : CDBase64EncodedForData(self.avatarData)};
    
    [self post:url parameters:parameters cache:NO success:^(BOOL isSuccess, id result, NSString *error) {
        
        if (isSuccess) {
            NSDictionary *dic=(NSDictionary *)result;
            
            hud.mode=MBProgressHUDModeText;
            hud.labelText=@"提交成功";
            
            //缓存用户信息
            self.nickName=[[dic objectForKey:@"uid"] objectForKey:@"nickname"];
            self.sex=[[dic objectForKey:@"uid"] objectForKey:@"sex"];
            self.mail=[[dic objectForKey:@"uid"] objectForKey:@"mail"];
            self.province=[[dic objectForKey:@"uid"] objectForKey:@"province"];
            self.city=[[dic objectForKey:@"uid"] objectForKey:@"city"];
            self.area=[[dic objectForKey:@"uid"] objectForKey:@"area"];
            self.address=[[dic objectForKey:@"uid"] objectForKey:@"address"];
            self.userHead=[[dic objectForKey:@"uid"] objectForKey:@"headimg"];
            
            //延迟1.5s执行方法
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
        }
        else{
            [hud hide:YES];
            
            [CAlertView alertMessage:error];
        }
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];
        
        [CAlertView alertMessage:NetErrorMessage];
        
    }];
}

/**
 *  返回上层
 */
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 按钮事件
/**
 *  头像按钮
 *
 *  @param sender
 */
-(void)headButton:(UIButton *)sender{
    /*注：使用，需要实现以下协议：UIImagePickerControllerDelegate,
     UINavigationControllerDelegate
     */
    if (self.pickerImage==nil) {
        self.pickerImage = [[UIImagePickerController alloc]init];
        //设置代理
        self.pickerImage.delegate = self;
        //设置可以编辑
        self.pickerImage.allowsEditing = YES;
    }
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //设置图片源
        self.pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        //打开拾取器界面
        [self presentViewController:self.pickerImage animated:YES completion:nil];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //设置图片源
        self.pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //打开拾取器界面
        [self presentViewController:self.pickerImage animated:YES completion:nil];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  保存按钮
 *
 *  @param sender
 */
-(void)navigationSaveButton:(UIButton *)sender{
    //获取压缩数据
    self.avatarData = UIImageJPEGRepresentation(self.headImage.image, 0.2);
    
    //保存数据
    [self saveData];
}

#pragma mark 通知
/**
 *  用户资料保存成功发送通知
 *
 *  @param notification
 */
-(void)editProfile:(NSNotification *)notification{
    for (NSMutableDictionary *dic in _list) {
        if ([[dic objectForKey:@"tag"] isEqualToString:[notification.userInfo objectForKey:@"tag"]]) {
            [dic setObject:[notification.userInfo objectForKey:@"text"] forKey:@"text"];
            
            [self.tableView reloadData];
            
            break;
        }
    }
}

#pragma mark 表格数据源委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    UCEditProfileTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if (cell==nil) {
        cell=[[UCEditProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.dic=_list[indexPath.row];
    cell.last=indexPath.row==_list.count-1 ? YES : NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark tableView动作委托
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCEditViewController *vc=[UCEditViewController new];
    vc.title=[_list[indexPath.row] objectForKey:@"tag"];
    vc.dic=_list[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UIImagePickerControllerDelegate methods
//完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取编辑以后的图片
    UIImage *photo = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //获取压缩数据
    self.avatarData = UIImageJPEGRepresentation(photo, 0.2);
    
    //加载图片
    self.headImage.image=photo;
    
    //选择框消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

static NSString * CDBase64EncodedForData(NSData *data) {
    if (data == nil) {
        return nil;
    }
    
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
