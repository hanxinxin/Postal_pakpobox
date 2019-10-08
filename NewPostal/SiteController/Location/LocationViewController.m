//
//  LocationViewController.m
//  NewPostal
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationCoordinate2D My_Loca;
}
@end

@implementation LocationViewController
@synthesize _locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    My_Loca.latitude=0;
    My_Loca.longitude=0;
    /*
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tisp", @"Language")message:FGGetStringWithKeyFromTable(@"\" Settings - privacy - location service \" opens location service and allows StorHub to use location-based services.", @"Language") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    */
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    self.title=@"Cleapro";
    self.title=FGGetStringWithKeyFromTable(@"Location", @"Language");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addMapView_c];
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
-(void)addMapView_c
{
    self.MapView.showsUserLocation = YES;
    self.MapView.mapType = MKMapTypeStandard;
    if (@available(iOS 9.0, *)) {
        self.MapView.showsScale=YES;
    } else {
        // Fallback on earlier versions
    } ////显示比例尺
    if (@available(iOS 9.0, *)) {
        self.MapView.showsCompass=YES;
    } else {
        // Fallback on earlier versions
    } ////显示指南针
    //设置地图可旋转
    self.MapView.rotateEnabled = NO;
    self.MapView.zoomEnabled = YES;////缩放
    self.MapView.scrollEnabled = YES;/////滑动
    // 交通
    if (@available(iOS 9.0, *)) {
        self.MapView.showsTraffic = YES;
    } else {
        // Fallback on earlier versions
    }
    self.MapView.userTrackingMode = MKUserTrackingModeFollow;
    self.MapView.userInteractionEnabled=YES;
    self.MapView.delegate=self;
    
    
    //标注自身位置
    [self.MapView setShowsUserLocation:YES];
    
    _locationManager = [[CLLocationManager alloc] init];
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        [_locationManager requestWhenInUseAuthorization];
//    }
    //2.请求用户授权，还需配置Plist，配置键为NSLocationWhenInUseUsageDescription，值为提示用户的信息
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _locationManager.activityType=CLActivityTypeOther;
    _locationManager.distanceFilter =0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    
    self.DownView.layer.cornerRadius = 15;
    self.Go_Btn.layer.cornerRadius = 25;
    [self.view addSubview:self.DownView];
    
}


- (IBAction)GoTouch:(id)sender {
}

// 定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    
    NSLog(@"locations =   %@",locations);
    CLLocation *location = [locations objectAtIndex:0];
    //            NSLog(@"----    %f",location.horizontalAccuracy);
    CLLocationCoordinate2D loc =  [location coordinate];
    //    CLLocationCoordinate2D loc = [userLocation coordinate];
    My_Loca=loc;
    
    //放大地图到自身的经纬度位置。
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 3000, 3000);
    //    [self.MapView setRegion:region animated:YES];
    [manager stopUpdatingLocation];
    [manager stopUpdatingHeading];
    
}
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
}
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    else if ([annotation isKindOfClass:[AircraftAnnotation class]])
    {
        //        AircraftAnnotationView *annotationView = (AircraftAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AircraftAnnotationView"];
        AircraftAnnotationView *annotationView =(AircraftAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AircraftAnnotationView"];
        
        if (annotationView == nil) {
            annotationView = (AircraftAnnotationView *)[[MKAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:@"AircraftAnnotationView"];
            //            annotationView.drop = YES; // 设置大头针坠落的动画
            annotationView.canShowCallout = YES; // 设置点击大头针是否显示气泡
            annotationView.calloutOffset = CGPointMake(0, 0); // 设置大头针气泡的偏移
            
        }
        annotationView.image = [UIImage imageNamed:@"location_mark_app"];
        ///无  APP门店图标  location_mark@2x
        //有 app门店图标  location_mark_app
        //        annotationView.canShowCallout = YES;//显示气泡
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMissionSetView:)];
        //        [annotationView addGestureRecognizer:tap];
        annotationView.annotation = annotation;
        return annotationView;
        
    }
    return nil;
}
#pragma mark-点击按钮的时候的调用
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"点击按钮的时候的调用 == %@",view.annotation.subtitle);
    //    self.myLocationAnnotation.coordinate=self.moveingAnnotation.coordinate;
    //    mapView.userLocation.coordinate=self.moveingAnnotation.coordinate;
    
}
#pragma mark 选中了标注的处理事件
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //    NSLog(@"选中了标注 %f %f %f %f",view.top,view.left,view.width,view.height);
    NSLog(@"选中了标注");
    
    if ([view.annotation isKindOfClass:[AircraftAnnotation class]])
    {
        AircraftAnnotation * mac=(AircraftAnnotation*)view.annotation;
        //        NSLog(@"title===%ld",mac.tagg);
        LocationClass * MD_Mode = (LocationClass * )MD_MUtableArr[mac.tagg];
        self.mendianLabel.text=MD_Mode.MDName;
        [self returnSize1:self.mendianLabel];
        //        self.mendianMiaoShu.frame=CGRectMake(self.daohangBtn.right, self.mendianLabel.bottom+5, SCREEN_WIDTH-self.daohangBtn.right*2, 44);
        self.mendianMiaoShu.text=MD_Mode.MDaddress;
        [self returnSize2:self.mendianMiaoShu];
        NSLog(@"mendianMiaoShu===%@",self.mendianMiaoShu.text);
    }
    [self down_viewShow];
}

#pragma mark 取消选中标注的处理事件
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"取消了标注");
    [self down_viewHidden];
}
//大头针显示在视图上时调用，在这里给大头针设置显示动画
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    
    //    获得mapView的Frame
    CGRect visibleRect = [mapView annotationVisibleRect];
    
    for (MKAnnotationView *view in views) {
        
        CGRect endFrame = view.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
        view.frame = startFrame;
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:1];
        view.frame = endFrame;
        [UIView commitAnimations];
        
        
    }
    
    
}

// 点击大头针显示单个任务详情
- (void)showMissionSetView:(UITapGestureRecognizer *)tapGuest
{
    
    NSLog(@"点击了自定义气泡");
}
 */
@end
