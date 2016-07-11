//
//  UserInfo.m
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/22.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bid":@"id"};
}

- (void)mj_keyValuesDidFinishConvertingToObject
{
    //模型解析完毕后可操作
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    UserInfo *info = [[self class] allocWithZone:zone];
    info.bid = self.bid;
    info.user_id = self.user_id;
    info.mobile = self.mobile;
    info.nickname = self.nickname;
    info.sex = self.sex;
    info.avatar_url = self.avatar_url;
    info.session_key = self.session_key;
    info.user_name = self.user_name;
    info.is_reg = self.is_reg;
    info.gmt_create = self.gmt_create;
    info.gmt_modified = self.gmt_modified;
    info.global_user_id = self.global_user_id;
    info.area_code = self.area_code;
    info.city_code = self.city_code;
    info.area_detail = self.area_detail;
    info.birthday = self.birthday;
    
    return info;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.bid = [aDecoder decodeObjectForKey:@"bid"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.avatar_url = [aDecoder decodeObjectForKey:@"avatar_url"];
        self.session_key = [aDecoder decodeObjectForKey:@"session_key"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.is_reg = [aDecoder decodeObjectForKey:@"is_reg"];
        self.gmt_create = [aDecoder decodeObjectForKey:@"gmt_create"];
        self.gmt_modified = [aDecoder decodeObjectForKey:@"gmt_modified"];
        self.global_user_id = [aDecoder decodeObjectForKey:@"global_user_id"];
        self.area_code = [aDecoder decodeObjectForKey:@"area_code"];
        self.city_code = [aDecoder decodeObjectForKey:@"city_code"];
        self.area_detail = [aDecoder decodeObjectForKey:@"area_detail"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bid forKey:@"bid"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.avatar_url forKey:@"avatar_url"];
    [aCoder encodeObject:self.session_key forKey:@"session_key"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.is_reg forKey:@"is_reg"];
    [aCoder encodeObject:self.gmt_create forKey:@"gmt_create"];
    [aCoder encodeObject:self.gmt_modified forKey:@"gmt_modified"];
    [aCoder encodeObject:self.global_user_id forKey:@"global_user_id"];
    [aCoder encodeObject:self.area_code forKey:@"area_code"];
    [aCoder encodeObject:self.city_code forKey:@"city_code"];
    [aCoder encodeObject:self.area_detail forKey:@"area_detail"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    
}

@end
