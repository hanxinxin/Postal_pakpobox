//
//  ScanViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ScanViewController.h"
#import "WCQRCodeScanningVC.h"
#import "ScanCQRViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back_touch:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)scanToCollect:(id)sender {
    WCQRCodeScanningVC * vc = [[WCQRCodeScanningVC alloc] init];
    vc.tag_int = 1;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)scanToPost:(id)sender {
    WCQRCodeScanningVC * vc = [[WCQRCodeScanningVC alloc] init];
    vc.tag_int = 1;
    [self presentViewController:vc animated:YES completion:nil];
//    ScanCQRViewController * vc =[[ScanCQRViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    self.definesPresentationContext = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
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
