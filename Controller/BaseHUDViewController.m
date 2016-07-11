//
//  HUDViewController.m
//  BaseProduct
//
//  Created by yingjian on 16/7/11.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseHUDViewController.h"

@interface BaseHUDViewController ()
{
    MBProgressHUD *HUD;
    BOOL loading;
}

@end

@implementation BaseHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delayTime = 2.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    loading = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    loading = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HUD

#pragma mark - 一直显示的HUD

- (void)showHUD:(NSString *)text
{
    [self showHUDInView:text view:self.view];
}

- (void)showHUDInWindow:(NSString *)text
{
    UIWindow *tempKeyboardWindow = [UIApplication sharedApplication].keyWindow;
    [self showHUDInView:text view:tempKeyboardWindow];
}

- (void)showHUDInView:(NSString *)text view:(UIView *)view
{
    if (HUD) {
        [self hideHUD];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelFont = [UIFont systemFontOfSize:15];
    [view addSubview:HUD];
    if (text){
        HUD.labelText = text;
    }
    HUD.removeFromSuperViewOnHide = YES;
    [HUD show:YES];
}

#pragma mark - 显示固定时间的HUD

- (void)showCompletedHUD:(NSString *)text
{
    if (!text || [text empty]) {
        return;
    }
    [self showHUDWithImage:nil withText:text];
}

- (void)showHUDWithImage:(NSString *)imgName withText:(NSString *)text
{
    UIWindow *tempKeyboardWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view = tempKeyboardWindow;
    
    loading = NO;
    if (HUD) {
        [self hideHUD];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.mode = MBProgressHUDModeCustomView;
    if (imgName) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    }
    [view addSubview:HUD];
    
    UITapGestureRecognizer *recognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD)];
    [HUD addGestureRecognizer:recognizer];
    
    if (text) {
        HUD.detailsLabelText = text;
    }
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:self.delayTime];
}

- (void)hideHUD
{
    loading = NO;
    [HUD hide:YES];
    [HUD.customView removeFromSuperview];
    HUD = nil;
}

- (BOOL)isHUDShowing
{
    return HUD && ![HUD isHidden];
}

@end
