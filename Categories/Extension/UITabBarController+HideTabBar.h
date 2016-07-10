//
//  UITabBarController+HideTabBar.h
//  SecondHand
//
//  Created by Richard on 14-5-26.
//  Copyright (c) 2014年 Dianchu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HideTabBar)

- (void)setTabBarHidden:(BOOL)hidden;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
