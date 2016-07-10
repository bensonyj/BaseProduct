//
//  QRCodeViewController.m
//  QRCodeDemo
//
//  Created by sunbb on 15-1-9.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

static const float kReaderViewWidth = 220;
static const float kReaderViewHeight = 220;
static const float kLineMinY = 93;
static const float kLineMaxY = kLineMinY + kReaderViewHeight;

@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
/** 回话 */
@property (nonatomic, strong) AVCaptureSession *qrSession;
/** 读取 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;
/** 交互线 */
@property (nonatomic, strong) UIImageView *line;
/** 交互线控制 */
@property (nonatomic, strong) NSTimer *lineTimer;

@end

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //背景
    self.view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    //摄像头
    [self setupDeviceInput];
    
    //布局子控件
    [self setOverlayPickerView];
    
    //开始扫描
    [self startQRCodeReading];
}

#pragma mark - 摄像头

- (void)setupDeviceInput
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device respondsToSelector:@selector(setVideoZoomFactor:)]) {
        if ([ device lockForConfiguration:nil]) {
            float zoomFactor = device.activeFormat.videoZoomFactorUpscaleThreshold;
            [device setVideoZoomFactor:zoomFactor];
            [device unlockForConfiguration];
        }
    }
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    [session setSessionPreset:AVCaptureSessionPresetPhoto];

    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
//    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode]];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //设置preview图层的属性
    //preview.borderColor = [UIColor redColor].CGColor;
    //preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    preview.frame = self.view.layer.bounds;
    //[preview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / SCREEN_HEIGHT, ((SCREEN_WIDTH - asize.width) / 2.0) / SCREEN_WIDTH, asize.height / SCREEN_HEIGHT, asize.width / SCREEN_WIDTH);
}

#pragma mark - 布局子控件
- (void)setOverlayPickerView
{
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - kReaderViewWidth) / 2.0, kLineMinY, kReaderViewWidth, 3)];
    [_line setImage:[UIImage imageNamed:@"img_scanning_bar"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kLineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左上角view
    UIImageView *topLeftView = [[UIImageView alloc] init];
    topLeftView.frame = CGRectMake((SCREEN_WIDTH - kReaderViewWidth) * 0.5, kLineMinY, 18, 18);
    topLeftView.image = [UIImage imageNamed:@"img_scanning_bg1"];
    [self.view addSubview:topLeftView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (SCREEN_WIDTH - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右上角view
    UIImageView *topRightView = [[UIImageView alloc] init];
    topRightView.frame = CGRectMake((SCREEN_WIDTH + kReaderViewWidth) * 0.5 - 18, kLineMinY, 18, 18);
    topRightView.image = [UIImage imageNamed:@"img_scanning_bg2"];
    [self.view addSubview:topRightView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = SCREEN_HEIGHT - kLineMaxY;
    
    //左下角view
    UIImageView *lowLeftView = [[UIImageView alloc] init];
    lowLeftView.frame = CGRectMake((SCREEN_WIDTH - kReaderViewWidth) * 0.5, CGRectGetMaxY(upView.frame) + kReaderViewHeight - 18, 18, 18);
    lowLeftView.image = [UIImage imageNamed:@"img_scanning_bg4"];
    [self.view addSubview:lowLeftView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, SCREEN_WIDTH, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //右下角view
    UIImageView *lowRightView = [[UIImageView alloc] init];
    lowRightView.frame = CGRectMake((SCREEN_WIDTH + kReaderViewWidth) * 0.5 - 18, CGRectGetMaxY(upView.frame) + kReaderViewHeight - 18, 18, 18);
    lowRightView.image = [UIImage imageNamed:@"img_scanning_bg3"];
    [self.view addSubview:lowRightView];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"请将二维码图像置于矩形框内";
    [self.view addSubview:labIntroudction];
}

#pragma mark - 输出代理方法

//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
        [self stopQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
        {
            NSLog(@"---------%@",obj.stringValue);
            
////            if ([obj.stringValue containsString:@"http"])
//            NSRange range = [obj.stringValue rangeOfString:@"http"];
//            if (range.location != NSNotFound)
//            {
//                if (self.QRCodeSuncessBlock) {
////                    self.QRCodeSuncessBlock(self,obj.stringValue);
//                    self.QRCodeSuncessBlock(obj.stringValue);
//                }
//            }
//            else
//            {
//                if (self.QRCodeFailBlock) {
//                    self.QRCodeFailBlock(self);
//                }
//            }
            if (self.QRCodeSuncessBlock) {
                self.QRCodeSuncessBlock(obj.stringValue);
            }

        }
        else
        {
            if (self.QRCodeFailBlock) {
                self.QRCodeFailBlock(self);
            }
        }
    }
    else
    {
        if (self.QRCodeFailBlock) {
            self.QRCodeFailBlock(self);
        }
    }
}

- (void)afreshBeginScan
{
    [self startQRCodeReading];
}

#pragma mark - 交互事件

- (void)startQRCodeReading
{
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    [self.qrSession startRunning];
    
    NSLog(@"start reading");
}

#pragma mark 停止扫描

- (void)stopQRCodeReading
{
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [self.qrSession stopRunning];
    
    NSLog(@"stop reading");
}

#pragma mark 取消扫描

- (void)cancleQRCodeReading
{
    [self stopQRCodeReading];
    
    if (self.QRCodeCancleBlock)
    {
        self.QRCodeCancleBlock(self);
    }
    NSLog(@"cancle reading");
}


#pragma mark - 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= kLineMinY)
        {
            if (_line.frame.origin.y >= kLineMaxY - 12)
            {
                frame.origin.y = kLineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
}

- (void)dealloc
{
    if (_qrSession) {
        [_qrSession stopRunning];
        _qrSession = nil;
    }
    
    if (_qrVideoPreviewLayer) {
        _qrVideoPreviewLayer = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

@end
