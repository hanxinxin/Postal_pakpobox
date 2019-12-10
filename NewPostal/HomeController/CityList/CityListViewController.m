//
//  CityListViewController.m
//  NewPostal
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CityListViewController.h"
#import "searchingHeaderView.h"
#import "UITableView+SCIndexView.h"
@interface CityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *countryArrayList;///国家的name
@property (nonatomic, strong) NSMutableArray *headerArrayList;///国家的name
@property (nonatomic, strong) NSArray * arrZM;

@property (nonatomic, assign) BOOL translucent;
@end

@implementation CityListViewController
@synthesize arrZM,headerArrayList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.countryArrayList = [NSMutableArray arrayWithCapacity:0];
    headerArrayList = [NSMutableArray arrayWithCapacity:0];
     self.translucent = YES;
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.CityTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.CityTableView.delegate=self;
    self.CityTableView.dataSource=self;
    self.CityTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    arrZM =[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"k",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    for (int i = 0; i<arrZM.count; i++) {
        [headerArrayList addObject:arrZM[i]];
    }
     [self.headerArrayList insertObject:@"" atIndex:0];
    [self.CityTableView registerClass:searchingHeaderView.class forHeaderFooterViewReuseIdentifier:@"searchingHeaderView"];
    [self getArray_list];
    self.CityTableView.sc_indexViewDataSource = headerArrayList.copy;
}

-(void)getArray_list
{
    
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    for (int c = 0; c<arrZM.count; c++) {
        
        NSMutableArray * MA= [NSMutableArray arrayWithCapacity:0];
        NSString * str = arrZM[c];
        for (NSString *countryCode in countryArray) {
            NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            
            NSString *str2 = [displayNameString substringWithRange:NSMakeRange(0,1)];//str2 = "is"
            if([str isEqualToString:str2])
            {
                
                countriesClass * mode = [[countriesClass alloc] init];
                mode.Gname = displayNameString;
                mode.GImage = displayNameString;
    //            NSArray * arr = [NSArray arrayWithObject:mode];
                [MA addObject:mode];
                   
            }
            
        }
         [self.countryArrayList addObject:MA];
    }
    countriesClass * mode = [[countriesClass alloc] init];
    mode.Gname = @"Singapore";
    mode.GImage =  @"Singapore";
    NSArray * arr = [NSArray arrayWithObject:mode];
    [self.countryArrayList insertObject:arr atIndex:0];
//    NSLog(@"打印数组==== %@",self.countryArrayList);
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.ListArray.count;
    NSArray * arrItmes = self.countryArrayList[section];
    return arrItmes.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.countryArrayList.count;
//    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CELLStr = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLStr];
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLStr];
    }
//    NSLog(@"section = %ld , row = %ld",indexPath.section,indexPath.row);
    if(indexPath.section==0)
    {
        NSArray * arr = self.countryArrayList[indexPath.section];;
        countriesClass *mode = arr[indexPath.row];
           cell.textLabel.text = mode.Gname;
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_yes"]];
        cell.accessoryView = accessoryImgView;
//        cell.imageView.image = [UIImage imageNamed:mode.GImage];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
        });
    }else{
    NSArray * arr = self.countryArrayList[indexPath.section];;
    countriesClass *mode = arr[indexPath.row];
       cell.textLabel.text = mode.Gname;
//    cell.imageView.image = [UIImage imageNamed:mode.GImage];
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
        }else if(indexPath.row == (arr.count-1))
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            });
        }
    }
       return cell;
}
//MARK: mac地址解析处理
- (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return 0;
    }
    return searchingHeaderView.headerViewHeight;
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
//    //自定义间隔view，可以不写默认用系统的
//    UIView * view_c= [[UIView alloc] init];
//    view_c.frame=CGRectMake(0, 0, 0, 0);
//    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
//    return view_c;
    if(section==0)
    {
        searchingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"searchingHeaderView"];
        [headerView configWithTitle:@"Singapore"];
        return headerView;
    }
    searchingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"searchingHeaderView"];
    [headerView configWithTitle:headerArrayList[section]];
//    [headerView configWithTitle:arrZM[section]];
    return headerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self reloadColorForHeaderView];
}

- (void)reloadColorForHeaderView {
    NSArray<NSIndexPath *> *indexPaths = self.CityTableView.indexPathsForVisibleRows;
    for (NSIndexPath *indexPath in indexPaths) {
        searchingHeaderView *headerView = (searchingHeaderView *)[self.CityTableView headerViewForSection:indexPath.section];
        [self configColorWithHeaderView:headerView];
    }
}
- (void)configColorWithHeaderView:(searchingHeaderView *)headerView {
    if (!headerView) {
        return;
    }
    
    CGFloat InsetTop = self.translucent ? UIApplication.sharedApplication.statusBarFrame.size.height + 44 : 0;
    double diff = fabs(headerView.frame.origin.y - self.CityTableView.contentOffset.y - InsetTop);
    CGFloat headerHeight = searchingHeaderView.headerViewHeight;
    double progress;
    if (diff >= headerHeight) {
        progress = 1;
    }
    else {
        progress = diff / headerHeight;
    }
    [headerView configWithProgress:progress];
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld,%ld",indexPath.section,indexPath.row);
    if ([self.delegate respondsToSelector:@selector(selectCity:)]) {
//        if(indexPath.section==0)
//        {
//            NSArray * arr = self.countryArrayList[indexPath.section];;
//            countriesClass *mode = arr[indexPath.row];
//            //           cell.textLabel.text = mode.Gname;
//            [self.delegate selectCity:mode.Gname]; // 回调代理
//        }else
//        {
            NSArray * arr = self.countryArrayList[indexPath.section];;
                    countriesClass *mode = arr[indexPath.row];
            //           cell.textLabel.text = mode.Gname;
                    [self.delegate selectCity:mode.Gname]; // 回调代理
//        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}




@end
