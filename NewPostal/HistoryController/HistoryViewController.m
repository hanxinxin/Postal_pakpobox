//
//  HistoryViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HistoryViewController.h"
#import "HisParcelViewController.h"
#import "HisLettersViewController.h"
#import "LLSegmentBarVC.h"
#import "DCNavTabBarController.h"
@interface HistoryViewController ()<DCNavTabBarControllerDelegate>

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    //     [self customNavItem];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HisParcelViewController *parcel=[main instantiateViewControllerWithIdentifier:@"HisParcelViewController"];
    parcel.title = @"Parcel";
    HisLettersViewController *Packets=[main instantiateViewControllerWithIdentifier:@"HisLettersViewController"];
    Packets.title = @"Posted";
    NSArray *subViewControllers = @[parcel,Packets];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    //    tabBarVC.view.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom));
    tabBarVC.delegate=self;
    tabBarVC.view.frame = CGRectMake(0, -5, SCREEN_WIDTH, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom));
    
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
    
    //
    
}
-(void)SelectInt:(NSInteger)intager
{
    //    NSLog(@"tag1111==== %ld",intager);
}

- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.navigationItem.title=FGGetStringWithKeyFromTable(@"History", @"Language");
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
    });
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [super viewWillDisappear:animated];
}

@end
