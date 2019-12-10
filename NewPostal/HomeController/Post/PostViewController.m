//
//  PostViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PostViewController.h"
#import "PostTableViewCell.h"
#import "PostSGQViewController.h"
#import "LetterTBViewController.h"
#import "ComDetailInfoViewController.h"

#define tableID @"PostTableViewCell"

@interface PostViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * ParceArrList;
@end

@implementation PostViewController
@synthesize Tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        
        Tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.AddNew.hidden=YES;
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.AddNew.layer.cornerRadius = 25;
    self.ParceArrList = [NSMutableArray arrayWithCapacity:0];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self tableviewSet];
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"To Post", @"Language");
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       [btn setTitle:@"" forState:UIControlStateNormal];
       [btn setImage:[UIImage imageNamed:@"icon_zengjia"] forState:(UIControlStateNormal)];
       [btn addTarget:self action:@selector(rightTouch:) forControlEvents:UIControlEventTouchDown];
       UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
       self.navigationItem.rightBarButtonItem = rightBtn;
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillDisappear:animated];
}
-(void)rightTouch:(id)sender
{
//    PostSGQViewController * Avc = [[PostSGQViewController alloc] init];
//    [self.navigationController pushViewController:Avc animated:YES];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LetterTBViewController *Avc=[main instantiateViewControllerWithIdentifier:@"LetterTBViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    Avc.ItemNumber = @"";
    [self.navigationController pushViewController:Avc animated:YES];
}
-(void)addnilView
{
    self.NilVIew.hidden=NO;
    [self.view addSubview:self.NilVIew];
    [self.view addSubview:self.AddNew];
}
-(void)removeNilView
{
    self.NilVIew.hidden=YES;
    //    [self.nilView removeFromSuperview];
}

- (IBAction)AddNewTouch:(id)sender {
    PostSGQViewController * Avc = [[PostSGQViewController alloc] init];
    [self.navigationController pushViewController:Avc animated:YES];
//    [self presentViewController:Avc animated:YES completion:nil];
    
//    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LetterTBViewController *Avc=[main instantiateViewControllerWithIdentifier:@"LetterTBViewController"];
//    Avc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:Avc animated:YES];
    
}
/**
 创建tableview
 */
-(void)tableviewSet
{
    NSLog(@"height=== %f,      %f,       %f",self.navigationController.navigationBar.height+40,SCREEN_HEIGHT-(self.navigationController.navigationBar.height+40),self.view.height);
    if(self.view.height>=812.000000)
    {
        Tableview.frame = CGRectMake(15, self.navigationController.navigationBar.height+40, SCREEN_WIDTH-30,SCREEN_HEIGHT-(self.navigationController.navigationBar.height+40));
    }else{
        Tableview.frame = CGRectMake(15,self.navigationController.navigationBar.height+20, SCREEN_WIDTH-30,SCREEN_HEIGHT-(self.navigationController.navigationBar.height+20));
    }
    
    Tableview.delegate=self;
    Tableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    Tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    Tableview.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //    DownTableview.backgroundColor = [UIColor whiteColor];
    
    [Tableview registerNib:[UINib nibWithNibName:@"PostTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    [self setLoadHT];
    [self.view addSubview:Tableview];
    [self.view addSubview:self.AddNew];
    
}
/**
 设置 下拉刷新
 */
-(void)setLoadHT
{
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
    self.Tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.Tableview.mj_header=header;
    //     self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    self.Tableview.mj_footer = foot;
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    //     马上进入刷新状态
    [self.Tableview.mj_header beginRefreshing];
}
-(void)loadNewData
{
        [self getPostList];
}

-(void)loadFootData
{
    //    [self getOrderListFoot];
        [self getPostList];
}

-(void)getPostList
{
    NSLog(@"URL === %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_ToPostList]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_ToPostList] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"111Parcel = %@",responseObject);
        [HudViewFZ HiddenHud];
        [self.ParceArrList removeAllObjects];
        NSArray * arr = (NSArray*)responseObject;
        for (int i=0; i<arr.count; i++) {
            NSDictionary * dict = arr[i];
            PostListMode * mode = [[PostListMode alloc] init];
            mode.ordersId = [dict objectForKey:@"ordersId"];
            mode.ordersNumber = [dict objectForKey:@"ordersNumber"];
            [self.ParceArrList addObject:mode];
        }
        if(self.ParceArrList.count>0)
        {
            [self.Tableview reloadData];
            [self removeNilView];
        }else{
            [self addnilView];
        }
        [self.Tableview.mj_footer endRefreshing];
        [self.Tableview.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        if(self.ParceArrList.count>0)
        {
            [self.Tableview reloadData];
            [self removeNilView];
        }else{
            [self addnilView];
        }
        [self.Tableview.mj_footer endRefreshing];
        [self.Tableview.mj_header endRefreshing];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        
    }];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.ParceArrList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (PostTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PostTableViewCell" owner:self options:nil]  lastObject];
    }
    NSLog(@"ACCCCCCC == %ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    [cell.PopButton setImage:[UIImage imageNamed:@"icon_delete"] forState:(UIControlStateNormal)];
    cell.backgroundColor = [UIColor whiteColor];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PostListMode * mode = self.ParceArrList[indexPath.section];
//    cell.letterNo.text = mode.ordersId;
    cell.NumberLabel.text = mode.ordersNumber;
    cell.layer.cornerRadius = 20;
    return cell;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //    view_c.backgroundColor=[UIColor whiteColor];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComDetailInfoViewController *Avc=[main instantiateViewControllerWithIdentifier:@"ComDetailInfoViewController"];
    PostListMode * mode = self.ParceArrList[indexPath.section];
    Avc.returnfalg = 0;
    Avc.orderIDStr = mode.ordersId;
    Avc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Avc animated:YES];
}


@end
