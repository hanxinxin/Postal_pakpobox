//
//  如遇到问题或有更好方案，请通过以下方式进行联系
//      QQ群：429899752
//      Email：kingsic@126.com
//      GitHub：https://github.com/kingsic/SGQRCode
//
//  SGQRCodeScanManager.m
//  SGQRCodeExample
//
//  Created by kingsic on 2016/8/16.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "SGQRCodeScanManager.h"
#import "PostSGQViewController.h"
@interface SGQRCodeScanManager () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate>



///记录开始的缩放比例
@property(nonatomic,assign)CGFloat beginGestureScale;

///最后的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;

@property(nonatomic,assign)BOOL isVideoZoom;

@end

@implementation SGQRCodeScanManager

static SGQRCodeScanManager *_instance;

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)setupSessionPreset:(NSString *)sessionPreset metadataObjectTypes:(NSArray *)metadataObjectTypes currentController:(UIViewController *)currentController {
    
    if (sessionPreset == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"setupSessionPreset:metadataObjectTypes:currentController: 方法中的 sessionPreset 参数不能为空" userInfo:nil];
    }
    
    if (metadataObjectTypes == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"setupSessionPreset:metadataObjectTypes:currentController: 方法中的 metadataObjectTypes 参数不能为空" userInfo:nil];
    }
    
    if (currentController == nil) {
        @throw [NSException exceptionWithName:@"SGQRCode" reason:@"setupSessionPreset:metadataObjectTypes:currentController: 方法中的 currentController 参数不能为空" userInfo:nil];
    }

    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建摄像设备输入流
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、创建元数据输出流
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 3(1)、创建摄像数据输出流
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）;
    // 如需限制扫描框范围，打开下一句注释代码并进行相应调整
//    metadataOutput.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 4、创建会话对象
    _session = [[AVCaptureSession alloc] init];
    // 会话采集率: AVCaptureSessionPresetHigh
    _session.sessionPreset = sessionPreset;
    
    // 5、添加元数据输出流到会话对象
    [_session addOutput:metadataOutput];
    // 5(1)添加摄像输出流到会话对象；与 3(1) 构成识了别光线强弱
    [_session addOutput:_videoDataOutput];
    
    // 6、添加摄像设备输入流到会话对象
    [_session addInput:self.deviceInput];

    [_session addOutput:_stillImageOutput];
    [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    // 7、设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    // @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
    metadataOutput.metadataObjectTypes = metadataObjectTypes;
//    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
//                                           AVMetadataObjectTypeCode39Code,
//                                           AVMetadataObjectTypeCode128Code,
//                                           AVMetadataObjectTypeCode39Mod43Code,
//                                           AVMetadataObjectTypeEAN13Code,
//                                           AVMetadataObjectTypeEAN8Code,
//                                           AVMetadataObjectTypeCode93Code];
//    if(device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
//    {
//        [deviceInput.device setFocusMode:AVCaptureFocusModeAutoFocus];
//    }
    // 8、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 保持纵横比；填充层边界
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    _videoPreviewLayer.frame = CGRectMake(x, y, w, h);
    NSLog(@"class == %@  MMM== %@  bool= %d",[currentController class],[PostSGQViewController class],[NSStringFromClass([currentController class])isEqual:@"PostSGQViewController"]);
    if([NSStringFromClass([currentController class])isEqual:@"PostSGQViewController"])
    {
        PostSGQViewController * vc = (PostSGQViewController *)currentController;
//        [vc.playView.layer insertSublayer:_videoPreviewLayer atIndex:1];
        [vc.playView.layer addSublayer:_videoPreviewLayer];
    }else{
        [currentController.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
//        [currentController.view.layer addSublayer:_videoPreviewLayer];
    }
//     [currentController.view.layer addSublayer:_videoPreviewLayer];
    // 9、启动会话
    [_session startRunning];
}

- (void)setVideoScale:(CGFloat)scale ViewController:(UIViewController *)ViewA
{
    PostSGQViewController * vcAAA = (PostSGQViewController *)ViewA;
    [self.deviceInput.device lockForConfiguration:nil];
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    CGFloat maxScaleAndCropFactor = ([[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor])/16;
    
    if (scale > maxScaleAndCropFactor)
        scale = maxScaleAndCropFactor;
    
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    NSLog(@"scale= %f , zoom ===  %f  videoConnection= %f",scale,zoom,videoConnection.videoScaleAndCropFactor);
    videoConnection.videoScaleAndCropFactor = scale;
    
    [self.deviceInput.device unlockForConfiguration];
    
    CGAffineTransform transform = vcAAA.playView.transform;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    
//    ViewC.view.layer.transform = CGAffineTransformScale(transform, zoom, zoom);
    vcAAA.playView.transform = CGAffineTransformScale(transform, zoom, zoom);;
    
    [CATransaction commit];
}
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}
#pragma mark - - - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeScanManager:didOutputMetadataObjects:)]) {
        [self.delegate QRCodeScanManager:self didOutputMetadataObjects:metadataObjects];
    }
}

#pragma mark - - - AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 这个方法会时时调用，但内存很稳定
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
//    NSLog(@"%f",brightnessValue);

    if (self.delegate && [self.delegate respondsToSelector:@selector(QRCodeScanManager:brightnessValue:)]) {
        [self.delegate QRCodeScanManager:self brightnessValue:brightnessValue];
    }
}

- (void)startRunning {
    [_session startRunning];
}

- (void)stopRunning {
    [_session stopRunning];
}

- (void)videoPreviewLayerRemoveFromSuperlayer {
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)resetSampleBufferDelegate {
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
}

- (void)cancelSampleBufferDelegate {
    [_videoDataOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

- (void)playSoundName:(NSString *)name {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
void soundCompleteCallback(SystemSoundID soundID, void *clientData){

}


@end

