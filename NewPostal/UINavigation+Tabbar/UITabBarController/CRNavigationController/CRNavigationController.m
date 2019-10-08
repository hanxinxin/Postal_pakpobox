//
//  CRNavigationController.m
//  CRNavigationControllerExample
//
//  Created by Corey Roberts on 9/24/13.
//  Copyright (c) 2013 SpacePyro Inc. All rights reserved.
//

#import "CRNavigationController.h"
#import "CRNavigationBar.h"

@interface CRNavigationController ()<UINavigationControllerDelegate>

@end

@implementation CRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//   [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleLightContent;
    
}
- (id)init {
    self = [super initWithNavigationBarClass:[CRNavigationBar class] toolbarClass:nil];
    if(self) {
        // Custom initialization here, if needed.
    }
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[CRNavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
    }
    
    return self;
}
//
////
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    
//    // 去掉系统backBarButtonItem的默认显示效果
//    // 这个效果由控制器控制(A push B 则在A中设置)
//    /***
//     1、如果B视图有一个自定义的左侧按钮（leftBarButtonItem），则会显示这个自定义按钮；
//     
//     2、如果B没有自定义按钮，但是A视图的backBarButtonItem属性有自定义项，则显示这个自定义项；
//     
//     3、如果前2条都没有，则默认显示一个后退按钮，后退按钮的标题是A视图的标题。
//     */
////    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
////    viewController.navigationItem.backBarButtonItem = item;
//    
//    [super pushViewController:viewController animated:animated];
//}


@end
