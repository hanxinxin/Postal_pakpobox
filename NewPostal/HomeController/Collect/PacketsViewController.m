//
//  PacketsViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PacketsViewController.h"
#import "PacketsTableViewCell.h"
#import "DetailInfoPacketsViewController.h"
#import "UIBezierPathView.h"

#define tableID @"PacketsTableViewCell"


@interface PacketsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * PacketsArrList;

@end

@implementation PacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.PacketsArrList = [NSMutableArray arrayWithCapacity:0];
    self.ZtableView.hidden=YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [self addTableViewOrders];
        [self loadNewData];
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    
    [super viewWillDisappear:animated];
}
-(void)addnilView
{
    self.nilView.hidden=NO;
    [self.ZtableView addSubview:self.nilView];
}
-(void)removeNilView
{
    self.nilView.hidden=YES;
    //    [self.nilView removeFromSuperview];
}
-(void)addTableViewOrders
{
//    if(self.view.width==375.000000 && self.view.height>=812.000000)
//    {
//        self.ZtableView.frame=CGRectMake(15, 84+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-84-10);
//    }else{
//        self.ZtableView.frame=CGRectMake(15, 64+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-10);
//    }
    self.ZtableView.hidden=NO;
    self.ZtableView.frame=CGRectMake(14, 0, SCREEN_WIDTH-28, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom)-(44+8));
    //    self.tableViewTop.frame=self.view.frame;
    self.ZtableView.delegate=self;
    self.ZtableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.ZtableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.ZtableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    //    self.tableViewTop.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.ZtableView];
    [self.ZtableView registerNib:[UINib nibWithNibName:@"PacketsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    
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
    self.ZtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.ZtableView.mj_header=header;
    //     self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    self.ZtableView.mj_footer = foot;
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    
}

-(void)loadNewData
{
    //    [self getOrderList];
    NSLog(@"URL === %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_OrderList]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_OrderList] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"Packets_Get_OrderList = %@",responseObject);
        [HudViewFZ HiddenHud];
        [self.PacketsArrList removeAllObjects];
        NSArray * arr = (NSArray*)responseObject;
        for (int i=0; i<arr.count; i++) {
            NSDictionary * dict = arr[i];
            packetsMode * mode = [[packetsMode alloc] init];
            mode.lockerId = [dict objectForKey:@"lockerId"];
            mode.lockerName = [dict objectForKey:@"lockerName"];
            mode.location = [dict objectForKey:@"location"];
            mode.letterCount = [dict objectForKey:@"letterCount"];
            mode.pinCode = [dict objectForKey:@"pinCode"];
            [self.PacketsArrList addObject:mode];
        }
        if(self.PacketsArrList.count>0)
        {
            [self.ZtableView reloadData];
            [self removeNilView];
        }else{
            [self addnilView];
        }
        [self.ZtableView.mj_footer endRefreshing];
        [self.ZtableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}

-(void)loadFootData
{
    [self getOrderListFoot];
}

-(void)getOrderListFoot
{
    [self.ZtableView.mj_footer endRefreshing];
    [self.ZtableView.mj_header endRefreshing];
}



#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.PacketsArrList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PacketsTableViewCell *cell = (PacketsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (PacketsTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PacketsTableViewCell" owner:self options:nil]  lastObject];
    }
    //    NSLog(@"%ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 20;
//    cell.CoutTitle.layer.cornerRadius = 20;
//    [UIBezierPathView setCornerOnLeft:4 view_b:cell.CoutTitle];
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.CoutTitle.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(19, 30)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cell.CoutTitle.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.CoutTitle.layer.mask = maskLayer;
    packetsMode * mode = self.PacketsArrList[indexPath.section];
    [cell.CoutTitle setTitle:[mode.letterCount stringValue] forState:(UIControlStateNormal)];
//    cell.locationText.text = mode.location;
    [self settitleFont:cell.locationText titleText:mode.location];
    return cell;
}
-(void)settitleFont:(UILabel*)label titleText:(NSString *)text
{
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
//    [label setVerticalAlignment:VerticalAlignmentTop];
    label.textAlignment=NSTextAlignmentLeft;
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
            // 第一段：placeholder
            NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
            NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:@"Postal Station @ S(039593) \n"];
            [SubStr1 appendAttributedString:substring1];
            NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
            //设置文字颜色
            [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
            //设置文字大小
//            [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:12] range:rang];
            [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:12] range:rang];
    
            [string appendAttributedString:SubStr1];
            // 第二段：placeholder
            NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
            NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:text];
            [SubStr2 appendAttributedString:substring2];
            NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
            //设置文字颜色
            [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0] range:rang2];
            //设置文字大小
            [SubStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:rang2];//AppleGothic
            [string appendAttributedString:SubStr2];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];[paragraphStyle setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    label.attributedText=string;
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
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击 = %ld",indexPath.section);
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailInfoPacketsViewController *vc=[main instantiateViewControllerWithIdentifier:@"DetailInfoPacketsViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    packetsMode * mode = self.PacketsArrList[indexPath.section];
    vc.modeA = mode;
    [self.navigationController pushViewController:vc animated:YES];

}




@end
