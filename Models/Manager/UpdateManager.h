//
//  UpdateManager.h
//  NetHospital
//
//  Created by 应剑 on 16/4/10.
//  Copyright © 2016年 TCGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateManager : NSObject

+ (UpdateManager *)shareManager;

/**
 *  与服务端比对检查是否升级
 */
- (void)checkServiceVersion;

@end
