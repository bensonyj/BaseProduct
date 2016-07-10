//
//  YJAlertView.m
//  FootballLotteryMaster
//
//  Created by 应剑 on 16/2/20.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "YJAlertView.h"

@interface YJAlertView ()

/** 点击遮罩层是否关闭 */
@property (nonatomic, assign) BOOL dismissWhenTouchBackground;

@end

@implementation YJAlertView
{
    UIImageView *_gpuImgView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _gpuImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _gpuImgView.userInteractionEnabled = YES;
        [_gpuImgView setBackgroundColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5]];
        
        self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        self.dismissWhenTouchBackground = YES;
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView dismissWhenTouchedBackground:(BOOL)dismissWhenTouchBackground
{
    if (self = [super initWithFrame:customView.bounds]) {
        _gpuImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _gpuImgView.userInteractionEnabled = YES;
        [_gpuImgView setBackgroundColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5]];

        [self addSubview:customView];
        self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        self.dismissWhenTouchBackground = dismissWhenTouchBackground;
    }
    return self;

}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dismissAlertView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.hidden = YES;
        [_gpuImgView removeFromSuperview];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
-(void)startAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        _gpuImgView.alpha = 1.0;
    }];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.layer addAnimation:popAnimation forKey:nil];
}
- (void)show
{
    if (self.dismissWhenTouchBackground) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertView)];
        gesture.numberOfTapsRequired = 1;
        [_gpuImgView addGestureRecognizer:gesture];
    }
    
    _gpuImgView.alpha = 0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_gpuImgView];
    
    [keyWindow addSubview:self];
    [self setCenter:keyWindow.center];
    [self startAnimation];
}

@end
