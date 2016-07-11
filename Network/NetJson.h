//
//  NetJson.h
//  BaseProduct
//
//  Created by yingjian on 16/7/11.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <Foundation/Foundation.h>

//假定API返回数据如下
//{
//    data : { // 请求数据，对象或数组均可
//      user_id: 123,
//      user_name: "tutuge",
//      user_avatar_url: "http://tutuge.me/avatar.jpg"
//        ...
//    },
//    msg : "done", // 请求状态描述，调试用
//    code: 0, // 业务自定义状态码(0:正确,1:错误,10001:登录过期)
//}

@interface NetJson : NSObject

/** 返回码 */
@property (nonatomic, assign) NSInteger code;
/** 返回请求描述 */
@property (nonatomic, copy) NSString *msg;
/** 返回数据(可对象、数组、字符串) */
@property (nonatomic, strong) id data;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
