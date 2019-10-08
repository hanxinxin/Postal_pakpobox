//
//  LoginViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginNextViewController.h"
@interface LoginViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.CustomerBtn.layer.cornerRadius = 20;
    self.PostmanBtn.layer.cornerRadius = 20;;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //通过segue判断要跳转到哪个页面
    if ([segue.identifier isEqualToString:@"Customer"]) {
            // segue.destinationViewController：获取连线时所指的界面（VC）
            LoginNextViewController *vc = segue.destinationViewController;
            vc.logInt = 2;
        
    }else if ([segue.identifier isEqualToString:@"Postman"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        LoginNextViewController *vc = segue.destinationViewController;
        vc.logInt = 1;
    }
}

- (IBAction)CustomerTouch:(id)sender {
    [self performSegueWithIdentifier:@"Customer" sender:nil];
}
- (IBAction)PostmanTouch:(id)sender {
    [self performSegueWithIdentifier:@"Postman" sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
