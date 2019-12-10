//
//  AddressInfoViewController.m
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AddressInfoViewController.h"
#import "DInfoTableViewCell.h"
#import "AddressDetailViewController.h"


#define TableDInfoID @"DInfoTableViewCell"

@interface AddressInfoViewController ()<UITableViewDelegate,UITableViewDataSource,DInfoTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray * arrListTitle;
@end

@implementation AddressInfoViewController
@synthesize TableView,arrListTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    arrListTitle=[NSMutableArray arrayWithCapacity:0];
    self.AddNewBtn.hidden=YES;
    [self tableviewSet];
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"Detail Info", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self getAddressListInfo];
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
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressDetailViewController *Avc=[main instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
    Avc.GXFlag = 0;
    Avc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Avc animated:YES];
}

-(void)getAddressListInfo
{
    NSLog(@"URL === %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_addressList]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_addressList] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"Get_addressList = %@",responseObject);
        NSArray * dictArr = (NSArray*)responseObject;
        if(dictArr.count>0)
        {
            [self->arrListTitle removeAllObjects];
        for (int i = 0; i<dictArr.count; i++) {
            NSDictionary * dictZ = (NSDictionary*)dictArr[i];
            AddressListMode * mode = [[AddressListMode alloc] init];
            mode.addressFullName = [dictZ objectForKey:@"addressFullName"];
            mode.addressLine1 = [dictZ objectForKey:@"addressLine1"];
            mode.addressLine2 = [dictZ objectForKey:@"addressLine2"];
            mode.country = [dictZ objectForKey:@"country"];
            mode.countryCallingCode = [dictZ objectForKey:@"countryCallingCode"];
            mode.defaultFlag = [dictZ objectForKey:@"defaultFlag"];
            mode.mobile = [dictZ objectForKey:@"mobile"];
            mode.postalCode = [dictZ objectForKey:@"postalCode"];
            mode.userAddressId = [dictZ objectForKey:@"userAddressId"];
            [self->arrListTitle addObject:mode];
        }
            if(self->arrListTitle.count>0)
            {
                [self->TableView reloadData];
            }
        }
        [HudViewFZ HiddenHud];
      
        [self.TableView.mj_footer endRefreshing];
        [self.TableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [self.TableView.mj_footer endRefreshing];
        [self.TableView.mj_header endRefreshing];
    }];
}

-(void)Delete_post_addressMode:(NSString*)userAddressId
{
//    NSDictionary *dict = @{ @"userAddressId":userAddressId,
//                            };
    NSLog(@"Delete URL  ====%@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Post_addressDelete,userAddressId]);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Post_addressDelete,userAddressId] parameters:nil progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"postParcel====  %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dict = (NSDictionary*)responseObject;
        NSNumber * result = [dict objectForKey:@"result"];
        if([result integerValue]==1)
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Delete address successful", @"Language") andDelay:2.0];
            [self getAddressListInfo];
        }
    } failure:^(NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}


- (IBAction)AddNewTouch:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressDetailViewController *Avc=[main instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
    Avc.GXFlag = 0;
    Avc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Avc animated:YES];
}
/**
 创建tableview
 */
-(void)tableviewSet
{
    NSLog(@"height=== %f",self.navigationController.navigationBar.height+20);
    if(self.view.width==375.000000 && self.view.height>=812.000000)
    {
        TableView.frame = CGRectMake(15, self.navigationController.navigationBar.height+20, SCREEN_WIDTH-30,SCREEN_HEIGHT-(self.navigationController.navigationBar.height+20+5));
    }else{
        TableView.frame = CGRectMake(15,self.navigationController.navigationBar.height+20, SCREEN_WIDTH-30,SCREEN_HEIGHT-(self.navigationController.navigationBar.height+20+5));
    }
    
    TableView.delegate=self;
    TableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //    DownTableview.backgroundColor = [UIColor whiteColor];
    
    [TableView registerNib:[UINib nibWithNibName:@"DInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableDInfoID];
    [self setLoadHT];
    [self.view addSubview:TableView];
    //    self.CompleteB.frame=CGRectMake(15, TableView.height-50, SCREEN_WIDTH-30, 50);
    self.AddNewBtn.layer.cornerRadius = 25;
    [self.view addSubview:self.AddNewBtn];
    
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
    self.TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    self.TableView.mj_header=header;
    //     self.tableViewTop.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    self.TableView.mj_footer = foot;
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    //     马上进入刷新状态
    [self.TableView.mj_header beginRefreshing];
}
-(void)loadNewData
{
    [self getAddressListInfo];
}

-(void)loadFootData
{
    //    [self getOrderListFoot];
    [self getAddressListInfo];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return arrListTitle.count;
    
    return arrListTitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSString * cellID = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    //根据identify在缓存的字典中找是否有已经初始化好的cell
    
        DInfoTableViewCell *cellMobile = (DInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableDInfoID];
        if (cellMobile == nil) {
            cellMobile= (DInfoTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"DInfoTableViewCell" owner:self options:nil]  lastObject];
        }
        //        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        //        lbl.frame = CGRectMake(16 , 0, cellMobile.width-16*2, 1);
        //        lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        //        [cellMobile.contentView addSubview:lbl];
        cellMobile.tag = [[NSString stringWithFormat:@"500%ld%ld",indexPath.section,indexPath.row] integerValue];
        cellMobile.delegate = self;
        AddressListMode * mode = arrListTitle[indexPath.section];
        cellMobile.TopL_title.text = mode.addressFullName;
        cellMobile.TopC_title.text = mode.mobile;
        cellMobile.Down_Title.text = [NSString stringWithFormat:@"%@ %@",mode.addressLine1,mode.addressLine2];
        cellMobile.selectionStyle = UITableViewCellSelectionStyleNone;
        cellMobile.layer.cornerRadius = 20;
        return cellMobile;
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
    view_c.frame=CGRectMake(16, 7,SCREEN_WIDTH-16, 15);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //    view_c.backgroundColor=[UIColor whiteColor];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 100;
}
#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        AddressListMode * mode = self->arrListTitle[indexPath.section];
        [self Delete_post_addressMode:mode.userAddressId];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"AddressL === %ld",indexPath.section);
    //        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        CollViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CollViewController"];
    //        Avc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:Avc animated:YES];
    if(_tagS==9999)
    {
        
    }else
    {
         AddressListMode * mode = arrListTitle[indexPath.section];
        if ([self.delegate respondsToSelector:@selector(returnAddressStr:tagS:)])
        {
            [self.delegate returnAddressStr:mode tagS:self.tagS]; // 回调代理
        }
    [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)push_EditTouch:(NSInteger)tag
{
    NSString * str1 = [NSString stringWithFormat:@"%ld",tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
        NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
//    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressDetailViewController *Avc=[main instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    Avc.GXFlag = 1;
     AddressListMode * mode = arrListTitle[[str2 integerValue]];
    Avc.ListMode = mode;
    [self.navigationController pushViewController:Avc animated:YES];
}

@end
