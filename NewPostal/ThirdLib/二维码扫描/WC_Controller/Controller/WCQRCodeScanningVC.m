//
//  WCQRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import "WCQRCodeScanningVC.h"
#import "AppDelegate.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
//#import "DryerViewController.h"
#import "NSString+AES256.h"
//#import <luckysdk/Manager.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import <luckysdk/NetworkConfig.h>
@interface WCQRCodeScanningVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate,CBCentralManagerDelegate>
{
    BOOL QRBool;
}
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSString *orderStr; //////扫描二维码得到的信息

@property CBCentralManager *centralManager;


@end

@implementation WCQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.manager stopRunning];
    [self.manager videoPreviewLayerRemoveFromSuperlayer];
    /*
//    [Manager.inst disconnect];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [self removeScanningView];
    [self.promptLabel removeFromSuperview];
    [self.flashlightBtn removeFromSuperview];
    [self.bottomView removeFromSuperview];
    NSArray<CALayer *> *subLayers = self.view.layer.sublayers;
    NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[AVCaptureVideoPreviewLayer class]];
    }]];
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    [_manager cancelSampleBufferDelegate];
//    [_managerd dealloc];
    _manager=nil;
     */
}

- (void)dealloc {
    NSLog(@"WCQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
//
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//    UIButton * back = [[UIButton alloc] init];
//    back.frame = CGRectMake(15, 15, 40, 40);
////    [back setImage:[UIImage imageNamed:@"popup_close"] forState:(UIControlStateNormal)];
//    [back setImage:[UIImage imageNamed:@"nav_close"] forState:(UIControlStateNormal)];
//    [back addTarget:self action:@selector(backTouch:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    [self.view addSubview:back];
//        });
    /// 为了 UI 效果
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.bottomView];
    [self setupNavigationBar];
}
-(void)backTouch:(id)sender
{
    NSLog(@"dis");
    if(self.navigationController.topViewController == self)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            //        [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
//    [backBtn setTintColor:[UIColor blackColor]];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [HudViewFZ HiddenHud];
        self.orderStr =@"";
    
        [self QRCodeScanVC];
        if(self->QRBool==YES)
        {
            [self setupQRCodeScanning];
        }else
        {
            NSLog(@"ACE,ACE");
        }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        UIButton * back = [[UIButton alloc] init];
        back.frame = CGRectMake(15, 15, 40, 40);
        //    [back setImage:[UIImage imageNamed:@"popup_close"] forState:(UIControlStateNormal)];
        [back setImage:[UIImage imageNamed:@"nav_close"] forState:(UIControlStateNormal)];
        [back addTarget:self action:@selector(backTouch:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.view addSubview:back];
    });
    [self.manager startRunning];
    [super viewWillAppear:animated];
}


/**
 扫描二维码 需要先检测相机
 
 */
- (void)QRCodeScanVC{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    QRBool = NO;
//    __weak __typeof(self) weakSelf = self;
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            [self.navigationController pushViewController:scanVC animated:YES];
//                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        self->QRBool = YES;
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
                        
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [self setupQRCodeScanning];
                        });
                        
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        self->QRBool = NO;
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
//                [self.navigationController pushViewController:scanVC animated:YES];
                self->QRBool = YES;
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"Please-> [Settings - Privacy - Camera - Cleanpro] Open access switch" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                self->QRBool = NO;
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                self->QRBool = NO;
                break;
            }
                
            default:
                self->QRBool = NO;
                break;
        }
        
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"Your camera has not been detected" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
    self->QRBool = NO;
}

- (void)setupNavigationBar {
//    self.navigationItem.title = @"扫一扫";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
//        _scanningView.backgroundColor = [UIColor blueColor];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;

    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
//    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];;
    NSArray *arr = @[AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeDataMatrixCode];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_URL = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
        
    } else {
        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
        jumpVC.jump_bar_code = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    [HudViewFZ labelExample:self.view];
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        [scanManager videoPreviewLayerRemoveFromSuperlayer];
//
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.comeFromVC = ScanSuccessJumpComeFromWC;
//        NSLog(@"object - - %@ ，，， obj String=%@", obj,[obj stringValue]);
        NSString * orderStr1=[obj stringValue];
        NSLog(@"orderStr1 === %@", orderStr1);
        
        NSArray *array = [orderStr1 componentsSeparatedByString:@"|"];
        if(array.count==2)
        {
//            if ([self.delegate respondsToSelector:@selector(returnWCQRStr:)]) {
//                [self.delegate returnWCQRStr:orderStr1]; // 回调代理
//            }
            
            if([array[0] isEqualToString:@"COLLECT_LETTER"])
            {
                NSString * str = array[1];
//                if (self.tag_int==2)
//                {
                    [self postLetter_take_app:str];
//                }
            }else if([array[0] isEqualToString:@"COLLECT_PARCEL"])
            {
                NSString * str = array[1];
//                if(self.tag_int==1)
//                {
                     [self postParcel_take_app:str];
//                }
            }
             
        }else
        {
            NSLog(@"暂未识别出扫描的二维码1");
//            if ([self.delegate respondsToSelector:@selector(returnWCQRStr:)]) {
//                [self.delegate returnWCQRStr:nil]; // 回调代理
//            }
            
            [HudViewFZ HiddenHud];
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.5];
            [scanManager startRunning];
            [self setupQRCodeScanning];
        }
        
        
    } else {
        NSLog(@"暂未识别出扫描的二维码2");
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.5];
        [scanManager startRunning];
        [self setupQRCodeScanning];
    }
}
-(void)postParcel_take_app:(NSString*)IDStr
{
    NSDictionary *dict ;
    
    if(self.ordersId==nil)
    {
        dict = @{@"lockerId":IDStr,
                 };
    }else
    {
        dict = @{@"lockerId":IDStr,
                 @"ordersId":self.ordersId
                 };
    }
    NSLog(@"dict ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_parcel] parameters:dict progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"postParcel====  %@",responseObject);
        /////还要有一个接口要查询，开门是否成功。
        NSDictionary *dict = (NSDictionary*)responseObject;
        NSString * takeID = [dict objectForKey:@"result"];
        [self ChaXun:takeID];
    } failure:^(NSError *error) {
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [self setupQRCodeScanning];
    }];
}
-(void)postLetter_take_app:(NSString*)IDStr
{
//    NSDictionary *dict = @{@"lockerId":IDStr,
//                           };
    NSDictionary *dict;
  if(self.ordersId==nil){
      dict = @{@"lockerId":IDStr,
               };
      
  }else{
      dict = @{@"lockerId":IDStr,
               @"ordersId":self.ordersId
               };
  }
    NSLog(@"dict1 ====%@",dict);
    [[AFNetWrokingAssistant shareAssistant] PostURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Post_Letter] parameters:dict
                                           progress:^(id progress) {
    } Success:^(id responseObject) {
        NSLog(@"responseObject====  %@",responseObject);
        /////还要有一个接口要查询，开门是否成功。
        NSDictionary *dict = (NSDictionary*)responseObject;
        NSString * takeID = [dict objectForKey:@"result"];
        [self ChaXun:takeID];
    } failure:^(NSError *error) {
                                             
        NSLog(@"3333   %@",error);
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
        [self setupQRCodeScanning];
    }];
}
-(void)ChaXun:(NSString *)taskId
{
//    NSLog(@"URL === %@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Get_OrderList,taskId]);
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,Get_take_info,taskId] parameters:nil progress:^(id progress) {
        //        NSLog(@"请求成功 = %@",progress);
    } success:^(id responseObject) {
        NSLog(@"ChaXun = %@",responseObject);
        NSDictionary *dict = (NSDictionary*)responseObject;
        NSString * taskStatus = [dict objectForKey:@"taskStatus"];
        if([taskStatus isEqualToString:@"CREATED"])
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self ChaXun:taskId];
            });
            
        }else if([taskStatus isEqualToString:@"SUCCEED"])
        {
            [HudViewFZ HiddenHud];
            [self addalt:@"Your mail has been dispensed."];
//            [self disMissView];
        }else if([taskStatus isEqualToString:@"FAILED"])
        {
            [HudViewFZ HiddenHud];
//            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Failure to unlock", @"Language") andDelay:2.5];
            [self addalt:@"Failure to unlock"];
//            [self disMissView];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ HiddenHud];
        
    }];
}
-(void)addalt:(NSString *)tipsStr
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Postal Station" message:tipsStr preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self disMissView];
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}
-(void)disMissView
{
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self backTouch:nil];
//        });
}

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < - 1) {
        [self.view addSubview:self.flashlightBtn];
    } else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
//        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
        _promptLabel.text = @"Scan the QR code on the machine";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
//         _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.view.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _flashlightBtn.backgroundColor=[UIColor blueColor];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (SCREEN_WIDTH - flashlightBtnW);
        CGFloat flashlightBtnY = _promptLabel.bottom+15;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [SGQRCodeHelperTool SG_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SGQRCodeHelperTool SG_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}



@end

