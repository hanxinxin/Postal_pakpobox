//
//  AddressDetailViewController.h
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIButton *AddNewBtn;
@property (nonatomic, strong) NSMutableArray * arrListTitle;
@property (nonatomic, strong) NSString * ModeType; //// 类型
@property (nonatomic, assign) NSInteger GXFlag; //// 是新建还是修改  1:修改 0:新建 2:修改已下单的地址
@property (nonatomic, strong) AddressInfoMode * addressMode; ////寄件人 信息
@property (nonatomic, strong) AddressListMode * ListMode; ////传入 要修改的 信息

@property (nonatomic, strong) NSString * ordersAddressIdSSS; //// 寄件信息修改的 orderID
@end

NS_ASSUME_NONNULL_END
