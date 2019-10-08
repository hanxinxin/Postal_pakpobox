//
//  PostSGQViewController.h
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol PostSGQViewControllerDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
-(void)returnWCQRStr:(NSString*)WCQRStr;
@end
@interface PostSGQViewController : UIViewController

@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIView * playView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (assign,nonatomic)NSInteger tag_int;  //// 1是 parcel 2 是packets
@property (assign,nonatomic)NSString * ordersId;  ////有ID要传，没有ID则不用传
///增加拉近/远视频界面
@property (nonatomic, assign) BOOL isVideoZoom;

// id即表示谁都可以设置成为我的代理
@property (nonatomic,weak) id<PostSGQViewControllerDelegate> delegate;

-(void)addViewSS;

@end
