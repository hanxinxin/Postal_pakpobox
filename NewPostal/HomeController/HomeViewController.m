//
//  HomeViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "XHPageControl.h"
#import "SelectCell.h"
#import "CollViewController.h"
#import "PostViewController.h"

#define count_t 2
#define LBHeight SCREEN_HEIGHT*0.277
#define tableID @"SelectCell"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (nonatomic ,retain) XHPageControl * myPageControl;
@property (nonatomic, weak)NSTimer* rotateTimer;  //让视图自动切换
@property (nonatomic,strong) NSMutableArray *imgArr;//轮播图片数组
@end

@implementation HomeViewController
@synthesize LBScrollView,DownTableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        LBScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        DownTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.imgArr=[NSMutableArray arrayWithCapacity:0];
    [self.imgArr addObject:@"Banner02"];
    [self.imgArr addObject:@"Banner02"];
    [self addScrollerView];
    [self tableviewDSet];
}
- (void)viewWillAppear:(BOOL)animated {
    // 第二种办法：在显示导航栏的时候要添加动画
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
//    self.navigationController.title=FGGetStringWithKeyFromTable(@"Home", @"Language");
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
       
    });
    
    //    [self addRightBtn];  ///// 修改为切换语言的按钮
    [super viewWillAppear:animated];
}




//-(void)viewDidAppear:(BOOL)animated
//{
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBar.translucent = YES;
//        self.navigationController.navigationBar.subviews[0].alpha = 0.0;
//    });
//
//    [super viewDidAppear:animated];
//
//}

- (void)viewWillDisappear:(BOOL)animated {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        //    [backBtn setTintColor:[UIColor blackColor]];
        backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
        self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]];
    // 自定义返回图片(在返回按钮旁边) 这个效果由navigationBar控制
//    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"icon_back"]];
//    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"icon_back"]];
    [self.rotateTimer fire];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

/**
 创建滚动轮播图
 */
-(void)addScrollerView
{
    //设置滚动范围
    if(self.view.height>=812)
    {
        LBScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, LBHeight);
    }else if(self.view.width==320.f && self.view.height==568.f)
    {
        LBScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, LBHeight);
    }else if(self.view.width==375.f && self.view.height==667.f)
    {
        LBScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, LBHeight);
    }else{
        LBScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, LBHeight);
    }
    
//    LBScrollView.backgroundColor = [UIColor blueColor];
    //    GG_Scroller.frame=CGRectMake(0, 0, SCREEN_WIDTH, 180*autoSizeScaleX);
    
    //设置分页效果
    LBScrollView.pagingEnabled = YES;
    //    GG_Scroller.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
    //    GG_Scroller.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);//设置边框颜色
    //    GG_Scroller.layer.borderWidth = 1.0f;//设置边框颜色
    //水平滚动条隐藏
    LBScrollView.showsHorizontalScrollIndicator = NO;
    //// 给Scroller加一个点击手势
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    tap.numberOfTapsRequired = 1;
    [LBScrollView addGestureRecognizer:tap];
    
    
    LBScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*(self.imgArr.count+2), LBHeight);
    //添加三个子视图  UILabel类型
    //    for (int i = 0; i< count_t; i++) {
    for (int i = 0; i< self.imgArr.count+2; i++) {
        UIImageView *imagView = [[UIImageView alloc]init];  imagView.frame=CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, LBScrollView.height);
        if(i==0)
        {
            //            imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner02"]];
            imagView.image = [UIImage imageNamed:self.imgArr[self.imgArr.count-1]];
        }else if(i==(self.imgArr.count+1)){
            //            imagView.image = [UIImage imageNamed:[NSString stringWithFormat:@"banner"]];
            imagView.image = [UIImage imageNamed:self.imgArr[0]];
        }else
        {
            imagView.image = [UIImage imageNamed:self.imgArr[i-1]];
        }
        //        [imagView setContentMode:UIViewContentModeCenter];
        //        imagView.clipsToBounds = YES;
        [imagView setClipsToBounds:NO];
        
        [imagView setContentMode:UIViewContentModeRedraw];
        
        [LBScrollView addSubview:imagView];
    }
    [LBScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    [self.view addSubview:LBScrollView];
    //启动定时器
    if(self.rotateTimer==nil)
    {
        self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    }else
    {
        [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:3.0 sinceDate:[NSDate date]]];
    }
    LBScrollView.tag = 1000;
    //    X= 375.000000,812.000000
    //    NSLog(@"X= %f,%f",self.view.frame.size.width,self.view.frame.size.height);
    if((self.view.frame.size.width==375) && (self.view.frame.size.height>=812))
    {
        self.myPageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, LBScrollView.height+4, CGRectGetWidth(self.view.frame), 15)];
    }else
    {
        self.myPageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, LBScrollView.height+4, CGRectGetWidth(self.view.frame), 15)];
    }
    self.myPageControl.numberOfPages = count_t;
    self.myPageControl.currentPage = 0;
    self.myPageControl.userInteractionEnabled=NO;
    //            self.myPageControl.pageIndicatorTintColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];        //设置未激活的指示点颜色
//    self.myPageControl.pageIndicatorTintColor = [UIColor colorWithRed:198/255.0 green:228/255.0 blue:248/255.0 alpha:1.0];
//    self.myPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];

    //设置非选中点的宽度是高度的倍数(设置长条形状)
    self.myPageControl.otherMultiple = 1;
    //设置选中点的宽度是高度的倍数(设置长条形状)
    self.myPageControl.currentMultiple = 2;
    //设置样式.默认居中显示
    self.myPageControl.type = PageControlMiddle;
    //非选中点的颜色
    self.myPageControl.otherColor=[UIColor whiteColor];
    //选中点的颜色
    self.myPageControl.currentColor=[UIColor colorWithRed:159/255.0 green:210/255.0 blue:255/255.0 alpha:1.0];
    ///设置当前页指示点颜色
//    self.myPageControl.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myPageControl];
    //    [GG_Scroller addSubview:self.myPageControl];
    
    //为滚动视图指定代理
    LBScrollView.delegate = self;
    self.myPageControl.hidden=NO;
    //    }
    
    
    [self.view addSubview:LBScrollView];
    [self.view addSubview:self.myPageControl];
}
#pragma mark -- 滚动视图的代理方法
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //        NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    
    
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    //            NSLog(@"Begin   X= %f,Y= %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if(scrollView.tag==1000)
    {
        [self.rotateTimer setFireDate:[NSDate distantFuture]];
        
        
        
    }else if (scrollView.tag==1001)
    {
        //        CGFloat offsetY = scrollView.contentOffset.y;
        self.navigationController.navigationBar.translucent = YES;
    }
    //    else  if(scrollView.tag==12000)
    //    {
    //        collectionView_L.alpha=0.8;
    //    }
    
}
//监听scrollView滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 1001 ) {
        CGFloat offsetY = scrollView.contentOffset.y;
        //        NSLog(@"offsetY === %f",offsetY);
        [self setNavigationBarColorWithOffsetY:offsetY];
    }else if(scrollView.tag==1000)
    {
        
        //        NSLog(@"offsetX === %f",offsetX);
        
        
        
    }
}
// 界面滑动时导航栏随偏移量 实时变化
- (void)setNavigationBarColorWithOffsetY:(CGFloat)offsetY {
    UIImageView *backView = self.navigationController.navigationBar.subviews[0];
    if (offsetY <= 0) {
        backView.alpha = 0;
        if(offsetY<0)
        {
//            self.globalScrollview.contentOffset=CGPointMake(0, 0);
            
        }
    } else if (offsetY > 0 && offsetY < 64) {
        backView.alpha = offsetY / 64;
        //        self.navigationController.navigationBar.translucent = YES;
    } else if (offsetY >= 64 ) {//&& offsetY <= NavBar_HEIGHT + 30
        backView.alpha = 1;
        
        //        self.navigationController.navigationBar.translucent = NO;
        
    }
}
//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //        NSLog(@"8888888");
    //            NSLog(@"End    X= %f,Y= %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    //        NSLog(@"几倍？= %f",(scrollView.contentOffset.x)/(self.view.frame.size.width));
    if(scrollView.tag==1000)
    {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        if(offsetX>=(SCREEN_WIDTH*3))
        {
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
            self.myPageControl.currentPage =(int)(scrollView.contentOffset.x)/(self.view.frame.size.width)-1;
        }else if (offsetX<SCREEN_WIDTH)
        {
            [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.imgArr.count, 0) animated:NO];
            self.myPageControl.currentPage =(int)(scrollView.contentOffset.x)/(self.view.frame.size.width)-1;
        }else{
            self.myPageControl.currentPage =(int)(scrollView.contentOffset.x)/(self.view.frame.size.width)-1;
        }
        //视图静止之后，过1.5秒在开启定时器
        //    [NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
        //        NSLog(@"开启定时器");
        [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:3.0 sinceDate:[NSDate date]]];
        
        
    }else if(scrollView.tag==1001)
    {
        
        self.navigationController.navigationBar.translucent = NO;
    }
    
}


//定时器的回调方法   切换界面
- (void)changeView{
    //    NSLog(@"onetwo12 ");
    //得到scrollView
    UIScrollView *scrollView = [self.view viewWithTag:1000];
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += CGRectGetWidth(self.view.frame);
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X == CGRectGetWidth(self.view.frame)*(count_t+1)) {
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        offset_X = SCREEN_WIDTH;
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.view.frame)*(count_t+1)) {
        self.myPageControl.currentPage = 1;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.view.frame)-1;
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.view.frame)*(count_t+1)) {
        self.myPageControl.currentPage = 1;
        //        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*count_t, 0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
    
    
}
//点击
-(void)doTapChange:(UITapGestureRecognizer *)sender{
    //    NSLog(@"点击了第%ld个",(long)self.myPageControl.currentPage);
}



/**
 创建tableview
 */
-(void)tableviewDSet
{
    
    if(self.view.width==375.000000 && self.view.height>=812.000000)
    {
//        DownTableview.frame = CGRectMake(15, self.myPageControl.bottom+8, SCREEN_WIDTH-30,130*2+8*2);
        
        DownTableview.frame = CGRectMake(15, self.myPageControl.bottom, SCREEN_WIDTH-30,SCREEN_HEIGHT-(self.myPageControl.bottom));
    }else{
        DownTableview.frame = CGRectMake(15, self.myPageControl.bottom, SCREEN_WIDTH-30,SCREEN_HEIGHT-(self.myPageControl.bottom));
    }
    
    DownTableview.delegate=self;
    DownTableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    DownTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    DownTableview.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
//    DownTableview.backgroundColor = [UIColor whiteColor];
    
    [DownTableview registerNib:[UINib nibWithNibName:@"SelectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    //    self.tableViewD.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    // 进入刷新状态后会自动调用这个block
    //    }];
    // 或
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
    //    self.tableViewD.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //    self.tableViewD.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    [self.view addSubview:DownTableview];
    
}

-(void)loadNewData
{
    //    [self getOrderList];
}

-(void)loadFootData
{
    //    [self getOrderListFoot];
    
}
#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = (SelectCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell= (SelectCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"SelectCell" owner:self options:nil]  lastObject];
    }
        NSLog(@"indexPath.section== %ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    [cell.contentView addSubview:lbl];
    
    cell.backgroundColor = [UIColor whiteColor];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section==0) {
           [cell.leftBtn setImage:[UIImage imageNamed:@"icon_Post"] forState:(UIControlStateNormal)];
            cell.topLabel.text = @"Collect";
        }else if (indexPath.section==1) {
            [cell.leftBtn setImage:[UIImage imageNamed:@"icon_Collect"] forState:(UIControlStateNormal)];
            cell.topLabel.text = @"Post";
        }else if (indexPath.section==2) {
        }
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
    
    return 130;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    WelcomeViewController *vc=[main instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    if(indexPath.section==0)
    {
//        CollViewController * Avc = [[CollViewController alloc] init];
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CollViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CollViewController"];
        Avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Avc animated:YES];
    }else if(indexPath.section==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PostViewController *Avc=[main instantiateViewControllerWithIdentifier:@"PostViewController"];
        Avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Avc animated:YES];
    }
}


@end
