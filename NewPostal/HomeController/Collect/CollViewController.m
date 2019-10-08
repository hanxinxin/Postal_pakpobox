//
//  CollViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CollViewController.h"
#import "LLSegmentBarVC.h"
#import "DCNavTabBarController.h"
#import "HomeViewController.h"
#import "ParcelViewController.h"
#import "PacketsViewController.h"

@interface CollViewController ()<DCNavTabBarControllerDelegate>

//@property (nonatomic,weak) LLSegmentBarVC * segmentVC;//
@end

@implementation CollViewController

#pragma mark - segmentVC
//- (LLSegmentBarVC *)segmentVC{
//    if (!_segmentVC) {
//        LLSegmentBarVC *vc = [[LLSegmentBarVC alloc]init];
//        // 添加到到控制器
//        [self addChildViewController:vc];
//        _segmentVC = vc;
//    }
//    return _segmentVC;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
//     [self customNavItem];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ParcelViewController *parcel=[main instantiateViewControllerWithIdentifier:@"ParcelViewController"];
    parcel.title = @"Parcel";
    PacketsViewController *Packets=[main instantiateViewControllerWithIdentifier:@"PacketsViewController"];
    Packets.title = @"Letters/Packets";
    NSArray *subViewControllers = @[Packets,parcel];
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
    self.title=FGGetStringWithKeyFromTable(@"Collect", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
    });
    //    [self addRightBtn];  ///// 修改为切换语言的按钮
    [super viewWillAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;

    [super viewWillDisappear:animated];
}


// 点击back按钮后调用 引用的他人写的一个extension
- (BOOL)navigationShouldPopOnBackButton {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HomeViewController class]]) {
            // 第二种办法：在显示导航栏的时候要添加动画
            [self.navigationController setNavigationBarHidden:YES animated:NO];
//            [self.navigationController popViewControllerAnimated:NO];
//            return NO;
        }
    }
    return YES;
}
/*
-(void)customNavItem
{
        // 1 设置segmentBar的frame
        self.segmentVC.segmentBar.frame = CGRectMake(100, 0, SCREEN_WIDTH-200, 35);
        self.navigationItem.titleView = self.segmentVC.segmentBar;
        // 2 添加控制器的View
        self.segmentVC.view.frame = self.view.bounds;
        [self.view addSubview:self.segmentVC.view];
        NSArray *items = @[@"Parcel", @"Letters/Packets"];
        UIViewController *follow = [[UIViewController alloc] init];
        follow.view.backgroundColor = [UIColor whiteColor];
        UIViewController *find = [[UIViewController alloc] init];
        find.view.backgroundColor = [UIColor redColor];
        // 3 添加标题数组和控住器数组
        [self.segmentVC setUpWithItems:items childVCs:@[follow,find]];
        // 4  配置基本设置  可采用链式编程模式进行设置
        [self.segmentVC.segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {
            config.itemNormalColor([UIColor blackColor]).itemSelectColor([UIColor blackColor]).indicatorColor([UIColor colorWithRed:8/255.0 green:79/255.0 blue:171/255.0 alpha:1.0]);
        }];
}
 
 */

@end
