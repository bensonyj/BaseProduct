//
//  UIViewController+Alert.h
//  SmartHome
//
//  Created by yingjian on 2017/6/19.
//  Copyright © 2017年 yingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message chooseBlock:(void(^)(NSInteger index))block bottonString:(NSString *)string, ... ;

@end
