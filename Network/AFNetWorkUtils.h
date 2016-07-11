#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "NSErrorHelper.h"
@class MBProgressHUD;

typedef NS_ENUM(NSInteger, NetType) {
    NONet,
    WiFiNet,
    OtherNet,
};

// 网络提示框的出现时机，若干秒后网络数据还未返回则出现提示框
typedef NS_ENUM(NSUInteger, NetworkRequestGraceTimeType){
    NetworkRequestGraceTimeTypeNormal,  // 0.5s
    NetworkRequestGraceTimeTypeLong,    // 1s
    NetworkRequestGraceTimeTypeShort,   // 0.1s
    NetworkRequestGraceTimeTypeNone,     // 没有提示框，处理默认加载修改等情况
    NetworkRequestGraceTimeTypeAlways   // 总是有提示框
};

@interface AFNetWorkUtils : NSObject

@property(nonatomic, assign) NSInteger netType;

@property(nonatomic, strong) NSString *netTypeString;

+ (AFNetWorkUtils *)sharedAFNetWorkUtils;

- (void)startMonitoring;

- (RACSignal *)startMonitoringNet;

+ (RACSignal *)racPOSTImageWithURL:(NSString *)url params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name;

+ (RACSignal *)racPOSTWthURL:(NSString *)url params:(NSDictionary *)params;

+ (RACSignal *)racPOSTWithURL:(NSString *)url params:(NSDictionary *)params class:(Class)clazz;

+ (RACSignal *)racGETUNJSONWthURL:(NSString *)url params:(NSDictionary *)params;

+ (RACSignal *)racGETWthURL:(NSString *)url params:(NSDictionary *)params;

+ (RACSignal *)racGETWithURL:(NSString *)url params:(NSDictionary *)params class:(Class)clazz;

#pragma mark - 直接解析错误信息

+ (NSString *)errorMessage:(NSError *)error;

#pragma mark 显示信息
//显示1秒自动消失
+ (void)show:(NSString *)text view:(UIView *)view;

//一直显示
+ (MBProgressHUD *)showAlways:(NSString *)text view:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;

+ (void)showAlways:(NSString *)text toView:(UIView *)view;
+ (void)hide;

@end
