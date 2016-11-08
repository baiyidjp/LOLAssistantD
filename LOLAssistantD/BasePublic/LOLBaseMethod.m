//
//  LOLBaseMethod.m
//  LOL Helper
//
//  Created by tztddong on 16/10/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "LOLBaseMethod.h"

@implementation LOLBaseMethod

+ (CGFloat)LabelHeightofString:(NSString *)str withFont:(UIFont *)font withWidth:(CGFloat)width
{
    if ([str isKindOfClass:[NSString class]]) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return rect.size.height;
    }
    return 0;
}

+ (CGFloat)LabelWidthOfString:(NSString *)str withFont:(UIFont *)font withHeight:(CGFloat)height
{
    if ([str isKindOfClass:[NSString class]]) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return rect.size.width;
    }
    return 0;
}

+ (NSString *)timeWithDate:(NSString *)stringDate
{
    NSDateFormatter *dateFormtter =[[NSDateFormatter alloc] init];
    dateFormtter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *d = [dateFormtter dateFromString:stringDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1; //转记录的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1; //获取当前时间戳
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    // 发表在一小时之内
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }else{
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    // 在一小时以上24小以内
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    // 发表在24以上10天以内
    //86400 = 60(分)*60(秒)*24(小时) 3天内
    else if (cha/86400>1&&cha/86400*3<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    // 发表时间大于10天
    else {
        [dateFormtter setDateFormat:@"yyyy-MM-dd"];
        timeString = [dateFormtter stringFromDate:d];
    }
    
    return timeString;

}

+ (void)jp_XbaseAnimationWithView:(UIView *)view From:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration repeatCount:(NSInteger)count{
    NSLog(@"%f",from);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = duration;
    animation.repeatCount= count;
    animation.autoreverses= YES;
    animation.fromValue= [NSNumber numberWithFloat:from];
    animation.toValue= [NSNumber numberWithFloat:to];
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)jp_YbaseAnimationWithView:(UIView *)view From:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration repeatCount:(NSInteger)count{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = duration;
    animation.repeatCount= count;
    animation.autoreverses= YES;
    animation.fromValue= [NSNumber numberWithFloat:from];
    animation.toValue= [NSNumber numberWithFloat:to];
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)jp_PointbaseAnimationWithView:(UIView *)view From:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration repeatCount:(NSInteger)count{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = duration;
    animation.repeatCount= count;
    animation.autoreverses= YES;
    animation.fromValue= [NSValue valueWithCGPoint:from];
    animation.toValue= [NSValue valueWithCGPoint:to];
    [view.layer addAnimation:animation forKey:nil];
}

@end
