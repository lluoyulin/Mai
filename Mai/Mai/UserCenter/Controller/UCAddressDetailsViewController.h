//
//  UCAddressDetailsViewController.h
//  Mai
//
//  Created by freedom on 16/2/16.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "BaseViewController.h"

@interface UCAddressDetailsViewController : BaseViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSDictionary *dic;//地址信息

@end
