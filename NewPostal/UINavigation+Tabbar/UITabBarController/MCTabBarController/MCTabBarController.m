//
//  MCTabBarController.m
//  MCTabBarController
//
//  Created by caohouhong on 2018/12/7.
//  Copyright © 2018年 caohouhong. All rights reserved.
//  github:https://github.com/Ccalary/MCTabBarController

#import "MCTabBarController.h"
#import "DetailInfoViewController.h"
#import "CRNavigationController.h"
#import "ScanViewController.h"
#import "ScanCQRViewController.h"
#import "SiteViewController.h"

@interface MCTabBarController ()<UITabBarControllerDelegate>
@end

@implementation MCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mcTabbar = [[MCTabBar alloc] init];
    [_mcTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_mcTabbar forKeyPath:@"tabBar"];
    self.delegate = self;
    self.selectIndex=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    //    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    //    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}


// 重写选中事件， 处理中间按钮选中问题
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    _mcTabbar.centerBtn.selected = (tabBarController.selectedIndex == self.viewControllers.count/2);
//    NSLog(@"bool ===  %d",(tabBarController.selectedIndex == self.viewControllers.count/2));
    
    
    if (tabBarController.selectedIndex == 2)
    {
    }
    if(self.selectIndex==3)
    {
//        ScanViewController * vc =[[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
//        vc.hidesBottomBarWhenPushed = YES;
//        self.definesPresentationContext = YES;
//        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;//关键语句，必须有 ios8 later
//        // 动画关闭 不然会有个半透明背景跟着动画 很丑..
//        [self presentViewController:vc animated:NO completion:^{
//            // 根据 colorWithAlphaComponent:设置透明度，如果直接使用alpha属性设置，会出现Vc里面的子视图也透明.
//            vc.view.backgroundColor = [[UIColor colorWithRed:111/255.0 green:113/255.0 blue:121/255.0 alpha:1] colorWithAlphaComponent:0.98];
//            self.selectIndex = 0;
//        }];
//        ScanCQRViewController * vc =[[ScanCQRViewController alloc]init];
        
    }
    if (self.mcDelegate){
        [self.mcDelegate mcTabBarController:tabBarController didSelectViewController:viewController];
    }
}

- (void)buttonAction:(UIButton *)button{
    NSInteger count = self.viewControllers.count;
    self.selectedIndex = count/2;//关联中间按钮
    [self tabBarController:self didSelectViewController:self.viewControllers[self.selectedIndex]];
    
//    self.selectIndex=3;
//    [self tabBarController:self didSelectViewController:self.viewControllers[0]];
}
@end
