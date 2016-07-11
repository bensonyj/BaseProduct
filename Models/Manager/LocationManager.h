//
//  LocationManager.h
//  DoctorGan
//
//  Created by dianchu on 15/7/27.
//  Copyright (c) 2015年 Chutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@protocol LocationManagerDelegate <NSObject>

/** 定位位置变更 */
//- (void)locationChange:(BMKUserLocation *)userLocation;

@end

@interface LocationManager : NSObject

/** 维度 */
@property (nonatomic, strong) NSString *latitude;
/** 经度 */
@property (nonatomic, strong) NSString *longitude;
/** 定位信息 */
@property (nonatomic, strong) CLLocation *location;
/** 定位的省份名称 */
@property (nonatomic, strong) NSString *areaProvince;
/** 定位的城市名称 */
@property (nonatomic, strong) NSString *areaCity;
/** 定位的城市code */
@property (nonatomic, strong) NSString *areaCode;

/** 定位是否一直开启 */
@property (nonatomic, assign) BOOL isCanOpenLocationAlways;

+ (LocationManager *)shareManager;

/** 开始定位 */
- (void)viewWillAppear;
/** 取消代理 */
- (void)viewWillDisappear;

@property (nonatomic, weak) id<LocationManagerDelegate> delegate;

/** 定位检索成功 */
@property (nonatomic, copy) void (^locationGeoSuccessBlock) (LocationManager *locationInfo);
/** 定位失败 */
@property (nonatomic, copy) void (^locationGeoFailBlock) (NSString *tips);
/** 开始定位提示 */
@property (nonatomic, copy) void (^locationBeginBlock) (NSString *tips);

@end
