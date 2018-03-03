//
//  YDUserRequest.h
//  ClickToHelp
//
//  Created by Candy on 16/11/9.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDBaseRequest.h"
#import <Foundation/Foundation.h>


@interface YDUserRequest : NSObject


+ (void)registerWithMobile:(NSString *)mobile password:(NSString *)password tj_mobile:(NSString *)tj_mobile comletionHandler:(RequestConpletion)comletionHandler;

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password comletionHandler:(RequestConpletion)comletionHandler;

+ (void)verifyCodeWithMobile:(NSString *)mobile comletionHandler:(RequestConpletion)comletionHandler;

+ (void)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password comletionHandler:(RequestConpletion)comletionHandler;

+ (void)userInfoWithUid:(NSString *)uid comletionHandler:(RequestConpletion)comletionHandler;
//获取个人发布愿望
+ (void)getWishListWithWishType:(NSInteger)wishType userID:(NSString *)userID pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion)comletionHandler;
//获取个人收藏的愿望
+ (void)getWishCollectListWithComletionHandler:(RequestConpletion)comletionHandler;
//获取愿望打赏记录
+ (void)getRewardListWithUid:(NSString *)uid to_uid:(NSString *)to_uid wish_id:(NSString *)wish_id comletionHandler:(RequestConpletion)comletionHandler;
//获取愿望剩余次数
+ (void)getWishSurplusNumWithComletionHandler:(RequestConpletion)comletionHandler;
//获取用户钱包数据
+ (void)getMoneyPackageWithComletionHandler:(RequestConpletion)comletionHandler;
//发送用户建议反馈
+ (void)sendAdviceWithSuggestion:(NSString *)suggestion comletionHandler:(RequestConpletion)comletionHandler;
//关于我们网络请求
+ (void)getAboutMeWithComletionHandler:(RequestConpletion)comletionHandler;
//修改用户信息
+ (void)modifyUserInfoWithNickname:(NSString *)nickname password:(NSString *)password comletionHandler:(RequestConpletion)comletionHandler;
//用户提现申请    price 提现金额 card 提现账户
+ (void)moneyCashWithCard:(NSString *)card price:(NSString *)price comletionHandler:(RequestConpletion)comletionHandler;
//上传用户头像
+ (void)uploadAvatar:(NSString *)avatar filePath:(NSString *)filePath comletionHandler:(RequestConpletion)comletionHandler;
@end
