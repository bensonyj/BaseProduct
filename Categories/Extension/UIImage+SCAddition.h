//
//  UIImage+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SCAddition)

/** 图片方向调整 */
- (UIImage *)fixOrientation;

/** 图片不透明 */
- (UIImage *)transparent;

/** 图片大小调整，等比例缩放 */
- (UIImage *)resize:(CGSize)newSize;

/** 图片缩放,指定大小 */
- (UIImage *)scaleTo:(CGSize)size;
/** 图片等比例缩小,指定最大大小 */
- (UIImage *)scaleDown:(CGSize)maxSize;

/** 图片拉伸 */
- (UIImage *)stretched;
/** 图片拉伸,指定拉伸区域位置 */
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

/** 图片旋转,指定旋转角度 */
- (UIImage *)rotate:(CGFloat)angle;
- (UIImage *)rotateCW90;
- (UIImage *)rotateCW180;
- (UIImage *)rotateCW270;

/** 图片裁剪,指定裁剪区域 */
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)cropSquare;

/** 两张图片合并 */
- (UIImage *)merge:(UIImage *)image;
/** 多张图片合并 */
+ (UIImage *)merge:(NSArray *)images;

/** 图片数据 */
- (NSData *)dataWithExt:(NSString *)ext;

/** 图片样式颜色 */
- (UIColor *)patternColor;

- (CGFloat)width;
- (CGFloat)height;

/** 根据颜色创建图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 圆角图片，指定角度 */
- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)cornerRadius;
/** 转圆形图片 */
- (UIImage *)circleImage;

/**
 *  @param icon         头像图片名称
 *  @param borderImage  边框的图片名称
 *  @param border       边框大小
 *
 *  @return 圆形的头像图片
 */
- (UIImage *)imageWithIconName:(NSString *)icon borderImage:(NSString *)borderImage border:(CGFloat)border;

@end
