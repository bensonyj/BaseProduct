//
//  YJAlertView.h
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/20.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAlertView : UIView

- (void)show;

- (void)dismissAlertView;


/** 加载自定义view，点击遮罩层是否关闭 */
- (instancetype)initWithCustomView:(UIView *)customView dismissWhenTouchedBackground:(BOOL)dismissWhenTouchBackground;

@end
