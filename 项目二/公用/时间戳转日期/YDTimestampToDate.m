//
//  YDTimestampToDate.m
//  ClickToHelp
//
//  Created by Candy on 16/11/16.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDTimestampToDate.h"

@implementation YDTimestampToDate

+ (NSString *)setDateStringWithTimestamp:(NSString *)timestampString {
    //时间戳转换为时间字符串
    NSTimeInterval interval=[timestampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    
    return dateString;
}

+ (NSDate *)setDateWithTimestamp:(NSString *)timestampString {
    //时间戳转换为date
    NSTimeInterval interval=[timestampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSString *)setTimestampWithDate:(NSString *)dateString {
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate * date = [dateformatter dateFromString:dateString];
    //转成时间戳
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"uuuuu= %@",timestamp);
    return timestamp;
}

//时间戳转日期&时间
+ (NSString *)setDateAndTimeStringTimestamp:(NSString *)timestampString {
    //时间戳转换为时间字符串
    NSTimeInterval interval=[timestampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    
    return timeStr;
}

@end
