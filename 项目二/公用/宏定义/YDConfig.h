//
//  YDConfig.h
//  AHelp
//
//  Created by Candy on 16/11/4.
//  Copyright © 2016年 杨琴. All rights reserved.
//

#ifndef YDConfig_h
#define YDConfig_h

//屏幕适配相关
#define BASE_WIDTH 414
#define BASE_HEIGHT 736

#define SCREEN_BOUNDS            [UIScreen mainScreen].bounds
//屏幕尺寸
#define SCREEN_SIZE              [UIScreen mainScreen].bounds.size
//宽高 比例
#define SCREEN_WIDTH_SCALE       SCREEN_SIZE.width / BASE_WIDTH
#define SCREEN_HEIGHT_SCALE      SCREEN_SIZE.height / BASE_HEIGHT

//颜色
#define COLOR_RGB(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//主色调
#define APP_MAIN_COLOR           COLOR_RGB(70, 192, 182, 1)
//背景颜色
#define APP_BACKGROUND_COLOR     COLOR_RGB(237, 237, 237, 1)

//默认头像
#define APP_DEFAULT_HEADIMAGE    [UIImage imageNamed:@"个人中心-默认头像"]

//日志打印 ------------
//两个##的意思为 当参数个数为0的时候, 去掉前面的逗号
//__VA_ARGS__ 系统获取可变参数的 宏
#if DEBUG
#define YDLog(format, ...)       NSLog(format, ##__VA_ARGS__)
#else
#define YDLog(format, ...)
#endif

#endif /* Config_h */
