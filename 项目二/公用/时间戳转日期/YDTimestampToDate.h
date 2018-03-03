//
//  YDTimestampToDate.h
//  ClickToHelp
//
//  Created by Candy on 16/11/16.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDTimestampToDate : NSObject
//时间戳转日期
+ (NSString *)setDateStringWithTimestamp:(NSString *)timestampString;

//时间戳转date
+ (NSDate *)setDateWithTimestamp:(NSString *)timestampString;

//date转时间戳
+ (NSString *)setTimestampWithDate:(NSString *)dateString;

//时间戳转日期&时间
+ (NSString *)setDateAndTimeStringTimestamp:(NSString *)timestampString;


@end
