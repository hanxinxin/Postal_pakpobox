//
//  ComDetailInfoViewController.m
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ComDetailInfoViewController.h"
#import "DInfoTableViewCell.h"
#import "TextTableViewCell.h"
#import "AddressDetailViewController.h"
#import "HomeViewController.h"

#define TableID @"TextTableViewCell"
#define TableDInfoID @"DInfoTableViewCell"

@interface ComDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TextTableViewCellDelegate,DInfoTableViewCellDelegate>
{
    
}

@end

@implementation ComDetailInfoViewController
@synthesize TableView,modeDD,arrListTitle,HeaderArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
//    arrListTitle = [NSMutableArray arrayWithCapacity:0];
    arrListTitle=@[@"Letter Number",@"Sender",@"Receiver"];
    HeaderArr=@[@"Letter Number",@"Sender",@"Receiver"];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"Detail Info", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    TableView.hidden = YES;
    [HudViewFZ labelExample:self.view];
    [self getPostListInfo];
    if(self.returnfalg==0)
    {
        
    }else if(self.returnfalg==1)
    {
        NSLog(@"不能直接返回上一级页面");
            if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            };
    }
    
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
    if(self.returnfalg==0)
    {
        
    }else if(self.returnfalg==1)
    {
    NSLog(@"重置密码返回啦");
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HomeViewController class]]) {
            //            [Manager.inst disconnect];
            [self.navigationController popToViewController:temp animated:YES];
            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
            
        }
    }
    }
    return YES;
}
-(void)getPostListInfo
{
    NSLog(@"URL === %@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Get_DaiListInfo,self.orderIDStr]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Get_DaiListInfo,self.orderIDStr] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"Get_DaiListInfo = %@",responseObject);
        NSDictionary * dictZ = (NSDictionary*)responseObject;
        [HudViewFZ HiddenHud];
        NSDictionary * dictF1 = [dictZ objectForKey:@"senderAddress"];
        NSDictionary * dictF2 = [dictZ objectForKey:@"receiverAddress"];
        self->modeDD = [[DetaInfoMode alloc] init];
        self->modeDD.ordersId = [dictZ objectForKey:@"ordersId"];
        self->modeDD.ordersNumber = [dictZ objectForKey:@"ordersNumber"];
        self->modeDD.ordersType = [dictZ objectForKey:@"ordersType"];
        self->modeDD.senderAddress  = [self returnMode:dictF1];
        self->modeDD.receiverAddress = [self returnMode:dictF2];
        self.senderAddress = self->modeDD.senderAddress;
        self.receiverAddress = self->modeDD.receiverAddress;
        if(self.senderAddress!=nil)
        {
            [self tableviewSet];
        }
        [self->TableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        
    }];
}
-(AddressInfoMode *)returnMode:(NSDictionary *)dictF1{
    AddressInfoMode * mode = [[AddressInfoMode alloc] init];
    mode.addressFullName = [dictF1 objectForKey:@"addressFullName"];
    mode.addressLine1 = [dictF1 objectForKey:@"addressLine1"];
    mode.addressLine2 = [dictF1 objectForKey:@"addressLine2"];
    mode.country = [dictF1 objectForKey:@"country"];
    mode.countryCallingCode = [dictF1 objectForKey:@"countryCallingCode"];
    mode.mobile = [dictF1 objectForKey:@"mobile"];
    mode.ordersAddressId = [dictF1 objectForKey:@"ordersAddressId"];
    mode.postalCode = [dictF1 objectForKey:@"postalCode"];
    return mode;
}
/**
 创建tableview
 */
-(void)tableviewSet
{
    TableView.hidden = NO;
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
    
    [TableView registerNib:[UINib nibWithNibName:@"TextTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableID];
    [TableView registerNib:[UINib nibWithNibName:@"DInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableDInfoID];
    
    [self.view addSubview:TableView];
    
        
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
//    return arrListTitle.count;
    
    return arrListTitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString * cellID = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    //根据identify在缓存的字典中找是否有已经初始化好的cell
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableID];
    if (!cell) {
        cell= (TextTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TextTableViewCell" owner:self options:nil]  lastObject];
    }
    //    NSLog(@"ACCCCCCC == %ld",indexPath.section);
//    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
//    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
//    lbl.backgroundColor =  [UIColor clearColor];
//    [cell.contentView addSubview:lbl];
    
    cell.backgroundColor = [UIColor whiteColor];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.LeftTitle.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1.0];
    cell.LeftTitle.text = self.arrListTitle[indexPath.section];
    cell.delegate = self;
    cell.tag = [[NSString stringWithFormat:@"800%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
    if(indexPath.section == 0)
    {
        cell.RightField.userInteractionEnabled=NO;
        if(modeDD != nil)
        {
            cell.RightField.text = modeDD.ordersNumber;
        }
    }
    if(indexPath.section>0 )
    {
        DInfoTableViewCell *cellMobile = (DInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableDInfoID];
        if (cellMobile == nil) {
            cellMobile= (DInfoTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"DInfoTableViewCell" owner:self options:nil]  lastObject];
        }
//        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
//        lbl.frame = CGRectMake(16 , 0, cellMobile.width-16*2, 1);
//        lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
//        [cellMobile.contentView addSubview:lbl];
        cellMobile.tag = [[NSString stringWithFormat:@"500%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
        cellMobile.delegate = self;
        if(indexPath.section==1)
        {
            if(self.senderAddress!=nil)
            {
                cellMobile.TopL_title.text = self.senderAddress.addressFullName;
                cellMobile.TopC_title.text = self.senderAddress.mobile;
                cellMobile.Down_Title.text = [NSString stringWithFormat:@"%@ %@",self.senderAddress.addressLine1,self.senderAddress.addressLine2];
            }
        }else if(indexPath.section==2)
        {
            if(self.receiverAddress!=nil)
            {
                cellMobile.TopL_title.text = self.receiverAddress.addressFullName;
                cellMobile.TopC_title.text = self.receiverAddress.mobile;
                cellMobile.Down_Title.text = [NSString stringWithFormat:@"%@ %@",self.receiverAddress.addressLine1,self.receiverAddress.addressLine2];
            }
        }
        cellMobile.selectionStyle = UITableViewCellSelectionStyleNone;
        cellMobile.layer.cornerRadius = 20;
        return cellMobile;
    }
    cell.layer.cornerRadius = 20;
    return cell;
}

//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.f;
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
    UILabel * lab = [[UILabel alloc] init];
    if(section<4)
    {
        lab.text = HeaderArr[section];
    }
    lab.frame = view_c.frame;
    lab.font = [UIFont systemFontOfSize:11.f];
    lab.textColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0];
    [view_c addSubview:lab];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section>0)
    {
        return 100;
    }
    return 50;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MMMMM === %ld",indexPath.section);
    //        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        CollViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CollViewController"];
    //        Avc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:Avc animated:YES];
    
}

-(void)push_EditTouch:(NSInteger)tag
{
    NSLog(@"Celltag=  %ld",(long)tag);
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressDetailViewController *Avc=[main instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    Avc.GXFlag = 2;
    if(tag == 50010)
    {
        Avc.addressMode = self.senderAddress;
    }else if(tag == 50020)
    {
        
        Avc.addressMode = self.receiverAddress;
    }
//    Avc.ordersAddressIdSSS =self.modeDD.ordersId;
    [self.navigationController pushViewController:Avc animated:YES];
}


- (void)returnRightField:(nonnull NSString *)RightFieldStr TagStr:(NSInteger)tag {
    
}



@end
