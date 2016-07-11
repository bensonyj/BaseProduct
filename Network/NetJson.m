//
//  NetJson.m
//  BaseProduct
//
//  Created by yingjian on 16/7/11.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "NetJson.h"

@implementation NetJson

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.code = [dict[@"code"] integerValue];
            self.msg = dict[@"msg"];
            self.data = dict[@"data"];
        }else{
            self.code = 999999;
            self.msg = @"";
            self.data = nil;
        }
    }
    
    return self;
}

@end
