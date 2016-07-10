//
//  SpecialFunctions.m
//  BaseProduct
//
//  Created by yj on 16/1/21.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "SpecialFunctions.h"

@implementation SpecialFunctions

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//将view 转image
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//title和image同一列的button
+ (UIButton *)getColumnButtonWithTitle:(NSString *)title ImageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height + 20);
    
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    //    CGSize imageSize = button.imageView.frame.size;
    //    CGSize labelSize = button.titleLabel.frame.size;
    //
    //
    //    button.imageEdgeInsets = UIEdgeInsetsMake(-imageSize.height/2.0, labelSize.width/2.0, imageSize.height/2.0, -labelSize.width/2.0);
    //    button.titleEdgeInsets = UIEdgeInsetsMake(labelSize.height/2.0 + 7*SCREEN_HEIGHTSCALE, -imageSize.width/2.0, -labelSize.height/2.0, imageSize.width/2.0);
    
    CGFloat offset = 7;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height-offset, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-offset, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    
    return button;
}

@end
