//
//  UserInfo.h
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/22.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : BaseModel

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *session_key;
@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *is_reg;
@property (nonatomic, copy) NSString *gmt_create;
@property (nonatomic, copy) NSString *gmt_modified;
@property (nonatomic, copy) NSString *global_user_id;

@property (nonatomic, copy) NSString *area_code;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *area_detail;

@property (nonatomic, copy) NSString *birthday;

@end
