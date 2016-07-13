//
//  BaseViewController.h
//  BaseProduct
//
//  Created by yj on 16/1/19.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "NSString+BeeExtension.h"
#import "JXTAlertTools.h"
#import "UIView+Utils.h"
#import "UIImage+SCAddition.h"
#import "AFNetWorkUtils.h"
#import "LoginManager.h"

@interface BaseViewController : UIViewController
{
    NSInteger topHeight;
}

/** 无数据时button事件 */
@property (nonatomic, copy) void(^buttonClick)(NSString *title);
///** 需要在viewWillDisappear销毁信号的 */
//@property (nonatomic, strong) NSMutableArray *disposes;

- (void)customBackBarButtonItem;
- (void)backBarButtonItemClick:(UIBarButtonItem *)barItem;

- (UIBarButtonItem *)createBarItemWithImage:(NSString *)imageName;
- (UIButton *)createBarItemButton:(NSString *)title;

/**
 *  @brief  获取、刷新数据
 */
- (void)refreshData;

/**
 *  页面加载
 */
- (void)showDataLoadingView;
/**
 *  隐藏加载
 */
- (void)dismissDataLoadingView;

/**
 *  显示无网络提示
 */
- (void)showNotNetView;

/**
 *  隐藏无网络提示
 */
- (void)dismissNotNetView;

/**
 *  无数据时调用
 *
 *  @param imageName  显示的图片
 *  @param tipsArray  显示的内容提示数组
 *  @param titleArray 显示的按钮文字数组
 */
- (void)noDataShowImage:(NSString *)imageName tipsArray:(NSArray *)tipsArray buttonTitleArray:(NSArray *)titleArray;

/**
 *  有数据时调用
 */
- (void)hideNoDataView;

@end
