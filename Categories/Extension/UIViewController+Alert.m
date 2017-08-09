//
//  UIViewController+Alert.m
//  SmartHome
//
//  Created by yingjian on 2017/6/19.
//  Copyright © 2017年 yingjian. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message chooseBlock:(void(^)(NSInteger index))block bottonString:(NSString *)string, ...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:2];
    [argsArray addObject:string];
    id arg;
    va_list argList;
    if(string)
    {
        va_start(argList,string);
        while ((arg = va_arg(argList,id)))
        {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < [argsArray count]; i++)
    {
        UIAlertActionStyle style =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
        // Create the actions.
        UIAlertAction *action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:style handler:^(UIAlertAction *action) {
            if (block) {
                block(i);
            }
        }];
        [alertController addAction:action];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
