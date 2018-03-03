//
//  YDUserTextFeild.m
//  ClickToHelp
//
//  Created by Candy on 16/11/6.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserTextFeild.h"

@implementation YDUserTextFeild

+ (UITextField *)setTextFeildWithFrame:(CGRect)frame leftImangeName:(NSString *)letfImageName dividerImageName:(NSString *)dividerImageName  placeholder:(NSString *)placeholder {
    UITextField *textFeild = [[UITextField alloc] initWithFrame:frame];
    textFeild.backgroundColor = [UIColor whiteColor];
    //文本框左边视图
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, CGRectGetHeight(textFeild.frame) - 10)];
    //图片
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftImageView.center = leftView.center;
    leftImageView.image = [UIImage imageNamed:letfImageName];
    //分割线
    UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)-10, CGRectGetHeight(leftView.frame)/4, 1, CGRectGetHeight(leftView.frame)/2)];
    dividerImageView.image = [UIImage imageNamed:dividerImageName];
    [leftView addSubview:leftImageView];
    [leftView addSubview:dividerImageView];
    [textFeild setLeftView:leftView];
    // 总是显示leftView
    textFeild.leftViewMode = UITextFieldViewModeAlways;
    textFeild.placeholder = placeholder;
    return textFeild;
}

@end
