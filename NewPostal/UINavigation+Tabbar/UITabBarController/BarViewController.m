//
//  BarViewController.m
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import "BarViewController.h"

#import <AVFoundation/AVFoundation.h>


@interface BarViewController ()<MCTabBarControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic,assign) NSInteger index;
@end

@implementation BarViewController
@synthesize navHome,navHistory,CenterBtn,navSite,navMine;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //选中时的颜色
    self.mcTabbar.tintColor = [UIColor colorWithRed:251.0/255.0 green:199.0/255.0 blue:115/255.0 alpha:1];
    
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.mcTabbar.translucent = NO;
    
    self.mcTabbar.position = MCTabBarCenterButtonPositionATthird;
    self.mcTabbar.centerWidth=70.f;
    self.mcTabbar.centerHeight=70.f;
//    self.mcTabbar.centerImage = [UIImage imageNamed:@"icon_scanJ"];
    self.mcTabbar.centerImage = [UIImage imageNamed:@"icon_scan1"];
    self.mcDelegate = self;
    
    
    [self setTitleAndview];
    //    [self addChildViewControllers];
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_SXUI)name:@"UIshuaxin" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
    
    [super viewWillAppear:animated];
}

-(void)setTitleAndview
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *HomeVc=[main instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //    NAvigationViewController *NAV=[main instantiateViewControllerWithIdentifier:@"NAvigationViewController"];
    //    MyViewController *MyVc = [[MyViewController alloc]init];
    HistoryViewController *his=[main instantiateViewControllerWithIdentifier:@"HistoryViewController"];
//    CenterBtnViewController *cen=[main instantiateViewControllerWithIdentifier:@"CenterBtnViewController"];
    ScanCQRViewController *cen=[[ScanCQRViewController alloc] init];
    
    SiteViewController *site=[main instantiateViewControllerWithIdentifier:@"SiteViewController"];
    //    MyViewController *StorHubVc = [[MyViewController alloc]init];
    MineViewController *mine=[main instantiateViewControllerWithIdentifier:@"MineViewController"];
    
    //为两个视图控制器添加导航栏控制器
    navHome = [[CRNavigationController alloc]initWithRootViewController:HomeVc];
    navHistory = [[CRNavigationController alloc]initWithRootViewController:his];
    CenterBtn = [[CRNavigationController alloc]initWithRootViewController:cen];
    navSite = [[CRNavigationController alloc]initWithRootViewController:site];
    navMine = [[CRNavigationController alloc]initWithRootViewController:mine];
    //    GYHub = [[UINavigationController alloc]initWithRootViewController:GYHub_cc];
    navHome.tabBarItem.image=[[UIImage imageNamed:@"icon_Home_01"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_Home_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHistory.tabBarItem.image=[[UIImage imageNamed:@"icon_History_01"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navHistory.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_History_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navSite.tabBarItem.image=[[UIImage imageNamed:@"icon_Site_01"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navSite.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_Site_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMine.tabBarItem.image=[[UIImage imageNamed:@"icon_Mine_01"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMine.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_Mine_-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    GYHub.tabBarItem.image=[[UIImage imageNamed:@"icon_about"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    GYHub.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_about_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navHome.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_put"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navHome.tabBarItem.selectedImage=[UIImage imageNamed:@"tabBar_new_click_icon"];
//    设置控制器文字
    navHome.title = FGGetStringWithKeyFromTable(@"Home", @"Language");
    navHistory.title = FGGetStringWithKeyFromTable(@"History", @"Language");
    navSite.title = FGGetStringWithKeyFromTable(@"Site", @"Language");
    navMine.title = FGGetStringWithKeyFromTable(@"Mine", @"Language");
    //设置控制器图片(使用imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal,不被系统渲染成蓝色)
    //    navOne.tabBarItem.image = [[UIImage imageNamed:@"icon_home_bottom_statist"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navOne.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_bottom_statist_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navTwo.tabBarItem.image = [[UIImage imageNamed:@"icon_home_bottom_search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    navTwo.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_home_bottom_search_hl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateSelected];
    
    //创建一个数组包含四个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:navHome,navHistory,CenterBtn,navSite,navMine,nil];
    
    //将数组传给UITabBarController
    self.viewControllers = vcArry;
    
    self.navigationController.navigationBarHidden=YES;
}
//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
//}
// 使用MCTabBarController 自定义的 选中代理
- (void)mcTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2){
        
    }else if(tabBarController.selectedIndex == 3)
    {
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
//        
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        });
        
    }else {
        [self.mcTabbar.centerBtn.layer removeAllAnimations];
    }
}

//旋转动画
- (void)rotationAnimation{
    if ([@"key" isEqualToString:[self.mcTabbar.centerBtn.layer animationKeys].firstObject]){
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 3.0;
    rotationAnimation.repeatCount = HUGE;
    [self.mcTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}


//提取公共方法
- (void)createControllerWithTitle:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage  className:(Class)class{
    UIViewController *vc = [[class alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
    nav.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:18.0/255 green:183.0/255 blue:245.0/255 alpha:1.0], NSForegroundColorAttributeName,
                                                       nil,nil] forState:UIControlStateSelected];
}

// 点击tabbarItem自动调用
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (index != _index) {
//        [self animationWithIndex:index];
//        _index = index;
    }
    
    
    //    if([item.title isEqualToString:@"发现"])
    //    {
    //        // 也可以判断标题,然后做自己想做的事
    //    }
    
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    /**
     CABasicAnimation类的使用方式就是基本的关键帧动画。
     
     所谓关键帧动画，就是将Layer的属性作为KeyPath来注册，指定动画的起始帧和结束帧，然后自动计算和实现中间的过渡动画的一种动画方式。
     */
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[(UIView*)tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tongzhi_SXUI
{
    [self setTitleAndview];
    //    [self addChildViewControllers];
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

