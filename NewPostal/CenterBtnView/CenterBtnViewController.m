//
//  CenterBtnViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CenterBtnViewController.h"
#import "WCQRCodeScanningVC.h"
#import "ScanCQRViewController.h"
@interface CenterBtnViewController ()

@end

@implementation CenterBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
//    WCQRCodeScanningVC * vc = [[WCQRCodeScanningVC alloc] init];
//    vc.tag_int = 1;
//    [self presentViewController:vc animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backItem;
    NSLog(@"Push");
    ScanCQRViewController *ViewC=[[ScanCQRViewController alloc] init];
    [self whenPush:ViewC];
    [super viewWillAppear:animated];
}

- (void)whenPush:(UIViewController*)ViewC{
//    CATransition* transition = [CATransition animation];
//    transition.duration =0.4f;
//    transition.type = kCATransitionMoveIn;
//    transition.subtype = kCATransitionFromTop;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:ViewC animated:NO];
    // * 此处animated设置为NO
    
}

- (void)whenPop{
    
    CATransition* transition = [CATransition animation];
    transition.duration =0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    //* 此处animated设置为NO
    
}

@end
