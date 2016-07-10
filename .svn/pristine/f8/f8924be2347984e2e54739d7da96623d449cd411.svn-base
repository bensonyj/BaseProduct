//
//  TimerHelper.m
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/27.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "TimerHelper.h"

/**
 *  Timer开始时间
 *  处理第二次进入View时自动进行倒计时显示
 */
static NSMutableDictionary *timerIntervals;
/**
 *  启动的Timer实例数组
 *  目前只用到短信发送倒计时功能上
 */
static NSMutableDictionary *timers;

/**
 *  验证码倒计时（单位：秒）
 */
const int kVerifyCodeCountDownSeconds = 60;


@implementation TimerHelper

+(double)timeIntervalForKey:(NSString *)timerKey {
    
    if (timerIntervals && [timerIntervals objectForKey:timerKey] != [NSNull null]) {
        return [[timerIntervals objectForKey:timerKey] doubleValue];
    }
    return 0;
}

+ (dispatch_source_t)startTimerWithKey:(NSString *)timerKey tipButton:(UIButton *)tipButton {
    
    //记录timer开始时间
    if (!timerIntervals) {
        timerIntervals = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    if (!timers) {
        timers = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    [timerIntervals setObject:@(CFAbsoluteTimeGetCurrent()) forKey:timerKey];
    //如果之前的timer存在，则将其cancel
    [self cancelTimerByKey:timerKey];
    
    return [self timerCountDownWithKey:timerKey tipButton:tipButton forceStart:YES];
}

+ (dispatch_source_t)timerCountDownWithKey:(NSString *)timerKey tipButton:(UIButton *)tipButton forceStart:(BOOL)forceStart {
    
    __block int timeout=0; //倒计时时间
    
    //调用startTimerWithKey方法会记录timer开始时间，如果没有timer开始时间则不开启新timer
    double timerInterval = [self timeIntervalForKey:timerKey];
    
    if (timerInterval <= 0) {
        return nil;
    }
    
    double interval = CFAbsoluteTimeGetCurrent() - timerInterval;
    if (interval < kVerifyCodeCountDownSeconds) {
        timeout = kVerifyCodeCountDownSeconds - (int)interval - 1;
    }
    
    if (timeout <= 0 && !forceStart) {
        [tipButton setTitle:@"重新发送" forState:UIControlStateNormal];
        return nil;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tipButton setTitle:@"重新发送" forState:UIControlStateNormal];
                tipButton.userInteractionEnabled = YES;
                tipButton.enabled = YES;
//                tipButton.layer.borderColor = COLOR_buttonNormal.CGColor;
                NSLog(@"____0");
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            int seconds = timeout % kVerifyCodeCountDownSeconds;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____%@",strTime);
                [tipButton setTitle:[NSString stringWithFormat:@"%@(%@)",@"重新获取",strTime] forState:UIControlStateNormal];
                tipButton.userInteractionEnabled = NO;
                tipButton.enabled = NO;
                tipButton.layer.borderColor = RGB(198, 196, 196).CGColor;
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
    
    
    [timers setObject:_timer forKey:timerKey];
    
    return _timer;
}

+(void)cancelTimerByKey:(NSString *)timerKey {
    
    dispatch_source_t timer = [timers objectForKey:timerKey];
    
    if (timer) {
        dispatch_source_cancel(timer);
        [timers removeObjectForKey:timerKey];
    }
}

@end
