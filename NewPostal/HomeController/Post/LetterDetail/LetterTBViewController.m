//
//  LetterTBViewController.m
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LetterTBViewController.h"
#import "TextTableViewCell.h"
#import "LetterNameTableViewCell.h"
#import "LetterMobileTableViewCell.h"
#import "LZPickerView.h"
#import "ComDetailInfoViewController.h"
#import "AddressInfoViewController.h"
#import "PostSGQViewController.h"
#import "CityListViewController.h"

#define TableID @"TextTableViewCell"
#define TableNameID @"LetterNameTableViewCell"
#define TableMobileID @"LetterMobileTableViewCell"

@interface LetterTBViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,LetterMobileTableViewCellDelegate,TextTableViewCellDelegate,LetterNameTableViewCellDelegate,AddressInfoViewControllerDelegate,CityListViewControllerDelegate>
{
    NSInteger indexRowtag;
}
@property (nonatomic, strong) NSMutableArray * arrListTitle;
@property (nonatomic, strong) NSArray * HeaderArr;

@property (nonatomic, strong) NSMutableArray * CountryArr;
@property (nonatomic, strong) NSMutableArray * MobileArr;

@end

@implementation LetterTBViewController
@synthesize TableView,HeaderArr,arrListTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    arrListTitle = [NSMutableArray arrayWithCapacity:0];
    self.CountryArr = [NSMutableArray arrayWithCapacity:0];
    self.MobileArr = [NSMutableArray arrayWithCapacity:0];
    indexRowtag=0;
    self.addressSender = [[AddressInfoMode alloc] init];
    self.addressSender.countryCallingCode =@"+86";
    self.addressSender.country =@"Singapore";
    self.addressReceiver = [[AddressInfoMode alloc] init];
    self.addressReceiver.countryCallingCode =@"+86";
    self.addressReceiver.country =@"Singapore";
    [arrListTitle addObject:@[@"Item Number"]];
//    [arrListTitle addObject:@[@"Type"]];
    [arrListTitle addObject:@[@"Sender Name",@"Postal Code",@"Block/House No.",@"Street Name",@"Floor-Unit",@"Building Name"]];
    [arrListTitle addObject:@[@"Recipient Name",@"Country",@"Postal Code",@"Block/House No.",@"Street Name",@"Floor-Unit",@"Building Name"]];
    [arrListTitle addObject:@[@"Complete"]];
    HeaderArr = @[@"Item Number",@"Sender",@"Recipient Details"];
//    self.ItemNumber = @"";
    self.PostType = @"LETTER";
    [self setAddressInfo];
    [self tableviewSet];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView =NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。//点击空白处取消TextField的第一响应
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
    self.title=FGGetStringWithKeyFromTable(@"To Post", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
//    [self.TableView reloadData];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [super viewWillDisappear:animated];
}
-(void)setAddressInfo
{
    self.addressSender = [[AddressInfoMode alloc] init];
    self.addressSender.Type = @"Sender";
    self.addressReceiver = [[AddressInfoMode alloc] init];
    self.addressReceiver.Type = @"Receiver";
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
//    NSLog(@"touch.view =%@",NSStringFromClass([touch.view class]));
    if ([touch.view isKindOfClass:[UIButton class]]) {
        //放过button点击拦截
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        return NO;
    }
    else if ([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]) {
//        NSLog(@"touch.view =====  %ld",touch.view.tag);
        indexRowtag = touch.view.tag; ////赋值tag 以便后面判断
        //放过UITableView点击拦截
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        return NO;
    }
    return YES;
}

- (IBAction)CompleteTouch:(id)sender {
    NSLog(@"Complete");
    if([self isEqualsenderMode] && [self isEqualreceiver])
    {
        [self PostCreate];
    }
}



-(void)PostCreate
{
    NSDictionary *senderAddress = @{
      @"addressFullName": self.addressSender.addressFullName,
      @"countryCallingCode": self.addressSender.countryCallingCode,
      @"mobile": self.addressSender.mobile,
      @"country": self.addressSender.country,
      @"addressLine1": self.addressSender.addressLine1,
      @"addressLine2": self.addressSender.addressLine2,
      @"postalCode": self.addressSender.postalCode
                                };
    NSDictionary *receiverAddress = @{
      @"addressFullName": self.addressReceiver.addressFullName,
      @"countryCallingCode": self.addressReceiver.countryCallingCode,
      @"mobile": self.addressReceiver.mobile,
      @"country": self.addressReceiver.country,
      @"addressLine1": self.addressReceiver.addressLine1,
      @"addressLine2": self.addressReceiver.addressLine2,
      @"postalCode": self.addressReceiver.postalCode
                                };
    NSDictionary *dictZ = @{ @"ordersNumber":self.ItemNumber,
                            @"ordersType":self.PostType,
                            @"senderAddress":senderAddress,
                            @"receiverAddress":receiverAddress,
                            };
    NSLog(@"dict ====%@",dictZ);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_createOrder] parameters:dictZ progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"postParcel====  %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dictObject = responseObject;
        NSString * strID = [dictObject objectForKey:@"result"];
        if(strID!=nil)
        {
            [self addPostCreate_push:strID];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
    }];
}
-(void)addPostCreate_push:(NSString*)StrID
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComDetailInfoViewController *Avc=[main instantiateViewControllerWithIdentifier:@"ComDetailInfoViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    Avc.returnfalg = 1;
    Avc.orderIDStr = StrID;
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
    TableView.tag = 9527;
//    TableView.estimatedRowHeight = 0;
//    TableView.estimatedSectionHeaderHeight = 0;
//    TableView.estimatedSectionFooterHeight = 0;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //    DownTableview.backgroundColor = [UIColor whiteColor];
    
    [TableView registerNib:[UINib nibWithNibName:@"TextTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableID];
    [TableView registerNib:[UINib nibWithNibName:@"LetterNameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TableNameID];
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
//    self.CompleteB.layer.cornerRadius = 20;
//    [TableView addSubview:self.CompleteB];
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
    NSArray * arr  = arrListTitle[section];
    return arr.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrListTitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString * cellID = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
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
    [cell.contentView addSubview:lbl];
    
    cell.backgroundColor = [UIColor whiteColor];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * titlearr = self.arrListTitle[indexPath.section];
    
    cell.LeftTitle.text = titlearr[indexPath.row];
    cell.delegate = self;
    cell.tag = [[NSString stringWithFormat:@"300%ld%ld",indexPath.section,indexPath.row] integerValue];
    cell.contentView.tag = [[NSString stringWithFormat:@"300%ld%ld",indexPath.section,indexPath.row] integerValue];
    if(indexPath.section==1 || indexPath.section==2)
    {
        if(indexPath.section==1)
        {
        if(self.addressSender!=nil)
        {
            if(indexPath.row==2)
            {
//                cell.RightField.text = self.addressSender.country;
            }else if(indexPath.row==3)
            {
                cell.RightField.text = self.addressSender.addressLine1;
            }else if(indexPath.row==4)
            {
                cell.RightField.text = self.addressSender.addressLine2;
            }else if(indexPath.row==5)
            {
                cell.RightField.text = self.addressSender.postalCode;
            }
        }
        }else if(indexPath.section==2)
        {
                if(self.addressReceiver!=nil)
                {
                    if(indexPath.row==2)
                    {
//                        cell.RightField.text = self.addressReceiver.country;
                    }else if(indexPath.row==3)
                    {
                        cell.RightField.text = self.addressReceiver.addressLine1;
                    }else if(indexPath.row==4)
                    {
                        cell.RightField.text = self.addressReceiver.addressLine2;
                    }else if(indexPath.row==5)
                    {
                        cell.RightField.text = self.addressReceiver.postalCode;
                    }
                }
        }
        if(indexPath.row!=0)
        {
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(16 , 0, cell.width-16*2, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [cell.contentView addSubview:lbl];
            if(indexPath.section==2 && indexPath.row==1)
            {
                LetterMobileTableViewCell *cellMobile = (LetterMobileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableMobileID];
                if (cellMobile == nil) {
                    cellMobile= (LetterMobileTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LetterMobileTableViewCell" owner:self options:nil]  lastObject];
                }
                UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                lbl.frame = CGRectMake(16 , 0, cellMobile.width-16*2, 1);
                lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
                [cellMobile.contentView addSubview:lbl];
                cellMobile.tag = [[NSString stringWithFormat:@"200%ld%ld",indexPath.section,indexPath.row] integerValue];
                cellMobile.delegate = self;
                cellMobile.selectionStyle = UITableViewCellSelectionStyleNone;
//                [cellMobile.centerB setTitle:@"+65" forState:(UIControlStateNormal)];
//                [cellMobile.centerB setTitle:self.addressSender.countryCallingCode forState:(UIControlStateNormal)];
                if(indexPath.section==1)
                {
                    
                    if(self.addressSender.countryCallingCode!=nil)
                    {
                        cellMobile.RightField.text = self.addressSender.mobile;
                        [cellMobile.centerB setTitle:self.addressSender.countryCallingCode forState:(UIControlStateNormal)];
                    }else
                    {
                        self.addressSender.countryCallingCode = @"+86";
                        [cellMobile.centerB setTitle:self.addressSender.countryCallingCode forState:(UIControlStateNormal)];
                    }
                }else if (indexPath.section==2)
                {
                    if(self.addressReceiver.countryCallingCode!=nil)
                    {
                        cellMobile.RightField.text = self.addressReceiver.mobile;
                        [cellMobile.centerB setTitle:self.addressReceiver.countryCallingCode forState:(UIControlStateNormal)];
                    }else
                    {
                        self.addressReceiver.countryCallingCode = @"+86";
                        [cellMobile.centerB setTitle:self.addressReceiver.countryCallingCode forState:(UIControlStateNormal)];
                    }
                }
                cellMobile.RightField.text=self.addressReceiver.country;;
                cellMobile.RightField.textColor = [UIColor colorWithRed:20/255.0 green:146/255.0 blue:230/255.0 alpha:1.0];
                [cellMobile.centerB setImage:[UIImage imageNamed:@"icon_nextDown"] forState:(UIControlStateNormal)];
                cellMobile.centerB.titleEdgeInsets = UIEdgeInsetsMake(0, -(cellMobile.centerB.imageView.width), 0, (cellMobile.centerB.imageView.width));
                cellMobile.centerB.imageEdgeInsets = UIEdgeInsetsMake(0, (cellMobile.centerB.titleLabel.width)+8, 0, -(cellMobile.centerB.titleLabel.width));
                cellMobile.RightField.keyboardType = UIKeyboardTypeNumberPad;
                cellMobile.LeftTitle.text = titlearr[indexPath.row];
                cellMobile.RightField.userInteractionEnabled = NO;
                UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nextDown"]];
                cellMobile.accessoryView = accessoryImgView;
                return cellMobile;
            }
            /*else if(indexPath.row==2)
            {
                UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nextDown"]];
                cell.accessoryView = accessoryImgView;
            }*/
        }
        if(indexPath.section==1)
        {
        if(indexPath.row==0 || indexPath.row==5)
        {
            if(indexPath.row==0)
            {
            LetterNameTableViewCell *cellName = (LetterNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableNameID];
            if (cellName == nil) {
                cellName= (LetterNameTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LetterNameTableViewCell" owner:self options:nil]  lastObject];
            }
                UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                lbl.frame = CGRectMake(16 , 0, cellName.width-16*2, 1);
                lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
                [cellName.contentView addSubview:lbl];
                cellName.tag = [[NSString stringWithFormat:@"400%ld%ld",indexPath.section,indexPath.row] integerValue];
                cellName.delegate = self;
                cellName.selectionStyle = UITableViewCellSelectionStyleNone;
            cellName.LeftTitle.text = titlearr[indexPath.row];
                [cellName.phoneImage setImage:[UIImage imageNamed:@"icon_tongxunlu"] forState:(UIControlStateNormal)];
                if(indexPath.section==2)
                { if(self.addressSender!=nil)
                 {
                    cellName.RightField.text = self.addressSender.addressFullName;
                 }
                
                }else if(indexPath.section==3)
                { if(self.addressReceiver!=nil)
                {
                    cellName.RightField.text = self.addressReceiver.addressFullName;
                }
                }
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellName.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = cellName.bounds;
                maskLayer.path = maskPath.CGPath;
                cellName.layer.mask = maskLayer;
                });
            NSLog(@"indexPath.row2222=== %ld",(long)indexPath.row);
            return cellName;
            }else if(indexPath.row==5)
            {
                NSLog(@"indexPath.row111=== %ld",(long)indexPath.row);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = cell.bounds;
                    maskLayer.path = maskPath.CGPath;
                    cell.layer.mask = maskLayer;
                });
                cell.RightField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
        }else if (indexPath.section==2)
        {
            if(indexPath.row==0 || indexPath.row==6)
            {
                if(indexPath.row==0)
                {
                LetterNameTableViewCell *cellName = (LetterNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableNameID];
                if (cellName == nil) {
                    cellName= (LetterNameTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LetterNameTableViewCell" owner:self options:nil]  lastObject];
                }
                    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                    lbl.frame = CGRectMake(16 , 0, cellName.width-16*2, 1);
                    lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
                    [cellName.contentView addSubview:lbl];
                    cellName.tag = [[NSString stringWithFormat:@"400%ld%ld",indexPath.section,indexPath.row] integerValue];
                    cellName.delegate = self;
                    cellName.selectionStyle = UITableViewCellSelectionStyleNone;
                cellName.LeftTitle.text = titlearr[indexPath.row];
                    [cellName.phoneImage setImage:[UIImage imageNamed:@"icon_tongxunlu"] forState:(UIControlStateNormal)];
                    if(indexPath.section==2)
                    { if(self.addressSender!=nil)
                     {
                        cellName.RightField.text = self.addressSender.addressFullName;
                     }
                    
                    }else if(indexPath.section==3)
                    { if(self.addressReceiver!=nil)
                    {
                        cellName.RightField.text = self.addressReceiver.addressFullName;
                    }
                    }
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellName.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = cellName.bounds;
                    maskLayer.path = maskPath.CGPath;
                    cellName.layer.mask = maskLayer;
                    });
                NSLog(@"indexPath.row2222=== %ld",(long)indexPath.row);
                return cellName;
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
                    });
                    cell.RightField.keyboardType = UIKeyboardTypeNumberPad;
                }
            }
        }
    }else if(indexPath.section==3)
    {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell1 == nil)
        {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        }
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                self.CompleteB.frame=CGRectMake(0, 0, cell1.width, 50);
                self.CompleteB.layer.cornerRadius = 25;
            [cell1 addSubview:self.CompleteB];
        });
        //cell选中效果
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        return cell1;
    }else
    {
//        if(indexPath.section == 1){
////            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
//            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_next"]];
//            cell.accessoryView = accessoryImgView;
//            cell.RightField.userInteractionEnabled=NO;
//            cell.RightField.text = self.PostType;
//        }else
            if (indexPath.section == 0)
        {
            LetterNameTableViewCell *cellZ = (LetterNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableNameID];
            if (cellZ == nil) {
                cellZ= (LetterNameTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LetterNameTableViewCell" owner:self options:nil]  lastObject];
            }
                UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                lbl.frame = CGRectMake(16 , 0, cellZ.width-16*2, 1);
                lbl.backgroundColor =  [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
                [cellZ.contentView addSubview:lbl];
//                cellZ.tag = [[NSString stringWithFormat:@"400%ld%ld",indexPath.section,indexPath.row] integerValue];
            cellZ.tag = [[NSString stringWithFormat:@"300%ld%ld",indexPath.section,indexPath.row] integerValue];
            cellZ.contentView.tag = [[NSString stringWithFormat:@"300%ld%ld",indexPath.section,indexPath.row] integerValue];
                cellZ.delegate = self;
                cellZ.selectionStyle = UITableViewCellSelectionStyleNone;
            cellZ.LeftTitle.text = titlearr[indexPath.row];
            cellZ.RightField.userInteractionEnabled=NO;
            [cellZ.phoneImage setImage:[UIImage imageNamed:@"icon_scan11"] forState:(UIControlStateNormal)];
                if(self.ItemNumber!=nil)
                 {
                    cellZ.RightField.text = self.ItemNumber;
                 }
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellZ.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = cellZ.bounds;
                maskLayer.path = maskPath.CGPath;
                cellZ.layer.mask = maskLayer;
                });
            NSLog(@"cellZ.row2222=== %ld",(long)indexPath.row);
            return cellZ;
        }
        if(indexPath.section == 0 || indexPath.section == 3)
        {
            if(indexPath.section == 0)
            {
                cell.RightField.userInteractionEnabled=NO;
                cell.RightField.text = self.ItemNumber;
            }
            cell.layer.cornerRadius = 20;
        }
        
    }
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
    if(section<3)
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
    
    return 50;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MMMMM === %ld  row= %ld",indexPath.section,indexPath.row);
    //        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        CollViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CollViewController"];
    //        Avc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:Avc animated:YES];
    if(indexPath.section == 0)
    {
            PostSGQViewController * Avc = [[PostSGQViewController alloc] init];
            [self.navigationController pushViewController:Avc animated:YES];
    }else if(indexPath.section==1)
    {
        NSMutableArray * arrType = [NSMutableArray arrayWithCapacity:0];
        [arrType addObject:@"LETTER"];
        [arrType addObject:@"PARCEL"];
        [self addLZPickerView:arrType ViewTag:[[NSString stringWithFormat:@"800%ld%ld",indexPath.section,indexPath.row] integerValue]];
    }else if((indexPath.section==2||indexPath.section==3) && indexPath.row==2 )
    {
        
            LetterMobileTableViewCell * cell = (LetterMobileTableViewCell*)[TableView cellForRowAtIndexPath:indexPath];
            NSLog(@"cell.tag======   %ld   contentView.tag= %ld",(long)cell.tag, (long)cell.contentView.tag);
        if(cell.contentView.tag == indexRowtag)
        {
//        NSString * tagS = [NSString stringWithFormat:@"100%ld%ld",indexPath.section,indexPath.row];
        [self addLZPickerView:self.CountryArr ViewTag:[[NSString stringWithFormat:@"200%ld%ld",indexPath.section,indexPath.row] integerValue]];
        }
       
    }else if(indexPath.section==2 && indexPath.row==1)
    {
       UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
       CityListViewController *Avc=[main instantiateViewControllerWithIdentifier:@"CityListViewController"];
       Avc.hidesBottomBarWhenPushed = YES;
        Avc.delegate=self;
       [self.navigationController pushViewController:Avc animated:YES];
    }
}
-(void)selectCity:(NSString *)cityStr
{
    self.addressReceiver.country = cityStr;
    [self.TableView reloadData];
}
#pragma mark ----------
-(void)push_btnTouch:(NSInteger)tag
{
    [self addLZPickerView:self.MobileArr ViewTag:tag];

}

- (void)returnFieldStr:(nonnull NSString *)RightFieldStr TagStr:(NSInteger)tag {
//    NSLog(@"RightFieldStr===  %@ ,tag = %ld",RightFieldStr,(long)tag);
    NSString * str1 = [NSString stringWithFormat:@"%ld",(long)tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
//    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
    if([str2 integerValue] == 2)
    {
        self.addressSender.mobile = RightFieldStr;
    }else if([str2 integerValue] == 3)
    {
        self.addressReceiver.mobile = RightFieldStr;
    }
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[str3 integerValue] inSection:[str2 integerValue]];
//    LetterMobileTableViewCell * cell = (LetterMobileTableViewCell*)[TableView cellForRowAtIndexPath:indexPath];
}
-(void)returnRightField:(NSString * )RightFieldStr TagStr:(NSInteger)tag
{
//    NSLog(@"returnRightField===  %@ ,tag = %ld",RightFieldStr,(long)tag);
    NSString * str1 = [NSString stringWithFormat:@"%ld",tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
    if([str2 integerValue] == 2)
    {
        if([str3 integerValue] == 2)
        {
            self.addressSender.country = RightFieldStr;
        }else if([str3 integerValue] == 3)
        {
            self.addressSender.addressLine1 = RightFieldStr;
        }else if([str3 integerValue] == 4)
        {
            self.addressSender.addressLine2 = RightFieldStr;
        }else if([str3 integerValue] == 5)
        {
            self.addressSender.postalCode = RightFieldStr;
        }
        
        
    }else if ([str2 integerValue] == 3)
    {
        if([str3 integerValue] == 2)
        {
            self.addressReceiver.country = RightFieldStr;
        }else if([str3 integerValue] == 3)
        {
            self.addressReceiver.addressLine1 = RightFieldStr;
        }else if([str3 integerValue] == 4)
        {
            self.addressReceiver.addressLine2 = RightFieldStr;
        }else if([str3 integerValue] == 5)
        {
            self.addressReceiver.postalCode = RightFieldStr;
        }
    }
}
-(void)returnRightFieldName:(NSString * )RightFieldStr TagStr:(NSInteger)tag
{
//    NSLog(@"returnRightFieldName===  %@,tag=  %ld",RightFieldStr,(long)tag);
    NSString * str1 = [NSString stringWithFormat:@"%ld",(long)tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
//    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[str3 integerValue] inSection:[str2 integerValue]];
    if([str2 integerValue] == 2)
    {
        self.addressSender.addressFullName = RightFieldStr;
    }else if([str2 integerValue] == 3)
    {
        self.addressReceiver.addressFullName = RightFieldStr;
    }
    
//    LetterMobileTableViewCell * cell = (LetterMobileTableViewCell*)[TableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"cell.tag==  %@",cell.RightField.text);
}
-(void)AddressInfo:(NSInteger)tag
{
    if(tag==30000)
    {
        PostSGQViewController * Avc = [[PostSGQViewController alloc] init];
        [self.navigationController pushViewController:Avc animated:YES];
    }else{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressInfoViewController *Avc=[main instantiateViewControllerWithIdentifier:@"AddressInfoViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    Avc.delegate = self;
    Avc.tagS = tag;
    [self.navigationController pushViewController:Avc animated:YES];
    }
}
-(void)returnAddressStr:(AddressListMode * )AddressStr tagS:(NSInteger)Tag
{
    NSLog(@"tag====   %ld", Tag);
    if(Tag == 40010)
    {
        self.addressSender = [self setModeValue:AddressStr];
    }else if(Tag == 40020)
    {
        self.addressReceiver = [self setModeValue:AddressStr];
    }
    [self.TableView reloadData];
}
-(AddressInfoMode * )setModeValue:(AddressListMode*)mode
{
    if(mode != nil)
    {
        AddressInfoMode * ListMode = [[AddressInfoMode alloc] init];
        ListMode.addressFullName=mode.addressFullName;
        ListMode.countryCallingCode=mode.countryCallingCode;
        ListMode.mobile=mode.mobile;
        ListMode.country=mode.country;
        ListMode.addressLine1=mode.addressLine1;
        ListMode.addressLine2=mode.addressLine2;
        ListMode.postalCode=mode.postalCode;
        return ListMode;
    }
    return  nil;
}

-(void)addLZPickerView:(NSMutableArray * )arr ViewTag:(NSInteger)tag
{
//    NSLog(@"LZPickerViewTag==== %ld",(long)tag);
    NSString * str1 = [NSString stringWithFormat:@"%ld",(long)tag];
    //    1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString * str2 = [str1 substringWithRange:NSMakeRange(3,1)];//str2 = "is"
    NSString * str3 = [str1 substringWithRange:NSMakeRange(4,1)];//str2 = "is"
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[str3 integerValue] inSection:[str2 integerValue]];
    if(tag==20021 || tag==20031)
    {
        /*
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
        if(tag==20021)
        {
            self.addressSender.countryCallingCode =  [NSString stringWithFormat:@"+%@",value];
        }else if(tag==20031)
        {
            self.addressReceiver.countryCallingCode =  [NSString stringWithFormat:@"+%@",value];
        }
    };
    [lzPickerVIew show];
        */
    }else if(tag==20022 || tag==20032)
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
            if(tag==20022)
            {
                self.addressSender.country = value;
            }else if(tag==20032)
            {
                self.addressReceiver.country = value;
            }
        };
        [lzPickerVIew show];
    }else if (tag == 80010)
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
            self.PostType = value;
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

-(BOOL)isEqualsenderMode
{
    if(![self.addressSender.addressFullName isEqualToString:@""] && self.addressSender.addressFullName!=nil)
    {
        if(![self.addressSender.countryCallingCode isEqualToString:@""] && self.addressSender.countryCallingCode!=nil)
        {
            if(![self.addressSender.mobile isEqualToString:@""] && self.addressSender.mobile!=nil)
            {
                if(![self.addressSender.country isEqualToString:@""] && self.addressSender.country!=nil)
                {
                    if(![self.addressSender.addressLine1 isEqualToString:@""] && self.addressSender.addressLine1!=nil)
                    {
                        if(![self.addressSender.addressLine2 isEqualToString:@""] && self.addressSender.addressLine2!=nil)
                        {
                            if(![self.addressSender.postalCode isEqualToString:@""] && self.addressSender.postalCode!=nil)
                            {
                                return YES;
                            }else
                            {
                                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Zip code cannot be empty", @"Language") andDelay:2.0];
                                return NO;
                            }
                        }else
                        {
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Address 2 cannot be empty", @"Language") andDelay:2.0];
                            return NO;
                        }
                    }else
                    {
                        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Address 1 cannot be empty", @"Language") andDelay:2.0];
                        return NO;
                    }
                }else
                {
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Country cannot be empty", @"Language") andDelay:2.0];
                    return NO;
                }
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Mobile cannot be empty", @"Language") andDelay:2.0];
                return NO;
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Country Calling Code cannot be empty", @"Language") andDelay:2.0];
            return NO;
        }
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Sender Name cannot be empty", @"Language") andDelay:2.0];
        return NO;
    }
    return NO;
}
-(BOOL)isEqualreceiver
{
    if(![self.addressReceiver.addressFullName isEqualToString:@""] && self.addressReceiver.addressFullName!=nil)
    {
        if(![self.addressReceiver.countryCallingCode isEqualToString:@""] && self.addressReceiver.countryCallingCode!=nil)
        {
            if(![self.addressReceiver.mobile isEqualToString:@""] && self.addressReceiver.mobile!=nil)
            {
                if(![self.addressReceiver.country isEqualToString:@""] && self.addressReceiver.country!=nil)
                {
                    if(![self.addressReceiver.addressLine1 isEqualToString:@""] && self.addressReceiver.addressLine1!=nil)
                    {
                        if(![self.addressReceiver.addressLine2 isEqualToString:@""] && self.addressReceiver.addressLine2!=nil)
                        {
                            if(![self.addressReceiver.postalCode isEqualToString:@""] && self.addressReceiver.postalCode!=nil)
                            {
                                return YES;
                            }else
                            {
                                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Zip code cannot be empty", @"Language") andDelay:2.0];
                                return NO;
                            }
                        }else
                        {
                            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Address 2 cannot be empty", @"Language") andDelay:2.0];
                            return NO;
                        }
                    }else
                    {
                        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Address 1 cannot be empty", @"Language") andDelay:2.0];
                        return NO;
                    }
                }else
                {
                    [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Country cannot be empty", @"Language") andDelay:2.0];
                    return NO;
                }
            }else
            {
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Mobile cannot be empty", @"Language") andDelay:2.0];
                return NO;
            }
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Country Calling Code cannot be empty", @"Language") andDelay:2.0];
            return NO;
        }
    }else
    {
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Receiver Name cannot be empty", @"Language") andDelay:2.0];
        return NO;
    }
    return NO;
}




@end
