//
//  UpdateManager.m
//  NetHospital
//
//  Created by 应剑 on 16/4/10.
//  Copyright © 2016年 TCGroup. All rights reserved.
//

#import "UpdateManager.h"
#import "AFNetWorkUtils.h"
#import "JXTAlertTools.h"

@implementation UpdateManager

+ (UpdateManager *)shareManager
{
    static UpdateManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UpdateManager alloc] init];
    });
    
    return manager;
}

- (void)checkServiceVersion
{
    NSString *curr_version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]?:@"";
    
    @weakify(self);
    [[AFNetWorkUtils racGETUNJSONWthURL:@"" params:@{@"os":@"ios",@"curr_version":curr_version}] subscribeNext:^(NSDictionary *dataDic) {
        @strongify(self);
        [self showUpdateAlert:dataDic];
    } error:^(NSError *error) {
        NSLog(@"%@",[AFNetWorkUtils errorMessage:error]);
    }];
}

- (void)showUpdateAlert:(NSDictionary *)jsonData
{
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *serverVersion = [jsonData objectForKey:@"v"];
    if(serverVersion && [currentVersion compare:serverVersion options:NSNumericSearch] == NSOrderedAscending)
    {
        NSString *intro = [jsonData objectForKey:@"dc"];
        if(!intro || [intro isEqual:[NSNull null]])
            intro = @"当前有更新版本，点击确定升级";
        
        NSInteger forceUpdate = [[jsonData objectForKey:@"s"] integerValue];
        NSString *updateUrl = [jsonData objectForKey:@"d"];//@"https://itunes.apple.com/cn/app/yin-xiu-mei-rong-chao-shi/id998246288?l=en&mt=8";//
        if(updateUrl && ![updateUrl isEqual:[NSNull null]] ){
            if (forceUpdate != 1) {
                NSString *cancelString = (forceUpdate != 2 ? @"取消": nil);
                [JXTAlertTools showAlertWith:[JXTAlertTools activityViewController] title:@"更新提示" message:intro callbackBlock:^(NSInteger btnIndex) {
                    if (cancelString && btnIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                    }
                } cancelButtonTitle:cancelString destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
            }
        }
    }
    
}


@end
