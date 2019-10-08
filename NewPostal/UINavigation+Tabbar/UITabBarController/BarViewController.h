//
//  BarViewController.h
//  StorHub
//
//  Created by Pakpobox on 2018/2/23.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "CRNavigationController.h"
#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "SiteViewController.h"
#import "MineViewController.h"
#import "CenterBtnViewController.h"
#import "MCTabBarController.h"
#import "ScanCQRViewController.h"
//@interface BarViewController : UITabBarController
@interface BarViewController : MCTabBarController

@property (nonatomic,strong)CRNavigationController *navHome;
@property (nonatomic,strong)CRNavigationController *navHistory;
@property (nonatomic,strong)CRNavigationController * CenterBtn;
@property (nonatomic,strong)CRNavigationController *navSite;
@property (nonatomic,strong)CRNavigationController *navMine;
//@property (nonatomic,strong)UINavigationController *GYHub;

-(void)setTitle;
@end
