//
//  UITabBarController+HideTabBar.m
//  SecondHand
//
//  Created by Richard on 14-5-26.
//  Copyright (c) 2014年 Dianchu. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"

@implementation UITabBarController (HideTabBar)

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:YES];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.tabBar.hidden == hidden)
        return;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    float height =  isLandscape ? screenSize.width : screenSize.height;
    
    if (!hidden)
        height -= CGRectGetHeight(self.tabBar.frame);
    
    void (^animations)();
    
    // Check if running iOS 7
    if ([self.tabBar respondsToSelector:@selector(barTintColor)])
    {
        
    }
    else
    {
        animations = ^{
            for (UIView *subview in self.view.subviews)
            {
                CGRect frame = subview.frame;
                
                if (subview == self.tabBar)
                {
                    frame.origin.y = height;
                }
                else
                {
                    frame.size.height = height;
                }
                
                subview.frame = frame;
            }
        };
    }
    
    [UIView animateWithDuration:(animated ? 0.25f : 0) animations:animations completion:^(BOOL finished) {
        self.tabBar.hidden = hidden;
    }];
}
@end
