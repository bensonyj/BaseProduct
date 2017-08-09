//
//  UIResponder+Router.m
//  SmartHome
//
//  Created by yingjian on 2017/7/27.
//  Copyright © 2017年 yingjian. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
