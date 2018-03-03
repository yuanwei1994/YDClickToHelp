//
//  YDUserModel.h
//  ClickToHelp
//
//  Created by Candy on 16/11/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDUserModel : NSObject

@property (nonatomic,copy) NSString * user_id;            //用户id
@property (nonatomic,copy) NSString * user_nicename;      //用户昵称
@property (nonatomic,copy) NSString * avatar;             //头像图片url
@property (nonatomic,copy) NSString * sex;                //性别
@property (nonatomic,copy) NSString * birthday;           //生日
@property (nonatomic,copy) NSString * signature;          //个性签名
@property (nonatomic,copy) NSString * last_login_time;    //最后登录时间
@property (nonatomic,copy) NSString * coin;               //金币（打赏的钱） // 余额
@property (nonatomic,copy) NSString * mobile ;            //联系方式
@property (nonatomic,copy) NSString * score;              //积分

//判断用户是否登录
@property (nonatomic,assign) BOOL    isLogin;            //用户是否登录
@property (nonatomic,copy) NSString *password;           //用户密码

+ (instancetype)shareUserModel;


@end
