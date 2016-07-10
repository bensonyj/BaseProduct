//
//  UIButton+ExpandTouchBound.m
//  SecondHand
//
//  Created by Richard Shen on 14-3-10.
//  Copyright (c) 2014年 Dianchu. All rights reserved.
//

#import "UIButton+ExpandTouchBound.h"

@implementation UIButton (ExpandTouchBound)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // default returns YES if point is in bounds
    CGRect bounds = [self bounds];
    float responderSize = 44;
    if(bounds.size.width < responderSize && bounds.size.height < responderSize){
        CGFloat widthDelta = responderSize - bounds.size.width;
        CGFloat heightDelta = responderSize - bounds.size.height;
        // Enlarge the effective bounds to be 44 x 44 pt
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    }
    return CGRectContainsPoint(bounds, point);
}

@end
