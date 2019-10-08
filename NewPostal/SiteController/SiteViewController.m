//
//  SiteViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SiteViewController.h"
#import "SiteTableViewCell.h"
#import "LocationViewController.h"
#import "LZPickerView.h"

#define tableID @"SiteTableViewCell"


@interface SiteViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)LZPickerView *lzPickerVIew;

@end

@implementation SiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title=@"Site";
    self.navigationController.navigationBar.translucent = NO;
    self.searchView.layer.borderColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1].CGColor;
//    self.searchView.layer.shadowOffset = CGSizeMake(0,3);
//    self.searchView.layer.shadowRadius = 6;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.cornerRadius = 18;
//    self.SearchBar.placeholder = @"Please enter the  name of service sites";
    

//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setSearchBarAdd];
        [self addTableViewOrders];
//    });
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
    
    
    
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.navigationItem.title=FGGetStringWithKeyFromTable(@"Service Sites", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];;
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
- (IBAction)centralTouch:(id)sender {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LZPickerView" owner:nil options:nil];
    self.lzPickerVIew  = views[0];
    [self.lzPickerVIew lzPickerVIewType:LZPickerViewTypeSexAndHeight];
    self.lzPickerVIew.dataSource =@[@"Central",@"East",@"West",@"Northeast",@"Southeast",@"Northwest",@"Northeast"];
    self.lzPickerVIew.titleText = @"";
    //    self.lzPickerVIew.selectDefault = text;
    self.lzPickerVIew.selectValue  = ^(NSString *value){
        [self->_centralBtn setTitle:value forState:UIControlStateNormal];
        
    };
    [self.lzPickerVIew show];
}


-(void)setSearchBarAdd
{
    self.SearchBar.delegate = self;
    // 样式
    self.SearchBar.searchBarStyle = UISearchBarStyleMinimal;
    // ** 自定义searchBar的样式 **
    UITextField* searchField = nil;
    // 注意searchBar的textField处于孙图层中
    for (UIView* subview  in [self.SearchBar.subviews firstObject].subviews) {
        NSLog(@"%@", subview.class);
        if ([subview isKindOfClass:[UITextField class]]) {
            
            searchField = (UITextField*)subview;
            // leftView就是放大镜
            // searchField.leftView=nil;
            searchField.leftView.frame=CGRectMake(0, searchField.leftView.top, searchField.leftView.width, searchField.leftView.height);
            //            searchField.frame = CGRectMake(searchField.leftView.right, searchField.top, (self.SearchBar.width-searchField.leftView.right), searchField.height);
            [searchField setBackground:nil];
            [searchField setBorderStyle:UITextBorderStyleNone];
            NSString *holderText = @"Please enter the  name of service sites";
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
            [placeholder addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:0.96]
                                range:NSMakeRange(0, holderText.length)];
            [placeholder addAttribute:NSFontAttributeName
                                value:[UIFont boldSystemFontOfSize:11]
                                range:NSMakeRange(0, holderText.length)];
            searchField.attributedPlaceholder = placeholder;
            // 设置圆角
            searchField.layer.cornerRadius = 15;
            searchField.layer.masksToBounds = YES;
            break;
        }
    }
}




-(void)addTableViewOrders
{
    //    if(self.view.width==375.000000 && self.view.height>=812.000000)
    //    {
    //        self.ZtableView.frame=CGRectMake(15, 84+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-84-10);
    //    }else{
    //        self.ZtableView.frame=CGRectMake(15, 64+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-10);
    //    }
    self.DownTableView.frame=CGRectMake(14, self.topView.bottom+8, SCREEN_WIDTH-28, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom)-(self.navigationController.tabBarController.tabBar.height)-(self.topView.height+8));
    //    self.tableViewTop.frame=self.view.frame;
    self.DownTableView.delegate=self;
    self.DownTableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.DownTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.DownTableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    //    self.tableViewTop.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.DownTableView];
    [self.DownTableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    
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
    
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SiteTableViewCell *cell = (SiteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (SiteTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"SiteTableViewCell" owner:self options:nil]  lastObject];
    }
    //    NSLog(@"%ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 107;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationViewController *Avc=[main instantiateViewControllerWithIdentifier:@"LocationViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Avc animated:YES];
}

@end
