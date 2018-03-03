//
//  YDUserModel.m
//  ClickToHelp
//
//  Created by Candy on 16/11/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserModel.h"

@implementation YDUserModel

+ (instancetype)shareUserModel {
    static YDUserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[YDUserModel alloc] init];
    });
    return userModel;
}

@end
