//
//  TimerHelper.h
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/27.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimerKeyRegister           @"timer_register"       //用户注册
#define KTimerKeyForgotPassword     @"timer_forgotPwd"      //忘记密码
#define KTimerKeyChangePhone        @"timer_changePhone"    //修改手机号

@interface TimerHelper : NSObject

/**
 *  开启倒计时timer（会记录timer开始时间）
 *
 *  @param timerKey key
 *  @param tipLabel 展示倒计时的Label
 *
 *  @return timer实例
 */
+ (dispatch_source_t)startTimerWithKey:(NSString *)timerKey tipButton:(UIButton *)tipButton;

/**
 *  timer自动倒计时（如果没有开始时间，直接return）
 *
 *  @param timerKey key
 *  @param tipLabel 展示倒计时的Label
 *  @param forceStart 是否强制启动timer（如果是NO，则时间超过后不会启动新timer）
 *
 *  @return timer实例
 */
+ (dispatch_source_t)timerCountDownWithKey:(NSString *)timerKey tipButton:(UIButton *)tipButton forceStart:(BOOL)forceStart;

/**
 *  取消timer
 *
 *  @param timerKey key
 */
+ (void)cancelTimerByKey:(NSString *)timerKey;

@end
