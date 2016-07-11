//
//  LoginManager.m
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/22.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "LoginManager.h"
#import "AFNetWorkUtils.h"

@implementation LoginManager

+ (LoginManager *)shareManager
{
    static LoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoginManager alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if(self){
        
        NSDictionary *data = [self unarchiveData];
        if (data != nil && [data count] > 0) {
            self.token = data[@"token"];
            self.uid = [NSString stringWithFormat:@"%@",data[@"uid"]];
            self.logined = YES;
            
            UserInfo *user = [data objectForKey:@"user"];
            self.user = user;
        }else{
            self.token = @"";
            self.uid = @"";
            if (!self.user) {
                self.user = [[UserInfo alloc] init];
            }
        }
    }
    return self;
}


- (void)loginWithName:(NSString *)name
             password:(NSString *)password
               finish:(FinishBlock)finish
{
    [self loginOut];
    
//    [[AFNetWorkUtils racPOSTWthURL:loginUrl params:@{@"mobile":name,@"password":password}] subscribeNext:^(NSDictionary *dataDic) {
//        self.user = [UserInfo mj_objectWithKeyValues:dataDic];
//        
//        self.uid = dataDic[@"global_user_id"];//self.user.user_id;
//        
//        NSString *local_id = dataDic[@"local_id"]?:@"";
//        self.token = ({
//            NSString *string = TCTOKENAPPID;
//            string = [[string stringByAppendingString:local_id] stringByAppendingString:TCTOKENKEY];
//            
//            string = [string SHA256];
//            
//            string;
//        });
//        
//        self.logined = YES;
//
//        [self saveUserInfo];
//        
//        finish(self.user, nil);
//    } error:^(NSError *error) {
//        finish(nil,[error.userInfo objectForKey:@"customErrorInfoKey"]);
//    }];
}

- (void)saveUserInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.token forKey:@"token"];
    [param setObject:self.uid forKey:@"uid"];
    [param setObject:self.user forKey:@"user"];
    [self archiveData:param];
}

- (void)loginOut
{
    [self cleanSaveData];
    self.uid = @"0";
    self.token = @"0";
    self.logined = NO;
    self.user = nil;
}

- (void)getUserDetailFinish:(FinishBlock)finish
{
//    [[AFNetWorkUtils racPOSTWthURL:userDetailUrl params:@{}] subscribeNext:^(NSDictionary *bodyDict) {
//        self.user = [UserInfo mj_objectWithKeyValues:bodyDict];
//        
//        self.uid = @(self.user.user_id).stringValue;
//        [self saveUserInfo];
//        finish(self.user, nil);
//    } error:^(NSError *error) {
//        finish(nil,[error.userInfo objectForKey:@"customErrorInfoKey"]);
//    }];
}

- (void)updateUserInfo:(UserInfo *)user finish:(FinishBlock)finish
{
//    [[AFNetWorkUtils racPOSTWthURL:modifyUserInfoUrl params:@{@"nick_name":user.nick_name,@"real_name":user.real_name,@"user_sex":user.user_sex,@"head_thumb":user.head_thumb,@"user_profile":user.user_profile}] subscribeNext:^(NSDictionary *bodyDict) {
//
//        self.user = user;
//        [self saveUserInfo];
//        finish(self.user, nil);
//    } error:^(NSError *error) {
//        finish(nil,[error.userInfo objectForKey:@"customErrorInfoKey"]);
//    }];
}


#pragma mark - 数据持久化

#define userLoginInfo [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Info.data"]
#define kArchiveFileName @"archiveFile.archive"


- (void)archiveData:(NSDictionary *)data
{
    NSString *filename = [userLoginInfo stringByAppendingPathComponent:kArchiveFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:userLoginInfo]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userLoginInfo withIntermediateDirectories:YES attributes:nil error:NULL];
        [self addSkipBackupAttributeToItemAtPath:userLoginInfo];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
            [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
        }
    }
    [NSKeyedArchiver archiveRootObject:data toFile:filename];
}

- (NSDictionary *)unarchiveData
{
    NSString *filename = [userLoginInfo stringByAppendingPathComponent:kArchiveFileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
}


- (void)cleanSaveData
{
    NSString *filename = [userLoginInfo stringByAppendingPathComponent:kArchiveFileName];
    [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
}

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: path]);
    
    NSURL *URL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
