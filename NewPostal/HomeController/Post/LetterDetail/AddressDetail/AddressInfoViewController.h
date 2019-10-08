//
//  AddressInfoViewController.h
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AddressInfoViewControllerDelegate <NSObject>
-(void)returnAddressStr:(AddressListMode * )AddressStr tagS:(NSInteger)Tag;
@end
@interface AddressInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIButton *AddNewBtn;
@property (assign, nonatomic) NSInteger tagS;
@property (nonatomic, strong) AddressInfoMode * addressMode; ////寄件人 信息
@property (nonatomic, strong) AddressListMode * ListMode; ////寄件人 信息
// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<AddressInfoViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
