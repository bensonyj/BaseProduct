//
//  UIResponder+Router.h
//  SmartHome
//
//  Created by yingjian on 2017/7/27.
//  Copyright © 2017年 yingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
