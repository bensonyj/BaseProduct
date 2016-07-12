//
//  HUDViewController.h
//  BaseProduct
//
//  Created by yingjian on 16/7/11.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseHUDViewController : BaseViewController

/** 显示hud后隐藏，默认2秒 */
@property (nonatomic, assign) NSTimeInterval delayTime;
/** 网络数据加载提示框延时弹出,默认0.5秒 */
@property (nonatomic, assign) NetworkRequestGraceTimeType requestGraceTimeType;
/**
 *  在当前页面显示hud
 */
- (void)showHUD:(NSString*)text;

/**
 *  在制定view中显示hud
 *
 *  @param text 文本内容
 *  @param view 需在view显示
 */
- (void)showHUDInView:(NSString*)text view:(UIView*)view;
/**
 *  在keyWindow上显示hud
 *
 *  @param text 内容
 */
- (void)showHUDInWindow:(NSString*)text;

/**
 *  显示固定时间后隐藏
 */
- (void)showCompletedHUD:(NSString *)text;

/**
 *  显示固定时间后隐藏
 *
 *  @param imgName 图片
 *  @param text    内容
 */
- (void)showHUDWithImage:(NSString*)imgName withText:(NSString *)text;

- (void)hideHUD;
-(BOOL)isHUDShowing;

@end
