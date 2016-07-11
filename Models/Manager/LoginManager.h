//
//  LoginManager.h
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/22.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

typedef void (^FinishBlock)(UserInfo *user, NSString *errorMsg);

@interface LoginManager : NSObject

@property (nonatomic, assign, getter=isLogined) BOOL logined;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) UserInfo *user;

/**
 *  @brief  消息未读记录数
 */
@property (nonatomic, assign) NSUInteger unReadCount;

+ (LoginManager *)shareManager;

/**
 *  @brief  登录成功后，自动获取用户信息
 */
- (void)loginWithName:(NSString *)name
             password:(NSString *)password
               finish:(FinishBlock)finish;

/**
 *  查询用户详细资料
 *
 *  @param finish 用户信息回调
 */
- (void)getUserDetailFinish:(FinishBlock)finish;

/**
 *  修改用户信息
 *
 *  @param user   修改信息
 *  @param finish 回调
 */
- (void)updateUserInfo:(UserInfo *)user finish:(FinishBlock)finish;

/**
 *  退出
 */
- (void)loginOut;

/**
 *  保存用户信息
 */
- (void)saveUserInfo;


@end
