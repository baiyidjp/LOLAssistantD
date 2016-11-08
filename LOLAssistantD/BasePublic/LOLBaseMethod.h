//
//  LOLBaseMethod.h
//  LOL Helper
//
//  Created by tztddong on 16/10/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOLBaseMethod : NSObject

/**
    根据文字字号获取lab高度
 */
+ (CGFloat)LabelHeightofString:(NSString *)str
                     withFont:(UIFont *)font
                    withWidth:(CGFloat)width;
/**
    根据文字字号获取lab宽度
 */
+ (CGFloat)LabelWidthOfString:(NSString *)str
                    withFont:(UIFont *)font
                  withHeight:(CGFloat)height;

/** 根据字符串日期转换成格式化时间 X分钟/小时... */
+ (NSString *)timeWithDate:(NSString *)stringDate;


/**
 X轴动画
 @param view 动画view
 @param from 起始位置
 @param to 结束为止
 @param duration 动画时间
 @param count 动画次数(0代表无限)
 */
+ (void)jp_XbaseAnimationWithView:(UIView *)view From:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration repeatCount:(NSInteger)count;

/**
 Y轴动画
 @param view 动画view
 @param from 起始位置
 @param to 结束为止
 @param duration 动画时间
 @param count 动画次数(0代表无限)
 */
+ (void)jp_YbaseAnimationWithView:(UIView *)view From:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration repeatCount:(NSInteger)count;
/**
 point动画
 @param view 动画view
 @param from 起始位置
 @param to 结束为止
 @param duration 动画时间
 @param count 动画次数(0代表无限)
 */
+ (void)jp_PointbaseAnimationWithView:(UIView *)view From:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration repeatCount:(NSInteger)count;

@end
