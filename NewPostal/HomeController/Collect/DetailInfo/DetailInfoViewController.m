//
//  DetailInfoViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "SingTableViewCell.h"
#import "ListTableViewCell.h"
#import "QRTableViewCell.h"
#import "WCQRCodeScanningVC.h"

#define tableID1 @"SingTableViewCell"
#define tableID2 @"ListTableViewCell"
#define tableID3 @"QRTableViewCell"



@interface DetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,QRTableViewCellDelegate>
{
    
}
@property(nonatomic,strong)ParcelInfo * mode;
@end

@implementation DetailInfoViewController
@synthesize mode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    mode=nil;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addTableViewOrders];
        [self getInfoList];
    });
    
    
}

-(void)getInfoList
{
    NSLog(@"URL === %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_infoXQ]);
    [HudViewFZ labelExample:self.view];
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Get_infoXQ,self.modeA.ordersId] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"111responseObject = %@",responseObject);
        [HudViewFZ HiddenHud];
        NSDictionary * dict = (NSDictionary *)responseObject;
        self->mode = [[ParcelInfo alloc] init];
        self->mode.boxName = [dict objectForKey:@"boxName"];
        self->mode.expiryTime =[dict objectForKey:@"expiryTime"];
        self->mode.location = [dict objectForKey:@"location"];
        self->mode.lockerName = [dict objectForKey:@"lockerName"];
        self->mode.ordersId = [dict objectForKey:@"ordersId"];
        self->mode.ordersNumber = [dict objectForKey:@"ordersNumber"];
        self->mode.pinCode = [dict objectForKey:@"pinCode"];
        if(self->mode!=nil)
        {
            [self.ZtableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        
    }];
}


-(void)addTableViewOrders
{
    //    if(self.view.width==375.000000 && self.view.height>=812.000000)
    //    {
    //        self.ZtableView.frame=CGRectMake(15, 84+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-84-10);
    //    }else{
    //        self.ZtableView.frame=CGRectMake(15, 64+10, SCREEN_WIDTH-15*2,SCREEN_HEIGHT-64-10);
    //    }
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
    [self.ZtableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID2];
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
    WCQRCodeScanningVC * vc = [[WCQRCodeScanningVC alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    vc.tag_int = 1;
    vc.ordersId = mode.ordersId;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
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
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 20;
        if(mode!=nil)
        {
            cell.downTitle.text = mode.location;
        }
    
    return cell;
    }else if(indexPath.section==1)
    {
        ListTableViewCell *cell = (ListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID2];
        if (cell == nil) {
            cell= (ListTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ListTableViewCell" owner:self options:nil]  lastObject];
        }
        //    NSLog(@"%ld",indexPath.section);
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor clearColor];
        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 20;
        if(mode!=nil)
        {
            cell.parcelRight.text = mode.ordersNumber;
            cell.compartmentRight.text = mode.boxName;
            cell.ExpiryRight.text = [self getTimeFromTimestampL:mode.expiryTime];
            
        }
//        cell.parcelRight.text = _modeA.ordersNumber;
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
        cell.PCodeLabel.text =mode.pinCode;
//        cell.QRImage.image = [self loadQRCodeImg:_modeA.pinCode];
        if(mode!=nil)
        {
            cell.QRImage.image = [self loadQRCodeImg:mode.pinCode];
            
        }
        cell.ClickBtn.layer.cornerRadius = 25;
        return cell;
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
    if(indexPath.section==2)
    {
        return 330;
    }
    return 107;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击 = %ld",indexPath.section);
    //        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        OrdersUnpaidViewController *vc=[main instantiateViewControllerWithIdentifier:@"OrdersUnpaidViewController"];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    
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
#pragma mark ---- 将时间戳转换成时间

- (NSString *)getTimeFromTimestampL:(NSNumber*)timeNumber{
    
    //将对象类型的时间转换为NSDate类型
    
    int time =[timeNumber doubleValue]/1000;
//    NSLog(@"time=== %d",time);
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    
    //将时间转换为字符串
    
    NSString *timeStr=[formatter stringFromDate:myDate];
    NSLog(@"timeStr=== %@",timeStr);
    return timeStr;
    
}

@end
