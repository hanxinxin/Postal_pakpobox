//
//  LoginNextViewController.h
//  NewPostal
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginNextViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;

@property (strong, nonatomic) IBOutlet HQTextField *NameField;
@property (strong, nonatomic) IBOutlet HQTextField *PasswordField;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;
@property (assign, nonatomic) NSInteger logInt;  ///// 判断是投递人员还是取件人员  1:投递人员 2:取件人员


@property(nonatomic, strong)BarViewController *VC;
@end

NS_ASSUME_NONNULL_END
