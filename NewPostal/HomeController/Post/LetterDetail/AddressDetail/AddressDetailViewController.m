//
//  AddressDetailViewController.m
//  NewPostal
//
//  Created by mac on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "TextTableViewCell.h"
#import "LetterNameTableViewCell.h"
#import "LetterMobileTableViewCell.h"
#import "LZPickerView.h"
#import "ComDetailInfoViewController.h"
#import "CityListViewController.h"

#define TableID @"TextTableViewCell"
//#define TableNameID @"LetterNameTableViewCell"
#define TableMobileID @"LetterMobileTableViewCell"
@interface AddressDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,LetterMobileTableViewCellDelegate,TextTableViewCellDelegate,LetterNameTableViewCellDelegate>
{
    NSInteger indexRowtag;
}
@property (nonatomic, strong) NSMutableArray * CountryArr;
@property (nonatomic, strong) NSMutableArray * MobileArr;
@end

@implementation AddressDetailViewController
@synthesize TableView,arrListTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    arrListTitle = [NSMutableArray arrayWithCapacity:0];
//    [arrListTitle addObject:@[@"Name",@"Mobile",@"Country",@"Address line 1",@"Address line 1",@"Postal Code"]];
    [arrListTitle addObject:@[@"Recipient Name",@"Country",@"Postal Code",@"Block/House No.",@"Street Name",@"Floor-Unit",@"Building Name"]];
    indexRowtag=0;
    
    self.CountryArr = [NSMutableArray arrayWithCapacity:0];
    self.MobileArr = [NSMutableArray arrayWithCapacity:0];
    if(self.GXFlag==0)
    {
        self.ListMode = [[AddressListMode alloc] init];
    }else if(self.GXFlag==1)
    {
    }else if(self.GXFlag==2)
    {
        [self setModeValue];
    }
    [self tableviewSet];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
    [self.view addGestureRecognizer:tapGesture];
    [self getListView];
    [self AddNotification];
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"Add address", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillDisappear:animated];
}
-(void)AddNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification
                                              object:nil];
}
-(void)keyboardWillShow:(NSNotification*)note
{
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=12.0) {
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    TableView.contentInset = UIEdgeInsetsMake(0,0,keyBoardRect.size.height+8,0);
    //        [TableView setContentOffset:CGPointMake(0, keyBoardRect.size.height+8)];
    //    }
    
}

//pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification*)note
{
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=12.0) {
    TableView.contentInset = UIEdgeInsetsZero;
    //        CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //        [TableView setContentOffset:CGPointMake(0, keyBoardRect.size.height)];
    
    
    //    }
    
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"touch.view =%@",NSStringFromClass([touch.view class]));
    if ([touch.view isKindOfClass:[UIButton class]]) {
        //放过button点击拦截
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        return NO;
    }
    else if ([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]) {
        NSLog(@"touch.view =====  %ld",touch.view.tag);
        indexRowtag = touch.view.tag; ////赋值tag 以便后面判断
        //放过UITableView点击拦截
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        return NO;
    }
    return YES;
}
/**
 上传地址信息
 @"addressFullName":self.ListMode.addressFullName,
 @"countryCallingCode":self.ListMode.countryCallingCode,
 @"mobile":self.ListMode.mobile,
 @"country":self.ListMode.country,
 @"addressLine1":self.ListMode.addressLine1,
 @"addressLine2":self.ListMode.addressLine2,
 @"postalCode":self.ListMode.postalCode,
 @param sender button
 */
- (IBAction)AddNewTouch:(id)sender {
    [HudViewFZ labelExample:self.view];
    if(![self.ListMode.addressFullName isEqualToString:@""] && self.ListMode.addressFullName!=nil)
    {
        if(![self.ListMode.countryCallingCode isEqualToString:@""] && self.ListMode.countryCallingCode!=nil)
        {
            if(![self.ListMode.mobile isEqualToString:@""] && self.ListMode.mobile!=nil)
            {
                if(![self.ListMode.country isEqualToString:@""] && self.ListMode.country!=nil)
                {
                    if(![self.ListMode.addressLine1 isEqualToString:@""] && self.ListMode.addressLine1!=nil)
                    {
                        if(![self.ListMode.addressLine2 isEqualToString:@""] && self.ListMode.addressLine2!=nil)
                        {
                            if(![self.ListMode.postalCode isEqualToString:@""] && self.ListMode.postalCode!=nil)
                            {
                                [self PostDict];
                            }else
                            {
                                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Zip code cannot be empty", @"Language") andDelay:2.0];
                            }
                        }else
                        {
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address 2 cannot be empty", @"Language") andDelay:2.0];
                        }
                    }else
                    {
                        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address 1 cannot be empty", @"Language") andDelay:2.0];
                    }
                }else
                {
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Country cannot be empty", @"Language") andDelay:2.0];
                }
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Mobile cannot be empty", @"Language") andDelay:2.0];
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Country Calling Code cannot be empty", @"Language") andDelay:2.0];
        }
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Name cannot be empty", @"Language") andDelay:2.0];
    }
}

-(void)PostDict
{
    if(self.GXFlag==0)
    {
        [self Xinjian_post_addressMode];
    }else if(self.GXFlag==1)
    {
        [self Xiugai_post_addressMode];
    }else if(self.GXFlag==2)
    {
        [self Update_post_addressMode];
    }
}

-(void)setModeValue
{
    if(self.addressMode != nil)
    {
        self.ListMode = [[AddressListMode alloc] init];
        self.ListMode.addressFullName=self.addressMode.addressFullName;
        self.ListMode.countryCallingCode=self.addressMode.countryCallingCode;
        self.ListMode.mobile=self.addressMode.mobile;
        self.ListMode.country=self.addressMode.country;
        self.ListMode.addressLine1=self.addressMode.addressLine1;
        self.ListMode.addressLine2=self.addressMode.addressLine2;
        self.ListMode.postalCode=self.addressMode.postalCode;
        self.ListMode.userAddressId = self.addressMode.ordersAddressId;
    }
}

-(void)Xinjian_post_addressMode
{
    NSDictionary *dict = @{ @"addressFullName":self.ListMode.addressFullName,
                            @"countryCallingCode":self.ListMode.countryCallingCode,
                            @"mobile":self.ListMode.mobile,
                            @"country":self.ListMode.country,
                            @"addressLine1":self.ListMode.addressLine1,
                            @"addressLine2":self.ListMode.addressLine2,
                            @"postalCode":self.ListMode.postalCode,
                            };
    NSLog(@"dict ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_address] parameters:dict progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"postParcel====  %@",responseObject);
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Add address successfully", @"Language") andDelay:2.0];
        [self popViewController];
    } failure:^(NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}
-(void)Xiugai_post_addressMode
{
    NSDictionary *dict = @{ @"userAddressId":self.ListMode.userAddressId,
                            @"addressFullName":self.ListMode.addressFullName,
                            @"countryCallingCode":self.ListMode.countryCallingCode,
                            @"mobile":self.ListMode.mobile,
                            @"country":self.ListMode.country,
                            @"addressLine1":self.ListMode.addressLine1,
                            @"addressLine2":self.ListMode.addressLine2,
                            @"postalCode":self.ListMode.postalCode,
                            };
    NSLog(@"dict ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_addressUpdate] parameters:dict progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"postParcel====  %@",responseObject);
        
        NSDictionary * dict = (NSDictionary*)responseObject;
        NSNumber * result = [dict objectForKey:@"result"];
        if([result integerValue]==1)
        {
           [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address updated successfully", @"Language") andDelay:2.0];
            [self popViewController];
        }
    } failure:^(NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}
-(void)Update_post_addressMode
{
    NSDictionary *dict = @{ @"ordersAddressId":self.ListMode.userAddressId,
                            @"addressFullName":self.ListMode.addressFullName,
                            @"countryCallingCode":self.ListMode.countryCallingCode,
                            @"mobile":self.ListMode.mobile,
                            @"country":self.ListMode.country,
                            @"addressLine1":self.ListMode.addressLine1,
                            @"addressLine2":self.ListMode.addressLine2,
                            @"postalCode":self.ListMode.postalCode,
                            };
    NSLog(@"dict ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_updateJJAddress] parameters:dict progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"postParcel====  %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dict = (NSDictionary*)responseObject;
        NSNumber * result = [dict objectForKey:@"result"];
        if([result integerValue]==1)
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Address updated successfully", @"Language") andDelay:2.0];
            [self popViewController];
        }
    } failure:^(NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}

-(void)popViewController
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.00/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [HudViewFZ HiddenHud];
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
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
    
    [TableView registerNib:[UINib nibWithNibName:@"TextTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableID];
//    [TableView registerNib:[UINib nibWithNibName:@"LetterNameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableNameID];
    [TableView registerNib:[UINib nibWithNibName:@"LetterMobileTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableMobileID];
    //    self.tableViewD.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    // 进入刷新状态后会自动调用这个block
    //    }];
    // 或
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，也就是调用 self 的 loadNewData 方法）
    //    self.tableViewD.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //    self.tableViewD.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFootData)];
    // 马上进入刷新状态
    //    [self.tableViewTop.mj_header beginRefreshing];
    [self.view addSubview:TableView];
    //    self.CompleteB.frame=CGRectMake(15, TableView.height-50, SCREEN_WIDTH-30, 50);
    self.AddNewBtn.layer.cornerRadius = 25;
    [self.view addSubview:self.AddNewBtn];
    
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
    NSArray * arr = arrListTitle[section];
    return arr.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return arrListTitle.count;
    
    return arrListTitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellID = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    //    static NSString *cellID = str;
    //根据identify在缓存的字典中找是否有已经初始化好的cell
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell= (TextTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"TextTableViewCell" owner:self options:nil]  lastObject];
    }
    //    NSLog(@"ACCCCCCC == %ld",indexPath.section);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor clearColor];
    if(indexPath.row!=0)
    {
    [cell.contentView addSubview:lbl];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * titlearr = self.arrListTitle[indexPath.section];
    
    cell.LeftTitle.text = titlearr[indexPath.row];
    if(self.ListMode!=nil)
    {
        if(indexPath.row==0)
        {
         cell.RightField.text = self.ListMode.addressFullName;
        }else if(indexPath.row==2)
        {
            cell.RightField.text = self.ListMode.country;
        }else if(indexPath.row==3)
        {
            cell.RightField.text = self.ListMode.addressLine1;
        }else if(indexPath.row==4)
        {
            cell.RightField.text = self.ListMode.addressLine2;
        }else if(indexPath.row==5)
        {
            cell.RightField.text = self.ListMode.postalCode;
        }
    }
    cell.delegate = self;
    cell.tag = [[NSString stringWithFormat:@"600%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
    cell.contentView.tag = [[NSString stringWithFormat:@"600%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
        if(indexPath.row!=0)
        {
            UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
            lbl.frame = CGRectMake(16 , 0, cell.width-16*2, 1);
            lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
            [cell.contentView addSubview:lbl];
            /*
            if(indexPath.row==1)
            {
                LetterMobileTableViewCell *cellMobile = (LetterMobileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableMobileID];
                if (cellMobile == nil) {
                    cellMobile= (LetterMobileTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LetterMobileTableViewCell" owner:self options:nil]  lastObject];
                }
                UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                lbl.frame = CGRectMake(16 , 0, cellMobile.width-16*2, 1);
                lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
                [cellMobile.contentView addSubview:lbl];
                cellMobile.tag = [[NSString stringWithFormat:@"200%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
                cellMobile.delegate = self;
                cellMobile.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cellMobile.centerB setImage:[UIImage imageNamed:@"icon_nextDown"] forState:(UIControlStateNormal)];
                cellMobile.centerB.titleEdgeInsets = UIEdgeInsetsMake(0, -(cellMobile.centerB.imageView.width), 0, (cellMobile.centerB.imageView.width));
                cellMobile.centerB.imageEdgeInsets = UIEdgeInsetsMake(0, (cellMobile.centerB.titleLabel.width)+8, 0, -(cellMobile.centerB.titleLabel.width));
                cellMobile.RightField.keyboardType = UIKeyboardTypeNumberPad;
                cellMobile.LeftTitle.text = titlearr[indexPath.row];
                if(self.ListMode!=nil)
                {
                    cellMobile.RightField.text = self.ListMode.mobile;
                    if(self.ListMode.countryCallingCode!=nil)
                    {
                        [cellMobile.centerB setTitle:self.ListMode.countryCallingCode forState:(UIControlStateNormal)];
                        
                    }else
                    {
                        self.ListMode.countryCallingCode = @"+86";
                        [cellMobile.centerB setTitle:self.ListMode.countryCallingCode forState:(UIControlStateNormal)];
                    }
                }else
                {
//                    [cellMobile.centerB setTitle:@"+65" forState:(UIControlStateNormal)];
                    [cellMobile.centerB setTitle:self.ListMode.countryCallingCode forState:(UIControlStateNormal)];
                }
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    cellMobile.RightField.frame = CGRectMake(cellMobile.LeftTitle.right+8, 5, cellMobile.width-cellMobile.LeftTitle.right-cellMobile.accessoryView.width, 39);
                });
                return cellMobile;
            }else
                */
                if(indexPath.row==1)
            {
                cell.RightField.userInteractionEnabled=NO;
                if(self.ListMode!=nil)
                {
                    cell.RightField.text=self.ListMode.country;
                }else
                {
                    cell.RightField.text=@"Singapore";
                }
                cell.RightField.textColor = [UIColor colorWithRed:20/255.0 green:146/255.0 blue:230/255.0 alpha:1.0];
                UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nextDown"]];
                cell.accessoryView = accessoryImgView;
            }
        }
        if(indexPath.row==0 || indexPath.row==6)
        {
            if(indexPath.row==0)
            {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = cell.bounds;
                    maskLayer.path = maskPath.CGPath;
                    cell.layer.mask = maskLayer;
                });
                NSLog(@"indexPath.row2222=== %ld",(long)indexPath.row);
            }else if(indexPath.row==6)
            {
                NSLog(@"indexPath.row111=== %ld",(long)indexPath.row);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = cell.bounds;
                    maskLayer.path = maskPath.CGPath;
                    cell.layer.mask = maskLayer;
                    cell.RightField.keyboardType = UIKeyboardTypeNumberPad;
                });
            }
        }
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
    view_c.frame=CGRectMake(16, 7,SCREEN_WIDTH-16, 15);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //    view_c.backgroundColor=[UIColor whiteColor];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"MMMMM === %ld",indexPath.section);
    //        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        CollViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CollViewController"];
    //        Avc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:Avc animated:YES];
    /*
    if(indexPath.row==2 || indexPath.row==1)
    {
        LetterMobileTableViewCell * cell = (LetterMobileTableViewCell*)[TableView cellForRowAtIndexPath:indexPath];
//        NSLog(@"cell.tag======   %ld   contentView.tag= %ld",(long)cell.tag, (long)cell.contentView.tag);
        if(cell.contentView.tag == indexRowtag)
        {
        [self addLZPickerView:self.CountryArr ViewTag:[[NSString stringWithFormat:@"200%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue]];
        }
    }
     */
    if(indexPath.row==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CityListViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CityListViewController"];
        Avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Avc animated:YES];
    }
}

#pragma mark ----------
-(void)push_btnTouch:(NSInteger)tag
{
//    [self addLZPickerView:self.MobileArr ViewTag:tag];
        [self addLZPickerView:self.MobileArr ViewTag:tag];
}

- (void)returnFieldStr:(nonnull NSString *)RightFieldStr TagStr:(NSInteger)tag {
    NSLog(@"RightFieldStr===  %@",RightFieldStr);
    NSString * str1 = [NSString stringWithFormat:@"%ld",(long)tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
//    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[str3 integerValue] inSection:[str2 integerValue]];
    if([str3 integerValue]==1)
    {
        self.ListMode.mobile = RightFieldStr;
    }
}
-(void)returnRightField:(NSString * )RightFieldStr TagStr:(NSInteger)tag
{
    NSLog(@"returnRightField===  %@",RightFieldStr);
    NSString * str1 = [NSString stringWithFormat:@"%ld",(long)tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
//    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[str3 integerValue] inSection:[str2 integerValue]];
        if([str3 integerValue] == 0)
        {
        self.ListMode.addressFullName = RightFieldStr;
        }else if([str3 integerValue] == 2)
        {
            self.ListMode.country = RightFieldStr;
        }else if([str3 integerValue] == 3)
        {
            self.ListMode.addressLine1 = RightFieldStr;
        }else if([str3 integerValue] == 4)
        {
            self.ListMode.addressLine2 = RightFieldStr;
        }else if([str3 integerValue] == 5)
        {
            self.ListMode.postalCode = RightFieldStr;
        }
    
}


- (void)AddressInfo:(NSInteger)tag {
    
}


-(void)addLZPickerView:(NSMutableArray * )arr ViewTag:(NSInteger)tag
{
    NSLog(@"LZPickerViewTag==== %ld",(long)tag);
    NSString * str1 = [NSString stringWithFormat:@"%ld",(long)tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[str3 integerValue] inSection:[str2 integerValue]];
    if(tag==20001)
    {
        LetterMobileTableViewCell * cell = (LetterMobileTableViewCell*)[TableView cellForRowAtIndexPath:indexPath];/////找到要修改的cell
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LZPickerView" owner:nil options:nil];
        LZPickerView * lzPickerVIew  = views[0];
        [lzPickerVIew lzPickerVIewType:LZPickerViewTypeSexAndHeight];
        lzPickerVIew.dataSource = arr;
        lzPickerVIew.titleText = @"";
        //    self.lzPickerVIew.selectDefault = text;
        lzPickerVIew.selectValue  = ^(NSString *value){
            NSLog(@"Select = %@",value);
            [cell.centerB setTitle:[NSString stringWithFormat:@"+%@",value] forState:(UIControlStateNormal)];
            self.ListMode.countryCallingCode =  [NSString stringWithFormat:@"+%@",value];
        };
        [lzPickerVIew show];
    }else if(tag==20002)
    {
        TextTableViewCell * cell = (TextTableViewCell*)[TableView cellForRowAtIndexPath:indexPath];/////找到要修改的cell
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LZPickerView" owner:nil options:nil];
        LZPickerView * lzPickerVIew  = views[0];
        [lzPickerVIew lzPickerVIewType:LZPickerViewTypeSexAndHeight];
        lzPickerVIew.dataSource = arr;
        lzPickerVIew.titleText = @"";
        //    self.lzPickerVIew.selectDefault = text;
        lzPickerVIew.selectValue  = ^(NSString *value){
            NSLog(@"Select = %@",value);
            cell.RightField.text = value;
            self.ListMode.country = value;
        };
        [lzPickerVIew show];
    }
}


-(void)getListView
{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"AreaCode"ofType:@"plist"];
    //        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * arr = [NSArray arrayWithContentsOfFile:plistPath];
    [self.CountryArr removeAllObjects];
    [self.MobileArr removeAllObjects];
    NSArray * arrKey = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"Y",@"Z"];
    for (int i=0; i<arr.count; i++) {
        NSLog(@"arrr==== %d",i);
        NSDictionary * DicCountry = arr[i];
        NSArray * arrA = [DicCountry objectForKey:arrKey[i]];
        for (int b=0; b<arrA.count; b++) {
            NSDictionary * DicCountry1 = arrA[b];
//            NSLog(@"arrrbbb==== %d",b);
            [self.CountryArr addObject:[DicCountry1 objectForKey:@"Name"]];
            [self.MobileArr addObject:[DicCountry1 objectForKey:@"Number"]];
        }
        //            [self.CountryArr addObject:arrcountry[0]];
        //            [self.MobileArr addObject:arrcountry[1]];
    }
}

@end
