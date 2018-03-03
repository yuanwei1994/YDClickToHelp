//
//  YDURL.h
//  ClickToHelp
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#ifndef YDURL_h
#define YDURL_h

#pragma mark -- 公共URL
// 服务器地址
#define BASE_URL                @"http://www.scxxhs.com/huzhu/index.php?"
// 获取token
#define TOKEN_URL               @"g=Appapi&m=index&a=getToken"
//图片请求专用
#define IMAGE_URL               @"http://www.scxxhs.com/huzhu"

#pragma mark -- 首页模块URL
// 愿望列表
#define WISH_LIST_URL           @"g=Appapi&m=wish&a=index"
//首页福包
#define HOME_FP_URL             @"g=Appapi&m=luckybag&a=home"
//今日福包动态
#define HOME_DYNAMIC_URL        @"g=Appapi&m=luckybag&a=today"
//今日返现
#define CASH_BACK_TODAY_URL     @"g=Appapi&m=luckybag&a=today_fx"
//往期返现
#define PAST_CASHBACK_URL       @"g=Appapi&m=luckybag&a=past"
// 打赏愿望
#define REWARD_WISH_URL         @"g=Appapi&m=reward&a=addreward"

#pragma mark -- User模块URL
//验证码
#define VERIFYCODE_URL          @"g=Appapi&m=user&a=send"
//注册
#define REGISTER_URL            @"g=Appapi&m=user&a=doregister"
// 登录
#define LOGIN_URL               @"g=Appapi&m=user&a=dologin"
//找回密码
#define RESET_PASSWORD_URL      @"g=Appapi&m=user&a=pwdback"
//退出登录
#define LOGINOUT_URL            @"g=Appapi&m=user&a=logout"
// 上传头像
#define UPLOAD_AVATAR_URL       @"g=Appapi&m=user&a=upload_avatar"

//用户信息详情
#define USER_INFO_URL           @"g=Appapi&m=user&a=info"
//获取愿望打赏列表
#define WISH_REWARD_URL         @"g=Appapi&m=reward&a=index"
//收藏愿望列表
#define WISH_FAVORITES_URL      @"g=Appapi&m=wish&a=favorites"
//个人中心-获取愿望次数
#define WISH_NUM_URL            @"g=Appapi&m=user&a=wish_num"
//钱包
#define MONEY_PACKAGE_URL       @"g=Appapi&m=user&a=money_package"
//提交反馈建议
#define ADVICE_FEEDBACK_URL     @"g=Appapi&m=user&a=add_suggestion"
//关于我们
#define ABOUT_ME_URL            @"g=Appapi&m=user&a=about"
//修改用户信息
#define MODIFY_USER_INFO_URL    @"g=Appapi&m=user&a=editinfo"
//用户提现申请
#define MONEY_CASH_URL          @"g=Appapi&m=user&a=tixian"
//愿望评论
#define WISH_COMMENTS_URL           @"g=Appapi&m=comment&a=wish_comments"




#endif /* YDURL_h */
