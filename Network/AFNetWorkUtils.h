#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "NSErrorHelper.h"
#import "NetJson.h"

@class MBProgressHUD;

typedef NS_ENUM(NSInteger, NetType) {
    NONet,
    WiFiNet,
    OtherNet,
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


@end
