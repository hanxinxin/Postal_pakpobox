//
//  LocationViewController.h
//  NewPostal
//
//  Created by mac on 2019/8/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface LocationViewController : UIViewController
{
   
}

@property (strong, nonatomic) CLLocationManager * _locationManager; ///// 定位

@property (strong, nonatomic) IBOutlet MKMapView *MapView;
@property (strong, nonatomic) IBOutlet UIView *DownView;
@property (strong, nonatomic) IBOutlet UILabel *D_title;
@property (strong, nonatomic) IBOutlet UILabel *D_downTitle;
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;
@property (strong, nonatomic) IBOutlet UILabel *KMText;
@property (strong, nonatomic) IBOutlet UIButton *Go_Btn;

@end

NS_ASSUME_NONNULL_END
