//
//  ComDetailInfoViewController.h
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComDetailInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic, strong) NSArray * arrListTitle;
@property (nonatomic, strong) NSArray * HeaderArr;
@property (nonatomic, strong) DetaInfoMode * modeDD;
@property (nonatomic, strong) AddressInfoMode * senderAddress;
@property (nonatomic, strong) AddressInfoMode * receiverAddress;
@property (nonatomic,strong) NSString * orderIDStr;

@property (nonatomic,assign) NSInteger returnfalg;   //// 1:标志返回首页 0:标志普通返回


@end

NS_ASSUME_NONNULL_END
