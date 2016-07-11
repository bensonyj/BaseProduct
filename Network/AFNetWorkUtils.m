#import "AFNetWorkUtils.h"
#import "AFNetWorking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MBProgressHUD.h"
#import "IPAddress.h"
#import "UIDevice+SCAddition.h"

NSString *const netWorkUtilsDomain = @"http://AFNetWorkUtils";

NSString *const operationInfoKey = @"operationInfoKey";

@implementation AFNetWorkUtils

// @interface

#define kLastWindow [UIApplication sharedApplication].keyWindow

#define DEFINE_SINGLETON_INTERFACE(className) \
+ (className *)shared##className;


#define DEFINE_SINGLETON_IMPLEMENTATION(className) \
static className *shared##className = nil; \
static dispatch_once_t pred; \
\
+ (className *)shared##className { \
dispatch_once(&pred, ^{ \
shared##className = [[super allocWithZone:NULL] init]; \
if ([shared##className respondsToSelector:@selector(setUp)]) {\
[shared##className setUp];\
}\
}); \
return shared##className; \
} \
\
+ (id)allocWithZone:(NSZone *)zone { \
return [self shared##className];\
} \
\
- (id)copyWithZone:(NSZone *)zone { \
return self; \
}

DEFINE_SINGLETON_IMPLEMENTATION(AFNetWorkUtils)

- (void)setUp {
    self.netType = WiFiNet;
    self.netTypeString = @"WIFI";
}

/**
 * 创建网络请求管理类单例对象
 */
+ (AFHTTPSessionManager *)sharedHTTPOperationManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer new];
        manager.requestSerializer.timeoutInterval = 20.f;//超时时间为20s
        NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [acceptableContentTypes addObject:@"text/plain"];
        [acceptableContentTypes addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    });
    return manager;
}

- (void)startMonitoring {
    [[self startMonitoringNet] subscribeNext:^(id x) {
    }];
}

- (RACSignal *)startMonitoringNet {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    __weak __typeof(&*self) weakSelf = self;
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    weakSelf.netType = WiFiNet;
                    self.netType = WiFiNet;
                    self.netTypeString = @"WIFI";
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    weakSelf.netType = OtherNet;
                    weakSelf.netTypeString = @"2G/3G/4G";
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    weakSelf.netType = NONet;
                    weakSelf.netTypeString = @"网络已断开";
                    [[SDWebImageManager sharedManager] cancelAll];
                    break;
                    
                case AFNetworkReachabilityStatusUnknown:
                    weakSelf.netType = NONet;
                    weakSelf.netTypeString = @"其他情况";
                    break;
                default:
                    break;
            }
            [subscriber sendNext:weakSelf.netTypeString];
            //            [subscriber sendCompleted];
        }];
        return nil;
    }] setNameWithFormat:@"<%@: %p> -startMonitoringNet", self.class, self];
}

+ (NSDictionary *)baseParamsDict
{
    //版本信息
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    return infoDictionary;
//    return @{@"dev_model": [UIDevice deviceModel], //设备型号
//             @"dev_no": [UIDevice identifierUUIDString], //设备号
//             @"dev_plat": @"2", //设备平台，1-Android 2-Ios 3-Web
//             @"dev_ver": [UIDevice systemVersion], // 设备系统版本
//             @"ip_addr": [IPAddress getIPAddress:YES], //ip地址
//             @"soft_ver": [infoDictionary objectForKey:@"CFBundleShortVersionString"], //app版本号
//             @"token_id": [LoginManager shareManager].token,
//             @"user_id": [LoginManager shareManager].uid};
}

#pragma mark -RAC

/**
 *  转换成响应式请求 可重用 上传文件到指定服务器
 *
 *  @param url    请求地址
 *  @param params 请求参数
 *
 *  @return 带请求结果（字典）的信号
 */
+ (RACSignal *)racPOSTImageWithURL:(NSString *)url params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name{
    if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
        return [self getNoNetSignal];
    }
    
    //判断是否需要显示hud
    BOOL isNeedHud = YES;
    if ([url isEqualToString:@""]) {
        isNeedHud = NO;
    }
    
    url = [kAPIURL stringByAppendingString:url];
    
    
    NSLog(@"<%@: %p> -postImage2racWthURL: %@, params: %@", self.class, self, url, params);
    
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        
        NetworkRequestGraceTimeType type = isNeedHud ? NetworkRequestGraceTimeTypeNormal : NetworkRequestGraceTimeTypeNone;
        MBProgressHUD *hud = [self hud:type];
        
        AFHTTPSessionManager *manager = [self sharedHTTPOperationManager];
        
        NSURLSessionDataTask *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //把要上传的文件转成NSData
            //NSString*path=[[NSBundlemainBundle]pathForResource:@"123"ofType:@"txt"];
            //NSData*fileData = [NSDatadataWithContentsOfFile:path];
            //            [formData appendPartWithFileData:data name:name fileName:@"file" mimeType:@"image/jpeg"];//给定数据流的数据名，文件名，文件类型（以图片为例）
            [formData appendPartWithFileData:data name:name fileName:@"file" mimeType:@"application/octet-stream"];//给定数据流的数据名，文件名，文件类型（以图片为例）
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            hud.taskInProgress = NO;
            [hud hide:YES];
            
            [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 任务结束，设置状态
            hud.taskInProgress = NO;
            [hud hide:YES];
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            // 任务结束，设置状态
            hud.taskInProgress = NO;
            [hud hide:YES];
            
            [operation cancel];
        }];
    }] setNameWithFormat:@"<%@: %p> -postImage2racWthURL: %@, params: %@", self.class, self, url, params];
}

/**
 *  转换成响应式请求 可重用
 *
 *  @param url   请求地址
 *  @param params 请求参数
 *
 *  @return 带请求结果（字典）的信号
 */
+ (RACSignal *)racPOSTWthURL:(NSString *)url params:(NSDictionary *)params {
    if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
        return [self getNoNetSignal];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
//    这里组装body看API需求
//    1.
//    [dict addEntriesFromDictionary:[self baseParamsDict]];
//    if (params) {
//        [dict addEntriesFromDictionary:params];
//    }
    
//    2.
//    [dict setObject:params forKey:@"body"];
//    [dict setObject:[self baseParamsDict] forKey:@"header"];
    
    url = [kAPIURL stringByAppendingString:url];
    
    NSLog(@"<%@: %p> -post2racWthURL: %@, params: %@", self.class, self, url, params);
    
    
    BOOL isNeedHud = YES;
    if ([url isEqualToString:@""]) {
        isNeedHud = NO;
    }

    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NetworkRequestGraceTimeType type = isNeedHud ? NetworkRequestGraceTimeTypeNormal : NetworkRequestGraceTimeTypeNone;
        // 获取转圈控件,默认若是0.5秒数据返回则不显示转圈
        MBProgressHUD *hud = [self hud:type];
        
        AFHTTPSessionManager *manager = [self sharedHTTPOperationManager];
        NSURLSessionDataTask *operation = [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            // 任务结束，设置状态
            hud.taskInProgress = NO;
            [hud hide:YES];
            
            [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
        }                                         failure:^(NSURLSessionDataTask *operation, NSError *error) {
            // 任务结束，设置状态
            hud.taskInProgress = NO;
            [hud hide:YES];
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            // 任务结束，设置状态
            hud.taskInProgress = NO;
            [hud hide:YES];
            
            [operation cancel];
        }];
    }] setNameWithFormat:@"<%@: %p> -post2racWthURL: %@, params: %@", self.class, self, url, params];
}

+ (RACSignal *)racGETWthURL:(NSString *)url params:(NSDictionary *)params{
    return [[self racGETWthURL:url isJSON:YES params:params] setNameWithFormat:@"<%@: %p> -get2racWthURL: %@", self.class, self, url];
}

+ (RACSignal *)racGETUNJSONWthURL:(NSString *)url params:(NSDictionary *)params{
    return [[self racGETWthURL:url isJSON:NO params:params] setNameWithFormat:@"<%@: %p> -get2racUNJSONWthURL: %@", self.class, self, url];
}

+ (RACSignal *)racGETWthURL:(NSString *)url isJSON:(BOOL)isJSON params:(NSDictionary *)params {
    if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
        return [self getNoNetSignal];
    }
    
    NSLog(@"%@",url);
    //判断是否需要显示hud
    BOOL isNeedHud = YES;
    if ([url isEqualToString:@""]) {
        isNeedHud = NO;
    }
    
    //组织get请求
    NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString *key in params.allKeys) {
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
    }
    NSString *paramString = [paramArray componentsJoinedByString:@"&"];
    
    url = [NSString stringWithFormat:@"%@%@?%@",kAPIURL,url,paramString];
    
    NSLog(@"<%@: %p> -get2racWthURL: %@, params: %@", self.class, self, url, params);

    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [self sharedHTTPOperationManager];
        if (!isJSON) {
            manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        NSURLSessionDataTask *operation = [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            if (!isJSON) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                return;
            }
            [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
        }                                        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            if (!isJSON) {
                [subscriber sendNext:error];
                return;
            }
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

/**
 *  响应式post请求 返回处理后的结果 对象类型 可重用
 *
 *  @param url   请求地址
 *  @param params 请求参数
 *  @param clazz  字典对应的对象
 *
 *  @return 带请求结果（对象）的信号
 */
+ (RACSignal *)racPOSTWithURL:(NSString *)url params:(NSDictionary *)params class:(Class)clazz {
    if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
        return [self getNoNetSignal];
    }
    //有网络
    return [[[[self racPOSTWthURL:url params:params] map:^id(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            return [clazz mj_objectArrayWithKeyValuesArray:responseObject];
        } else {
            return [clazz mj_objectWithKeyValues:responseObject];
        }
    }] replayLazily] setNameWithFormat:@"<%@: %p> -racPOSTWithURL: %@, params: %@ class: %@", self.class, self, url, params, NSStringFromClass(clazz)];
}


+ (RACSignal *)racGETWithURL:(NSString *)url params:(NSDictionary *)params class:(Class)clazz {
    if ([AFNetWorkUtils sharedAFNetWorkUtils].netType == NONet) {
        return [self getNoNetSignal];
    }
    //有网络
    return [[[[self racGETWthURL:url params:params] map:^id(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            return [clazz mj_objectArrayWithKeyValuesArray:responseObject];
        } else {
            return [clazz mj_objectWithKeyValues:responseObject];
        }
    }] replayLazily] setNameWithFormat:@"<%@: %p> -racGETWithURL: %@,class: %@", self.class, self, url, NSStringFromClass(clazz)];
}

+ (RACSignal *)getNoNetSignal {
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        NSString *errorInfo = @"您的网络不给力，请重试！";
        userInfo[customErrorInfoKey] = errorInfo;
        
        NSError *error = [NSErrorHelper createErrorWithUserInfo:userInfo domain:netWorkUtilsDomain];
        [subscriber sendError:error];
        //        [subscriber sendError:[NSErrorHelper createErrorWithDomain:netWorkUtilsDomain code:kCFURLErrorNotConnectedToInternet]];
        return nil;
    }] setNameWithFormat:@"<%@: %p> -getNoNetSignal", self.class, self];
}

+ (void)handleErrorResultWithSubscriber:(id <RACSubscriber>)subscriber operation:(NSURLSessionDataTask *)operation error:(NSError *)error {
    NSLog(@"url:%@,params:%@",operation.originalRequest.URL,error);
    
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
    userInfo[operationInfoKey] = operation;
    userInfo[customErrorInfoKey] = [NSErrorHelper handleErrorMessage:error];
    [subscriber sendError:[NSErrorHelper createErrorWithUserInfo:userInfo domain:netWorkUtilsDomain]];
}

+ (void)handleResultWithSubscriber:(id <RACSubscriber>)subscriber operation:(NSURLSessionDataTask *)operation responseObject:(id)responseObject {
    //在此根据自己应用的接口进行统一处理
    
    NSLog(@"url:%@,params:%@",operation.originalRequest.URL,responseObject);
    NSDictionary *headerDic = [responseObject objectForKey:@"header"];
    NSDictionary *resultDic = headerDic[@"ret_result"];
    
    if ([resultDic[@"ret_code"] integerValue] == 0) {
        //正确返回，信息正确
//        if ([operation.originalRequest.URL isEqual:[NSURL URLWithString:[hostUrl stringByAppendingString:loginUrl]]]) {
//            //如果是登陆则将header一并返回。需要获取header中的token_id
//            [subscriber sendNext:responseObject];
//        }else{
            [subscriber sendNext:responseObject[@"body"]];
//        }
        [subscriber sendCompleted];
    }else{
        //正确返回，带有错误信息
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[operationInfoKey] = operation;
        NSString *errorInfo = ([resultDic[@"ret_code"] integerValue] != 0 ? resultDic[@"ret_msg"] : @"请求没有得到处理");
        userInfo[customErrorInfoKey] = errorInfo;
        NSError * error = [NSErrorHelper createErrorWithUserInfo:userInfo domain:netWorkUtilsDomain];
        
//        if ([resultDic[@"ret_code"] integerValue] == 65546) {
//            //登录过期
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginTimeout object:nil];
//        }
        
        [subscriber sendError:error];
    }
    
}

+ (NSString *)errorMessage:(NSError *)error
{
    return [error.userInfo objectForKey:customErrorInfoKey];
}

#pragma mark - hud延时弹框

+ (MBProgressHUD *)hud:(NetworkRequestGraceTimeType)graceTimeType{
    NSTimeInterval graceTime = 0;
    switch (graceTimeType) {
        case NetworkRequestGraceTimeTypeNone:
            return nil;
            break;
        case NetworkRequestGraceTimeTypeNormal:
            graceTime = 0.5;
            break;
        case NetworkRequestGraceTimeTypeLong:
            graceTime = 1.0;
            break;
        case NetworkRequestGraceTimeTypeShort:
            graceTime = 0.1;
            break;
        case NetworkRequestGraceTimeTypeAlways:
            graceTime = 0;
            break;
    }
    
    MBProgressHUD *hud = [self hud];
    [kLastWindow addSubview:hud];
    hud.graceTime = graceTime;
    
    // 设置该属性，graceTime才能生效
    hud.taskInProgress = YES;
    [hud show:YES];
    
    return hud;
}

// 网络请求频率很高，不必每次都创建\销毁一个hud，只需创建一个反复使用即可
+ (MBProgressHUD *)hud{
    MBProgressHUD *hud = objc_getAssociatedObject(self, _cmd);
    
    if (!hud) {
        // 参数kLastWindow仅仅是用到了其CGFrame，并没有将hud添加到上面
        hud = [[MBProgressHUD alloc] initWithWindow:kLastWindow];
        hud.labelText = @"加载中...";
        
        objc_setAssociatedObject(self, _cmd, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"创建了一个HUD");
    }
    return hud;
}


#pragma mark 显示信息
+ (void)show:(NSString *)text view:(UIView *)view
{
    if (!view){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

static NSString *const KAlwaysHUDKey = @"KAlwaysHUDKey";

+ (void)showAlways:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, &KAlwaysHUDKey);
    if (!hud) {
        if (!view){
            view = [[UIApplication sharedApplication].windows lastObject];
        }
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.removeFromSuperViewOnHide = NO;
        objc_setAssociatedObject(self, &KAlwaysHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"创建了一个KAlwaysHUDKey");
    }
    hud.labelText = text;
    
    [hud show:YES];
}

+ (void)hide
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, &KAlwaysHUDKey);
    if (hud) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        objc_setAssociatedObject(self, &KAlwaysHUDKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSLog(@"KAlwaysHUDKey被移除");
    }else{
        NSLog(@"hud还未创建");
    }
}

+ (MBProgressHUD *)showAlways:(NSString *)text view:(UIView *)view
{
    if (!view){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
