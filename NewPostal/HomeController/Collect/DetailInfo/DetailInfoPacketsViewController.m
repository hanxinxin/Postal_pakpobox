//
//  DetailInfoPacketsViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "DetailInfoPacketsViewController.h"
#import "SingTableViewCell.h"
#import "LPTableViewCell.h"
#import "QRTableViewCell.h"
#import "WCQRCodeScanningVC.h"
#import "ZDYQRCodeScanningVC.h"
#import "LettersNewTableViewCell.h"
#import "CellViewDown.h"
#import "PLXQTableViewCell.h"

#define tableID1 @"SingTableViewCell"
#define tableID2 @"LPTableViewCell"
#define tableID3 @"QRTableViewCell"
#define TableIDNew @"LettersNewTableViewCell"
#define TableIDDown @"PLXQTableViewCell"
@interface DetailInfoPacketsViewController ()<UITableViewDelegate,UITableViewDataSource,QRTableViewCellDelegate>

@end

@implementation DetailInfoPacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    self.ZtableView.hidden=YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addTableViewOrders];
        
    });
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    UIButton * rightB = [[UIButton alloc] init];
    rightB.frame = CGRectMake(SCREEN_WIDTH-60, 25, 40, 40);
    //    [back setImage:[UIImage imageNamed:@"popup_close"] forState:(UIControlStateNormal)];
    [rightB setImage:[UIImage imageNamed:@"icon_scan_ad"] forState:(UIControlStateNormal)];
    [rightB addTarget:self action:@selector(selectRightBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightB];;
        self.navigationItem.rightBarButtonItem = RightBtn;
    [super viewWillAppear:animated];
   
}
-(void)selectRightBtnAction:(id)sender
{
    ZDYQRCodeScanningVC * vc = [[ZDYQRCodeScanningVC alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    vc.tag_int = 2;
    vc.ordersId = _modeA.lockerId;
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    //    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;

    [super viewWillDisappear:animated];
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
    self.ZtableView.frame=CGRectMake(14, 0, SCREEN_WIDTH-28, SCREEN_HEIGHT-(self.navigationController.navigationBar.bottom));
    //    self.tableViewTop.frame=self.view.frame;
    self.ZtableView.delegate=self;
    self.ZtableView.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.ZtableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.ZtableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    //    self.tableViewTop.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.ZtableView];
    [self.ZtableView registerNib:[UINib nibWithNibName:@"SingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID1];
    [self.ZtableView registerNib:[UINib nibWithNibName:@"LPTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID2];
    [self.ZtableView registerNib:[UINib nibWithNibName:@"QRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID3];
    /*
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
    */
}

-(void)loadNewData
{
    //    [self getOrderList];
    [self.ZtableView.mj_footer endRefreshing];
    [self.ZtableView.mj_header endRefreshing];
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
-(void)push_btnTouch:(NSInteger)tag
{
//    WCQRCodeScanningVC * vc = [[WCQRCodeScanningVC alloc] init];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    vc.tag_int = 2;
//    vc.ordersId = _modeA.lockerId;
//    [self presentViewController:vc animated:YES completion:nil];
        ZDYQRCodeScanningVC * vc = [[ZDYQRCodeScanningVC alloc] init];
        //    [self.navigationController pushViewController:vc animated:YES];
        vc.tag_int = 2;
        vc.ordersId = _modeA.lockerId;
//        [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==1)
    {
//        return ([_modeA.letterCount intValue]-1);
        return 2;
    }
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
/*
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        SingTableViewCell *cell = (SingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID1];
        if (cell == nil) {
            cell= (SingTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"SingTableViewCell" owner:self options:nil]  lastObject];
        }
        //    NSLog(@"%ld",indexPath.section);
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor clearColor];
        [cell.contentView addSubview:lbl];
        cell.downTitle.text =_modeA.location;
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 20;
        return cell;
    }else if(indexPath.section==1)
    {
        LPTableViewCell *cell = (LPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID2];
        if (cell == nil) {
            cell= (LPTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LPTableViewCell" owner:self options:nil]  lastObject];
        }
        //    NSLog(@"%ld",indexPath.section);
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor clearColor];
        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 20;
        cell.right_Title.text = [_modeA.letterCount stringValue];
        return cell;
    }else if(indexPath.section==2)
    {
        QRTableViewCell *cell = (QRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID3];
        if (cell == nil) {
            cell= (QRTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"QRTableViewCell" owner:self options:nil]  lastObject];
        }
        //    NSLog(@"%ld",indexPath.section);
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor clearColor];
        [cell.contentView addSubview:lbl];
        cell.delegate=self;
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 20;
        cell.PCodeLabel.text =_modeA.pinCode;
        cell.QRImage.image = [self loadQRCodeImg:_modeA.pinCode];
        cell.ClickBtn.layer.cornerRadius = 25;
        return cell;
    }
    
    return nil;
}
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
     QRTableViewCell *cell = (QRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID3];
     if (cell == nil) {
         cell= (QRTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"QRTableViewCell" owner:self options:nil]  lastObject];
     }
     //    NSLog(@"%ld",indexPath.section);
     UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
     lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
     lbl.backgroundColor =  [UIColor clearColor];
     [cell.contentView addSubview:lbl];
     cell.delegate=self;
     //cell选中效果
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.layer.cornerRadius = 20;
     cell.PCodeLabel.text =_modeA.pinCode;
     cell.QRImage.image = [self loadQRCodeImg:_modeA.pinCode];
     cell.ClickBtn.layer.cornerRadius = 25;
        cell.ClickBtn.hidden=YES;
            return cell;
        }else if(indexPath.section==1)
        {
            if(indexPath.row==0)
            {
         LettersNewTableViewCell *cell = (LettersNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableIDNew];
                if (cell == nil) {
                    cell= (LettersNewTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"LettersNewTableViewCell" owner:self options:nil]  lastObject];
                }
                //    NSLog(@"%ld",indexPath.section);
                UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
                lbl.backgroundColor =  [UIColor clearColor];
                [cell.contentView addSubview:lbl];
                //cell选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //    cell.layer.cornerRadius = 20;
            //    cell.CoutTitle.layer.cornerRadius = 20;
            //    [UIBezierPathView setCornerOnLeft:4 view_b:cell.CoutTitle];
                cell.ItemsCoutLabel.text = [_modeA.letterCount stringValue];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.09/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                UIBezierPath *maskPath;
            //    maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(19, 30)];
                    maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerTopLeft) cornerRadii:CGSizeMake(19, 30)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = cell.bounds;
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
                   
                });
                
                    return cell;
                }else
                {
                    /*
                    PLXQTableViewCell *cell = (PLXQTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableIDDown];
                    if (cell == nil) {
                        cell= (PLXQTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PLXQTableViewCell" owner:self options:nil]  lastObject];
                    }
                     */
                    // 定义cell标识  每个cell对应一个自己的标识
                    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
                    [self.ZtableView registerNib:[UINib nibWithNibName:@"PLXQTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
                     // 通过不同标识创建cell实例
                    PLXQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
                    if (!cell) {
                        cell= (PLXQTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PLXQTableViewCell" owner:self options:nil]  lastObject];
                    }
                    //    NSLog(@"%ld",indexPath.section);
                    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
                    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
                    lbl.backgroundColor =  [UIColor clearColor];
                    [cell.contentView addSubview:lbl];
                    //cell选中效果
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.09/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                            packetsMode * mode = self.PacketsArrList[indexPath.section];
//                            if(indexPath.row==([self->_modeA.letterCount intValue]-2))
//                            {
                        UIBezierPath *maskPath;
                        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(19, 30)];
                        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                        maskLayer.frame = cell.bounds;
                        maskLayer.path = maskPath.CGPath;
                        cell.layer.mask = maskLayer;
//                          }
                        });
                       
                    return cell;
                }
        }
    return nil;
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
    if(indexPath.section==0)
    {
        return 260;
    }else if(indexPath.section==1 && indexPath.row==0)
    {
        
        return 150;
    }else
    {
        return 60;
    }
    return 0;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击 = %ld",indexPath.section);
    //        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        OrdersUnpaidViewController *vc=[main instantiateViewControllerWithIdentifier:@"OrdersUnpaidViewController"];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
//    ZDYQRCodeScanningVC * vc = [[ZDYQRCodeScanningVC alloc] init];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    vc.tag_int = 2;
//    vc.ordersId = _modeA.lockerId;
////    [self presentViewController:vc animated:YES completion:nil];
//     [self.navigationController pushViewController:vc animated:YES];
}




-(UIImage * )loadQRCodeImg:(NSString * )Str
{
    //1.将字符串转出NSData
    NSData *img_data = [Str dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.将字符串变成二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //  条形码 filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    //3.恢复滤镜的默认属性
    [filter setDefaults];
    
    //4.设置滤镜的 inputMessage
    [filter setValue:img_data forKey:@"inputMessage"];
    
    //5.获得滤镜输出的图像
    CIImage *img_CIImage = [filter outputImage];
    
    //6.此时获得的二维码图片比较模糊，通过下面函数转换成高清
    return [self changeImageSizeWithCIImage:img_CIImage andSize:180];
}

////拉伸二维码图片，使其清晰
- (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}


////拉伸二维码图片，使其清晰
- (UIImage *)changeImageSizeWithCIImageTiao:(CIImage *)ciImage andSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}
////3.拉伸条形码图片
////我们可以将1.生成二维码图片中的第6点改成：
//
//CGFloat scaleX = 300 / img_CIImage.extent.size.width;//300是你想要的长
//CGFloat scaleY = 70 / img_CIImage.extent.size.height;//70是你想要的宽
//img_CIImage = [img_CIImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
//
//self.img_BarCode = [UIImage imageWithCIImage:img_CIImage];



@end
