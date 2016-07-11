////
////  LocationManager.m
////  DoctorGan
////
////  Created by dianchu on 15/7/27.
////  Copyright (c) 2015年 Chutong. All rights reserved.
////
//
//#import "LocationManager.h"
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//
//#import "SQLManager.h"
//
//@interface LocationManager ()<CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
//{
//    BMKLocationService *_locService;
//    BMKGeoCodeSearch *_geocodesearch;
//}
/////** 定位服务 */
////@property (nonatomic, strong) BMKLocationService *locService;
/////** geo搜索服务 */
////@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
//
//@end
//
//@implementation LocationManager
//
//+ (LocationManager *)shareManager
//{
//    static LocationManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[LocationManager alloc] init];
//    });
//    return manager;
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//#if TARGET_IPHONE_SIMULATOR
//        //模拟器
//        self.latitude = @"30.280558";
//        self.longitude = @"120.170317";
//        
//        self.areaCity = @"杭州市";
//        self.areaProvince = @"浙江省";
//#elif TARGET_OS_IPHONE
//        //真机
//        
//        // 判断定位操作是否被允许
//        if (![CLLocationManager locationServicesEnabled]) {
//            NSLog(@"系统定位功能未打开");
//        }
//        
//#endif
//        //开启百度地图SDK
//        BMKMapManager *mapManager = [[BMKMapManager alloc]init];
//        BOOL ret = [mapManager start:TCBaiDuAppKey generalDelegate:nil];
//        if (!ret) {
//            NSLog(@"manager start failed!");
//        }
//        
//        //默认取杭州市
//        AreaInfo *cityInfo = [[SQLManager shareManager] getCityCode:@"杭州市"];
//        self.areaCode = @(cityInfo.code).stringValue;
//        
//        
//        //初始化定位服务对象
//        _locService = [[BMKLocationService alloc] init];
//        //设置定位精确度
//        _locService.desiredAccuracy = kCLLocationAccuracyBest;
//        //指定最小距离更新(米)
//        _locService.distanceFilter = 100.0f;
//        
//        //geo搜索服务
//        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//        
//        self.isCanOpenLocationAlways = NO;
//    }
//
//    return self;
//}
//
//- (void)viewWillAppear
//{
//    _locService.delegate = self;
//    [_locService startUserLocationService];
//    _geocodesearch.delegate = self;
//    
//    if ([CLLocationManager locationServicesEnabled]) {
//        [self decideLocationEnabled];
//    }
//}
//
//- (void)viewWillDisappear
//{
//    self.isCanOpenLocationAlways = NO;
//    [_locService stopUserLocationService];
//    _locService.delegate = nil;
//    _geocodesearch.delegate = nil;
//}
//
//#pragma mark - 判断app定位服务是否开启
//- (void)decideLocationEnabled
//{
//    if (![LocationManager shareManager].latitude && ![LocationManager shareManager].longitude) {
//        
//        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//            
//            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//            locationManager.delegate = self;
//            
//            if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//            {
//                [locationManager requestAlwaysAuthorization]; // 永久授权
//            }
//            if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
//            {
//                [locationManager requestWhenInUseAuthorization]; //使用中授权
//            }
//            
//            //开始定位
//            [self beginLocate];
//            NSLog(@"开始定位1");
//            if (self.locationBeginBlock) {
//                self.locationBeginBlock(@"开始定位，请稍等");
//            }
//        }
//        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
//            //开始定位
//            [self beginLocate];
//            NSLog(@"开始定位2");
//        }
//        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
//            NSLog(@"app定位权限未开启");
//        }
//    }
//}
//
//- (void)beginLocate
//{
//    
//    _locService.delegate = self;
//    
//    //启动LocationService
//    [_locService startUserLocationService];
//    
//    //    [MBProgressHUD showMessage:@"请稍等，正在定位中..." toView:self.view];
//    if (self.locationBeginBlock) {
//        self.locationBeginBlock(@"请稍等，正在定位中...");
//    }
//
//    _geocodesearch.delegate = self;
//}
//
//#pragma mark - 实现相关delegate 处理位置信息更新
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined:
//            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//                [manager requestAlwaysAuthorization];
//            }
//            break;
//        default:
//            break;
//    }
//}
////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    NSLog(@"heading is %@",userLocation.heading);
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(locationChange:)]) {
//        [self.delegate locationChange:userLocation];
//    }
//}
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    CLLocation *currentLocation = userLocation.location;
//    
//    self.location = currentLocation;
//    
//    CLLocationCoordinate2D coor = currentLocation.coordinate;
//    self.latitude = [NSString stringWithFormat:@"%f",coor.latitude];
//    self.longitude = [NSString stringWithFormat:@"%f",coor.longitude];
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(locationChange:)]) {
//        [self.delegate locationChange:userLocation];
//    }
//
//    if (!self.isCanOpenLocationAlways) {
//        [_locService stopUserLocationService];
//    }
//    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    
//    //根据经纬度反向地理编译出地址信息
//    //先发起反geo搜索
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = coor;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//        if (self.locationGeoFailBlock) {
//            self.locationGeoFailBlock(@"定位失败");
//        }
//    }
//}
//
//- (void)didFailToLocateUserWithError:(NSError *)error
//{
//    NSLog(@"定位失败：%@",error);
//    [_locService stopUserLocationService];
//
//    if (self.locationGeoFailBlock) {
//        self.locationGeoFailBlock(@"定位失败");
//    }
//}
//
////geo搜索成功
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
//{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        // 获取当前所在的城市名
//        NSLog(@"当前:%@",result.address);
//        
//        //1.获取城市
//        self.areaProvince = result.addressDetail.province;
//        NSString *locationCity = result.addressDetail.city;
//        self.areaCity = locationCity;
//        
//        AreaInfo *cityInfo = [[SQLManager shareManager] getCityCode:locationCity];
//        self.areaCode = @(cityInfo.code).stringValue;
//        
//        NSLog(@"当前城市为---%@ %@,code为---%@",self.areaProvince,self.areaCity,self.areaCode);
//        
//        if (self.locationGeoSuccessBlock) {
//            self.locationGeoSuccessBlock(self);
//        }
//    }else{
//        NSLog(@"geo搜索失败");
//        if (self.locationGeoFailBlock) {
//            self.locationGeoFailBlock(@"定位失败");
//        }
//    }
//}
//    
//@end
