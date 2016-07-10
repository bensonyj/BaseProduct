//
//  YJLanuchAdMonitor.m
//  FootballLotteryMaster
//
//  Created by yj on 16/2/26.
//  Copyright © 2016年 yingjian. All rights reserved.
//

#import "YJLanuchAdMonitor.h"
#import "SDWebImageManager.h"
#import "AFNetWorkUtils.h"
#import "UIButton+SCAddition.h"

@interface YJLanuchAdMonitor ()


@end

static NSString* const LanchImageUrl = @"lanchImageUrl";

@implementation YJLanuchAdMonitor


+ (void)showImageOnView:(UIView *)container timeInterval:(NSTimeInterval)interval finish:(void (^)())finish
{
    //显示过度图片
    [self showImageOnView:container forTime:interval];
    
    //调用接口获取最新图片
    [self loadImageAtPath];
}

+ (void)showImageOnView:(UIView *)container forTime:(NSTimeInterval)time
{
    CGRect f = [UIScreen mainScreen].bounds;
    NSLog(@"screen size:%@", NSStringFromCGRect(f));
    UIView *v = [[UIView alloc] initWithFrame:f];
    v.backgroundColor = [UIColor whiteColor];
    
//    f.size.height -= 50;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:f];
    iv.image = [self getLanuchImage];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    [v addSubview:iv];
    
    [container addSubview:v];
    [container bringSubviewToFront:v];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.backgroundColor = HexRGBAlpha(0x000000, 0.3);
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    skipButton.frame = CGRectMake(f.size.width - 18 - 53, 10 + 18, 53, 22);
    skipButton.layer.cornerRadius = 11.0f;
    [skipButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:skipButton];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(skipButton.frame) - 10 - 21, CGRectGetMinY(skipButton.frame) + 1, 21, 21)];
    timeLabel.backgroundColor = skipButton.backgroundColor;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.layer.cornerRadius = 2.5;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.font = [UIFont systemFontOfSize:13.0];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    __block NSInteger number = 3;
    RAC(timeLabel, text) = [[[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:number] startWith:@(1)] map:^NSString *(NSDate * date) {
        return [NSString stringWithFormat:@"%ld", (long)number--];
    }];

    [v addSubview:timeLabel];
    
    [container addSubview:v];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v.userInteractionEnabled = NO;
        [UIView animateWithDuration:.25
                         animations:^{
                             v.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [v removeFromSuperview];
                         }];
    });
}

+ (void)skip:(id)sender
{
    UIView *sup = [(UIButton *)sender superview];
    sup.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25
                     animations:^{
                         sup.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [sup removeFromSuperview];
                     }];
}

+ (UIImage *)getLanuchImage
{
    UIImage *launchImage = nil;
    
    NSString *lastKey = [self getKey];
    if (lastKey) {
        launchImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:lastKey];
        if (!launchImage) {
            //当前启动图为空时重新加载
            [self removeStartPic];
            launchImage = [self launchImage];
        }
    }else{
        launchImage = [self launchImage];
    }
    
    return  launchImage;
}

+ (UIImage *)launchImage
{
    UIImage *launchImage = nil;

    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    
    return launchImage;
}

+ (void)loadImageAtPath
{
//    [[AFNetWorkUtils racPOSTWthURL:getStartPic  params:@{}] subscribeNext:^(NSDictionary *bodyDict) {
//        NSString *urlStr = bodyDict[@"start_pic"];
//        
//        if (![self validatePath:urlStr]) {
//            return;
//        }
//        
//        NSString *lastKey = [self getKey];
//        if ([urlStr isEqualToString:lastKey]) {
//            return;
//        }else{
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                //下载完成，保存图片到本地，删除原来存在的图片
//                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
//                [[SDImageCache sharedImageCache] removeImageForKey:lastKey];
//                [self saveKey:urlStr];
//            }];
//        }
//    } error:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}

+ (BOOL)validatePath:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path];
    return url != nil;
}

+ (NSString *)getKey
{
    NSString *lastKey = [[NSUserDefaults standardUserDefaults] objectForKey:LanchImageUrl];
    
    return lastKey;
}

+ (void)saveKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:LanchImageUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeStartPic
{
    //清除缓存时，更新key
    [self saveKey:@""];
}

@end
