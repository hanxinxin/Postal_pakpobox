//
//  MineViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "CRNavigationController.h"
#import "AddressInfoViewController.h"
#import "ScanCQRViewController.h"
#import "CityListViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)NSMutableArray * attTableTitle;
@property (nonatomic,strong)NSMutableArray * attTableDetailTitle;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title=@"Mine";
//    Family member
    self.navigationController.navigationBar.translucent = NO;
    self.attTableTitle = [NSMutableArray arrayWithCapacity:0];
    self.attTableDetailTitle = [NSMutableArray arrayWithCapacity:0];
    [self.attTableTitle addObject:@[@"Registration type"]];
    [self.attTableTitle addObject:@[@"Mobile",@"Email"]];
    [self.attTableTitle addObject:@[@"Address"]];
    [self.attTableTitle addObject:@[@"Log out"]];
    [self.attTableDetailTitle addObject:@[@"Household Admin"]];
    [self.attTableDetailTitle addObject:@[@"9866 1234",@"jason.chen@singpost.com"]];
    [self.attTableDetailTitle addObject:@[@"10 Eunos Road 8, #05-37 S(408600)"]];
    [self.attTableDetailTitle addObject:@[@""]];
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addTableViewOrders];
//    });
}

- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.navigationItem.title=FGGetStringWithKeyFromTable(@"My Information", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
    });
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}


-(void)addTableViewOrders
{
    //    if(self.view.width==375.000000 && self.view.height>=812.000000)
    //    {
    //        self.ZtableView.frame=CGRectMake(15, 84+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-84-10);
    //    }else{
    //        self.ZtableView.frame=CGRectMake(15, 64+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-10);
    //    }
    self.DownTableView.frame=CGRectMake(14, self.TopView.bottom+8, SCREEN_WIDTH-28, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom)-(self.navigationController.tabBarController.tabBar.height)-(self.TopView.height+8));
    //    self.tableViewTop.frame=self.view.frame;
    self.DownTableView.delegate=self;
    self.DownTableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.DownTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.DownTableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    //    self.tableViewTop.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.DownTableView];
//    [self.DownTableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = NO;
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 隐藏状态
    foot.stateLabel.hidden = NO;
    // 设置文字
    [foot setTitle:@"Drop down to refresh more" forState:MJRefreshStateIdle];
    [foot setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [foot setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    // 设置字体
    foot.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    foot.stateLabel.textColor = [UIColor blackColor];
    //    foot.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    self.DownTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.DownTableView.mj_header=header;
    //     self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    self.DownTableView.mj_footer = foot;
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    
}

-(void)loadNewData
{
    //    [self getOrderList];
    [self.DownTableView.mj_footer endRefreshing];
    [self.DownTableView.mj_header endRefreshing];
}

-(void)loadFootData
{
    [self getOrderListFoot];
}

-(void)getOrderListFoot
{
    [self.DownTableView.mj_footer endRefreshing];
    [self.DownTableView.mj_header endRefreshing];
}



#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * arr = self.attTableTitle[section];
    return arr.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.attTableTitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    //    NSLog(@"%ld",indexPath.section);
    
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray * arr = self.attTableTitle[indexPath.section];
    NSArray * arrDetailTextLabel = self.attTableDetailTitle[indexPath.section];
    if(indexPath.section==3)
    {
        cell.textLabel.text = arr[indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.f]];
        [cell.textLabel setTextAlignment:(NSTextAlignmentCenter)];
    }else{
    cell.textLabel.text = arr[indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.f]];
    cell.detailTextLabel.text = arrDetailTextLabel[indexPath.row];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.f]];
    }
        
   
    if(indexPath.section==1)
    {
        if (indexPath.row==1) {
            UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
            lbl.frame = CGRectMake(cell.frame.origin.x , 0, self.view.width-1, 1);
            lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
            [cell.contentView addSubview:lbl];
        }
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if(indexPath.row==0)
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }else if(indexPath.row==1)
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            
        }
         });
    }else
    {
        cell.layer.cornerRadius = 20;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_next"]];
        cell.accessoryView = accessoryImgView;
    }
    
    return cell;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    NSArray * arr = self.attTableTitle[indexPath.section];
//    if(section==1)
//    {
//        return 0;
//    }
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    //    view_c.frame=CGRectMake(0, 0, 0, 0);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
//            ScanCQRViewController * vc =[[ScanCQRViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            self.definesPresentationContext = YES;
//            [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==1)
    {
        
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CityListViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CityListViewController"];
        Avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Avc animated:YES];
    }else if(indexPath.section==2)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddressInfoViewController *Avc=[main instantiateViewControllerWithIdentifier:@"AddressInfoViewController"];
        Avc.hidesBottomBarWhenPushed = YES;
        Avc.tagS = 9999;
        [self.navigationController pushViewController:Avc animated:YES];
    }else if(indexPath.section==3)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"YHToken"];
            [userDefaults setObject:@"1" forKey:@"phoneNumber"];
            [userDefaults setObject:@"1" forKey:@"TouchID"];
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CRNavigationController*VC=[main instantiateViewControllerWithIdentifier:@"CRNavigationController"];
        self.navigationController.view.window.rootViewController=VC;
    }
}

@end
