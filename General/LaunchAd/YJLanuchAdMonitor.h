//
//  YJLanuchAdMonitor.h
//  FootballLotteryMaster
//
//  Created by yj on 16/2/26.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString 

@interface YJLanuchAdMonitor : NSObject

+ (void)showImageOnView:(UIView *)container timeInterval:(NSTimeInterval)interval finish:(void(^)())finish;

+ (void)removeStartPic;

@end
