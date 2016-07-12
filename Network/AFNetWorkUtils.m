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
    
    url = [kAPIURL stringByAppendingString:url];    
    
    NSLog(@"<%@: %p> -postImage2racWthURL: %@, params: %@", self.class, self, url, params);
    
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [self sharedHTTPOperationManager];
        
        NSURLSessionDataTask *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //把要上传的文件转成NSData
            //NSString*path=[[NSBundlemainBundle]pathForResource:@"123"ofType:@"txt"];
            //NSData*fileData = [NSDatadataWithContentsOfFile:path];
            //            [formData appendPartWithFileData:data name:name fileName:@"file" mimeType:@"image/jpeg"];//给定数据流的数据名，文件名，文件类型（以图片为例）
            [formData appendPartWithFileData:data name:name fileName:@"file" mimeType:@"application/octet-stream"];//给定数据流的数据名，文件名，文件类型（以图片为例）
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
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
    
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [self sharedHTTPOperationManager];
        NSURLSessionDataTask *operation = [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
        }                                         failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        return [RACDisposable disposableWithBlock:^{
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
    
    NetJson *netJson = [[NetJson alloc] initWithDict:responseObject];
    if (netJson.code == 0) {
        [subscriber sendNext:netJson];
    }else{
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[operationInfoKey] = operation;
        NSString *errorInfo = netJson.msg;
        userInfo[customErrorInfoKey] = errorInfo;
        NSError *error = [NSErrorHelper createErrorWithUserInfo:userInfo domain:netWorkUtilsDomain];
        
        if (netJson.code == 10001) {
            //登录超时或者多设备登录
            //可以用通知通知根视图
            //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginTimeout object:nil];
        }

        [subscriber sendError:error];
    }
}

+ (NSString *)errorMessage:(NSError *)error
{
    return [error.userInfo objectForKey:customErrorInfoKey];
}

@end
