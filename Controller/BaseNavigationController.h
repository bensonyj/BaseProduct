//
//  BaseNavigationController.h
//  BaseProduct
//
//  Created by yj on 16/1/19.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

@property (nonatomic, assign) BOOL canDragBack;

@end

@interface UINavigationItem (Additions)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;

@end
