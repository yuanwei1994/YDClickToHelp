//
//  YDHomeRequest.h
//  ClickToHelp
//
//  Created by rimi on 16/11/5.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDBaseRequest.h"
typedef NS_ENUM(NSInteger, YDWishType) {
    YDWishTypeNone = 0,
    YDWishTypePublish = 1, // 发布愿望
    YDWishTypeWillHot = 2  // 预热
};

@interface YDHomeRequest : YDBaseRequest
//获取推荐
+ (void)getWishListWithIsRecmand:(BOOL)isRecomand pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler;
//搜索愿望
+ (void)getWishListWithSearchKeyWord:(NSString *)KeyWord pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler;
//根据愿望类型获取
+ (void)getWishListWithWishType:(YDWishType)wishType pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler;
//全部愿望
+ (void)getAllWishListWithPageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler;
//热门愿望
+ (void)getHotWishListWithPageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler;
//预热愿望
+(void)getWillHotWishListWithPageIndex:(NSInteger)pageIndex comlettionHandler:(RequestConpletion) comletionHandler;
//今日返现
+(void)getCashBackTodayWithcomletionHandler:(RequestConpletion)comletionHandler;
//往期返现
+(void)getPastCashbackWithcomletionHandler:(RequestConpletion)comletionHandler;

+ (void)getWishListWithWishType:(YDWishType)wishType searchKeyword:(NSString *)keyword isRecomand:(BOOL)isRecomand isHot:(BOOL)isHot userID:(NSString *)userID pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler;
//愿望评论
+ (void)getWishCommentsWithWishId:(NSString *)WishId comletionHandler:(RequestConpletion) comletionHandler;
@end
