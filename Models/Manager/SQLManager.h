//
//  SQLManager.h
//  NetHospital
//
//  Created by yj on 16/4/12.
//  Copyright © 2016年 TCGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaInfo.h"

@interface SQLManager : NSObject

+ (SQLManager *)shareManager;

/**
 *  获取所有省
 */
- (NSArray *)provinces;

/**
 *  获取省下面的所有市
 *
 *  @param province 选中的省
 *
 *  @return 省下面的市
 */
- (NSArray *)citiesWithProvince:(NSInteger)provinceCode;

/**
 *  根据市的名称返回市信息
 *
 *  @param AreaInfo 选中的市的code
 *
 *  @return 市名称
 */
- (AreaInfo *)getCityCode:(NSString *)cityName;

- (NSString *)getCityName:(NSString *)cityCode;


- (NSString *)getProvince:(NSString *)provinceCode;

@end
