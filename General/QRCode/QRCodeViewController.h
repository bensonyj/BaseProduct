//
//  SYQRCodeViewController.h
//  SYQRCodeDemo
//
//  Created by sunbb on 15-1-9.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property (nonatomic, copy) void (^QRCodeCancleBlock) (QRCodeViewController *);//扫描取消
//@property (nonatomic, copy) void (^QRCodeSuncessBlock) (QRCodeViewController *,NSString *);//扫描结果
@property (nonatomic, copy) void (^QRCodeSuncessBlock) (NSString *);//扫描结果

@property (nonatomic, copy) void (^QRCodeFailBlock) (QRCodeViewController *);//扫描失败


/**
 *  重新扫描
 */

- (void)afreshBeginScan;

@end
