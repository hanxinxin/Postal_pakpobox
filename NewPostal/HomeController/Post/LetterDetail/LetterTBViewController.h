//
//  LetterTBViewController.h
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LetterTBViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIButton *CompleteB;

@property (nonatomic, strong) NSString * ItemNumber; ////订单编号
@property (nonatomic, strong) NSString * PostType; ////post 类型
@property (nonatomic, strong) AddressInfoMode * addressSender; ////寄件人 信息
@property (nonatomic, strong) AddressInfoMode * addressReceiver; ////收件人 信息
@end

NS_ASSUME_NONNULL_END
