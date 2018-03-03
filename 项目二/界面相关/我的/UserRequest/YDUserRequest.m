//
//  YDUserRequest.m
//  ClickToHelp
//
//  Created by Candy on 16/11/9.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserRequest.h"
#import "YDHomeRequest.h"
#import "YDURL.h"
#import "YDConfig.h"
#import <MJExtension/MJExtension.h>
#import "YDWishModel.h"
#import "YDRewardModel.h"
#import "YDUserModel.h"


@implementation YDUserRequest

#pragma mark -- 注册请求
+ (void)registerWithMobile:(NSString *)mobile password:(NSString *)password tj_mobile:(NSString *)tj_mobile comletionHandler:(RequestConpletion)comletionHandler {
    NSDictionary *parameters = @{@"mobile":mobile, @"password":password, @"tj_mobile":tj_mobile};
    [YDBaseRequest starPostRequest:REGISTER_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 登录请求
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password comletionHandler:(RequestConpletion)comletionHandler {
    
    NSDictionary *parameters = @{@"username":username, @"password":password};
    [YDBaseRequest starPostRequest:LOGIN_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
    
}

#pragma mark -- 验证码请求
+ (void)verifyCodeWithMobile:(NSString *)mobile comletionHandler:(RequestConpletion)comletionHandler {

    [YDBaseRequest starGetVerifyCodeWithUrl:VERIFYCODE_URL parameters:@{@"mobile":mobile} comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 找回密码请求

+ (void)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password comletionHandler:(RequestConpletion)comletionHandler {
    NSDictionary *parameters = @{@"mobile":mobile, @"user_pass":password};
    [YDBaseRequest starPostRequest:RESET_PASSWORD_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 获取用户详情
+ (void)userInfoWithUid:(NSString *)uid comletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starGetRequest:USER_INFO_URL parameters:@{@"uid":uid} comletionHandler:^(YDResponse *response) {
//        //登录成功以后将返回的用户信息赋值给用户单例
//        YDUserModel *userModel = [YDUserModel shareUserModel];
//        if (response.success) {
//            NSDictionary *userInfoDic = response.resultVaule;
//            userModel.isLogin = YES;
//            userModel.user_id = userInfoDic[@"id"];
//            userModel.user_nicename = userInfoDic[@"user_nicename"];
//            userModel.avatar = userInfoDic[@"avatar"];
//            userModel.mobile = userInfoDic[@"mobile"];
//            userModel.sex = userInfoDic[@"sex"];
//            userModel.birthday = userInfoDic[@"birthday"];
//            userModel.score = userInfoDic[@"score"];
//            userModel.coin = userInfoDic[@"coin"];
//            userModel.last_login_time = userInfoDic[@"last_login_time"];
//            userModel.signature = userInfoDic[@"signature"];
//            response.resultVaule = userModel;
//        }
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
    
}

#pragma mark -- 获取个人发布愿望
+ (void)getWishListWithWishType:(NSInteger)wishType userID:(NSString *)userID pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler {
    [YDHomeRequest getWishListWithWishType:wishType searchKeyword:nil isRecomand:NO isHot:NO userID:userID pageIndex:pageIndex comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 获取个人收藏愿望
+ (void)getWishCollectListWithComletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starPostRequest:WISH_FAVORITES_URL parameters:nil comletionHandler:^(YDResponse *response) {
        if (response.success) {
            NSArray *modelArray = [YDWishModel mj_objectArrayWithKeyValuesArray:response.resultVaule];
            response.resultVaule = modelArray;
        }
        
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 获取愿望打赏记录
+ (void)getRewardListWithUid:(NSString *)uid to_uid:(NSString *)to_uid wish_id:(NSString *)wish_id comletionHandler:(RequestConpletion)comletionHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (uid) {
        parameters[@"uid"] = uid;
    }
    if (to_uid) {
        parameters[@"to_uid"] = to_uid;
    }
    if (wish_id) {
        parameters[@"wish_id"] = wish_id;
    }
    
    [YDBaseRequest starGetRequest:WISH_REWARD_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (response.success) {
            NSArray *modelArray =  [YDRewardModel mj_objectArrayWithKeyValuesArray:response.resultVaule];
            response.resultVaule = modelArray;
//            NSMutableArray *modelArray = [NSMutableArray array];
//            YDRewardModel *rewardModel = [[YDRewardModel alloc] init];
//            for (int i = 0; i < array.count; i ++) {
//                rewardModel.reward_id = array[i][@"id"];
//                rewardModel.price = array[i][@"price"];
//                rewardModel.wish_id = array[i][@"wish_id"];
//                rewardModel.uid = array[i][@"uid"];
//                rewardModel.to_uid = array[i][@"to_uid"];
//                rewardModel.add_time = array[i][@"add_time"];
//                rewardModel.avatar = array[i][@"avatar"];
//                rewardModel.user_nicename = array[i][@"user_nicename"];
//                rewardModel.to_avatar = array[i][@"to_avatar"];
//                rewardModel.to_user_nicename = array[i][@"to_user_nicename"];
//                rewardModel.wish_title = array[i][@"wish_title"];
//                [modelArray addObject:rewardModel];
//            }
        }
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 获取愿望剩余次数
+ (void)getWishSurplusNumWithComletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starGetRequest:WISH_NUM_URL parameters:nil comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 获取用户钱包数据
+ (void)getMoneyPackageWithComletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starGetRequest:MONEY_PACKAGE_URL parameters:nil comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 发送用户建议反馈
+ (void)sendAdviceWithSuggestion:(NSString *)suggestion comletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starPostRequest:ADVICE_FEEDBACK_URL parameters:@{@"suggestion":suggestion} comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 关于我们网络请求
+ (void)getAboutMeWithComletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starGetRequest:ABOUT_ME_URL parameters:nil comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 修改用户信息 user_nicename 用户昵称 user_pass  密码
+ (void)modifyUserInfoWithNickname:(NSString *)nickname password:(NSString *)password comletionHandler:(RequestConpletion)comletionHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (nickname) {
        parameters[@"user_nicename"] = nickname;
    }
    if (password) {
        parameters[@"user_pass"] = password;
    }
    [YDBaseRequest starPostRequest:MODIFY_USER_INFO_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

#pragma mark -- 用户提现申请    price 提现金额 card 提现账户
+ (void)moneyCashWithCard:(NSString *)card price:(NSString *)price comletionHandler:(RequestConpletion)comletionHandler {
    [YDBaseRequest starPostRequest:MONEY_CASH_URL parameters:@{@"card":card, @"price":price} comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}
#pragma mark -- 上传用户头像
+ (void)uploadAvatar:(NSString *)avatar filePath:(NSString *)filePath comletionHandler:(RequestConpletion)comletionHandler {
    
    [YDBaseRequest uploadfiles:UPLOAD_AVATAR_URL parameters:nil filePaths:@[filePath] fileKeys:@[@"avatar"] comletionHandler:^(YDResponse *response) {
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
    
    
}

@end
