//
//  PostSGQViewController.m
//  NewPostal
//
//  Created by mac on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//
//

#import "PostSGQViewController.h"
#import "AppDelegate.h"

//#import "DryerViewController.h"
#import "NSString+AES256.h"
//#import <luckysdk/Manager.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LetterTBViewController.h"
//#import <luckysdk/NetworkConfig.h>

@interface PostSGQViewController () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate,CBCentralManagerDelegate,UIGestureRecognizerDelegate>
{
    BOOL QRBool;
    
    /////全屏透明色view和 button Lable
    UIView * Tuicang_View;
    UIView * TC_CenterView;
    UILabel * tisp_lable;
    UILabel * miaoshu_lable;
    UIButton * Come_btn;
    UIButton * back_btn;
    UITapGestureRecognizer *tapSuperGesture22;
    
    
}


@property (nonatomic, strong) NSString *orderStr; //////扫描二维码得到的信息

///记录开始的缩放比例
@property(nonatomic,assign)CGFloat beginGestureScale;

///最后的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;

//@property(nonatomic,assign) BOOL isVideoZoom;
@end

@implementation PostSGQViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc {
    NSLog(@"WCQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
//    [self.navigationController.navigationBar setHidden:YES];
    
   
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
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
    //
    //    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    self.orderStr =@"";
    /// 为了 UI 效果
//    [self.view insertSubview:self.scanningView belowSubview:self.playView];
    [self.view addSubview:self.playView];
    [self.view addSubview:self.scanningView];
    
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.bottomView];
    [self addViewSS];
    self.isVideoZoom=YES;
    [self setupNavigationBar];

    [self QRCodeScanVC];
    
    if(self->QRBool==YES)
    {
        [self setupQRCodeScanning];
    }else
    {
        NSLog(@"ACE,ACE");
    }
    _effectiveScale = 1;
    [self cameraInitOver];
    //    });
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        UIButton * back = [[UIButton alloc] init];
        back.frame = CGRectMake(15, 15, 40, 40);
        //    [back setImage:[UIImage imageNamed:@"popup_close"] forState:(UIControlStateNormal)];
        [back setImage:[UIImage imageNamed:@"nav_close"] forState:(UIControlStateNormal)];
        [back addTarget:self action:@selector(backTouch:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.view addSubview:back];
         
    });
    dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
        [self addselect_view:2];
    });
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CameraScaleAction:)];
    [self.scanningView addGestureRecognizer:tap];
    [super viewWillAppear:animated];
}
-(void)addViewSS
{
//     _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1 * self.view.frame.size.height)];
////    [self.view addSubview:_scanningView];
//    [self.view insertSubview:_scanningView atIndex:1];
//    [self.view.layer insertSublayer:_scanningView.layer atIndex:1];
}
#pragma mark -  焦距

- (void)CameraScaleAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"tapHandler 点击了。。。");
}

#pragma mark 增加拉近/远视频界面
- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
        pinch.delegate = self;
        [self.view addGestureRecognizer:pinch];
    }
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recogniser
{
    self.effectiveScale = self.beginGestureScale * recogniser.scale;
    if (self.effectiveScale < 1.0){
        self.effectiveScale = 1.0;
    }
    [self.manager setVideoScale:self.effectiveScale ViewController:self];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        _beginGestureScale = _effectiveScale;
    }
    return YES;
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
- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1 * self.view.frame.size.height)];
        _playView.backgroundColor = [UIColor clearColor];
    }
    return _playView;
}
- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1 * self.view.frame.size.height)];
//                _scanningView.backgroundColor = [UIColor blueColor];
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
//    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    NSArray *arr = @[AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeDataMatrixCode];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.playView];
    [self.view addSubview:self.scanningView];
    [self.view insertSubview:self.scanningView belowSubview:self.playView];
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
        NSLog(@"object - - %@ ，，， obj String=%@", obj,[obj stringValue]);
        NSString * orderStr1 = [obj stringValue];
        NSLog(@"orderStr1 === %@", orderStr1);
//        [self disMissView];
        
        [HudViewFZ HiddenHud];
//        [scanManager startRunning];
        [self setupQRCodeScanning];
        [self pushView:orderStr1];
        
        
    } else {
        NSLog(@"暂未识别出扫描的二维码2");
        [HudViewFZ HiddenHud];
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"The scanned qr code has not been identified yet", @"Language") andDelay:2.5];
        [scanManager startRunning];
        [self setupQRCodeScanning];
    }
}


-(void)disMissView
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self backTouch:nil];
//        [self pushView];
    });
}
-(void)pushView:(NSString *)Str
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LetterTBViewController *Avc=[main instantiateViewControllerWithIdentifier:@"LetterTBViewController"];
    Avc.hidesBottomBarWhenPushed = YES;
    Avc.ItemNumber = Str;
    [self.navigationController pushViewController:Avc animated:YES];
    
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



#pragma mark ------- 全屏View 背景透明 --------

/**
 全屏View 背景透明 //没钱支付的时候提示他需要充值
 index  1是 没钱提醒充值  2是 没有设置支付密码
 */
-(void)addselect_view:(NSInteger)index
{
    Tuicang_View=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
//    [Tuicang_View setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.3]];
    [Tuicang_View setBackgroundColor:[UIColor clearColor]];
    
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [Tuicang_View addGestureRecognizer:tapSuperGesture22];
    TC_CenterView = [[UIView alloc] initWithFrame:CGRectMake(43*autoSizeScaleX_6, (SCREEN_HEIGHT-200)/2, SCREEN_WIDTH-(43*autoSizeScaleX_6*2), 200)];
    [TC_CenterView setBackgroundColor:[UIColor whiteColor]];
    TC_CenterView.layer.cornerRadius=4;
//    [Tuicang_View addSubview:TC_CenterView];
    tisp_lable=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-(38*autoSizeScaleX_6*2), 30)];
    [tisp_lable setText:@"Notice"];
    [tisp_lable setFont:[UIFont boldSystemFontOfSize:30]];
    tisp_lable.font = [UIFont systemFontOfSize:14];
    //文字居中显示
    tisp_lable.textAlignment = NSTextAlignmentCenter;
    
    miaoshu_lable=[[UILabel alloc] initWithFrame:CGRectMake(20, 25+15, TC_CenterView.width-(20*2), 125)];
    if(index==1)
    {
        [miaoshu_lable setText:FGGetStringWithKeyFromTable(@"This mail id PS120385738496084 has been registered, please modify the letter info you have registered.", @"Language")];
    }else if(index==2)
    {
        [miaoshu_lable setText:FGGetStringWithKeyFromTable(@"This mail id PS120385738496084 has been used, please change another one !", @"Language")];
    }
    miaoshu_lable.font = [UIFont systemFontOfSize:14];
    miaoshu_lable.textColor =[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    //文字居中显示
    miaoshu_lable.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    miaoshu_lable.numberOfLines = 0;
    back_btn = [[UIButton alloc] initWithFrame:CGRectMake(15, TC_CenterView.height-45, 120, 30)];
    [back_btn setTitle:FGGetStringWithKeyFromTable(@"Cancel post", @"Language") forState:UIControlStateNormal];
    [back_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [back_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    back_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    back_btn.layer.cornerRadius=15;
    back_btn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0].CGColor;//设置边框颜色
    back_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [back_btn addTarget:self action:@selector(Touch_two:) forControlEvents:UIControlEventTouchDown];
    Come_btn = [[UIButton alloc] initWithFrame:CGRectMake((TC_CenterView.width-150)/2, TC_CenterView.height-45, 150, 30)];
    NSLog(@"%f,%d,%d,%d",(TC_CenterView.width-150)/2, 200-45, 150, 30);
    if(index==1)
    {
        [Come_btn setTitle:FGGetStringWithKeyFromTable(@"OK, go to modify", @"Language") forState:UIControlStateNormal];
        Come_btn.tag=1002;  ///
        back_btn.hidden=YES;
        Come_btn.frame = CGRectMake((TC_CenterView.width-150)/2, 200-45, 150, 30);
    }else if(index==2)
    {
        [Come_btn setTitle:FGGetStringWithKeyFromTable(@"OK, go to modify", @"Language") forState:UIControlStateNormal];
        Come_btn.tag=1001;  ///
        back_btn.hidden=NO;
        Come_btn.frame = CGRectMake((TC_CenterView.width-120-15), 200-45, 120, 30);
    }
    
    [Come_btn setBackgroundColor:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0]];
    [Come_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    Come_btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    Come_btn.layer.cornerRadius=15;
    Come_btn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0].CGColor;//设置边框颜色
    Come_btn.layer.borderWidth = 1.0f;//设置边框颜色
    [Come_btn addTarget:self action:@selector(Touch_one:) forControlEvents:UIControlEventTouchDown];
    
    [TC_CenterView addSubview:tisp_lable];
    [TC_CenterView addSubview:miaoshu_lable];
    [TC_CenterView addSubview:Come_btn];
    [TC_CenterView addSubview:back_btn];
    [Tuicang_View addSubview:TC_CenterView];
    [self.view addSubview:Tuicang_View];
    [self show_TCview];
    [self.manager stopRunning];
    [self.manager videoPreviewLayerRemoveFromSuperlayer];
}

-(void)show_TCview
{
    [UIView animateWithDuration:(0.5)/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View.frame=self.view.bounds;
    }];
    
}
-(void)hidden_TCview
{
    [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
        //执行的动画
        self->Tuicang_View.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self->Tuicang_View removeFromSuperview];
    }];
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    CGPoint location = [gesture locationInView:Tuicang_View];
//    CGRect rec = [self.view convertRect:TC_CenterView.frame   fromView:Tuicang_View];
////    NSLog(@"%@",NSStringFromCGRect(rec));
//    NSLog(@"location.x== %f,location.y== %f,",location.x,location.y);
//    NSLog(@"x== %f,y== %f,",rec.origin.x,rec.origin.y);
//    if(location.x<TC_CenterView.left)
//    {
//            [self hidden_TCview];
//            [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
//
//    }
}
-(void)Touch_one:(UIButton*)sender
{

    [self.manager startRunning];
    [self setupQRCodeScanning];
    [self hidden_TCview];
    [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
}
-(void)Touch_two:(id)semder
{
    [self hidden_TCview];
    [Tuicang_View removeGestureRecognizer:tapSuperGesture22 ];
//    [self pushDetailsListViewController];
    [self.navigationController popViewControllerAnimated:YES];
}


@end


