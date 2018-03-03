//
//  YDHomeRequest.m
//  ClickToHelp
//
//  Created by rimi on 16/11/5.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDHomeRequest.h"
#import "YDWishModel.h"
#import <MJExtension/MJExtension.h>

@implementation YDHomeRequest

//根据愿望类型获取
+ (void)getWishListWithWishType:(YDWishType)wishType pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler {
    [self getWishListWithWishType:wishType searchKeyword:nil isRecomand:NO isHot:NO userID:nil pageIndex:pageIndex comletionHandler:comletionHandler];
}
//获取推荐
+ (void)getWishListWithIsRecmand:(BOOL)isRecomand pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler{
    [self getWishListWithWishType:YDWishTypeNone searchKeyword:nil isRecomand:YES isHot:NO userID:nil pageIndex:pageIndex comletionHandler:comletionHandler];
}
//搜索愿望
+ (void)getWishListWithSearchKeyWord:(NSString *)KeyWord pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler{
    [self getWishListWithWishType:YDWishTypeNone searchKeyword:KeyWord isRecomand:NO isHot:NO userID:nil pageIndex:pageIndex comletionHandler:comletionHandler];
}
//获取全部愿望
+ (void)getAllWishListWithPageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler{
    [self getWishListWithWishType:YDWishTypeNone searchKeyword:nil isRecomand:NO isHot:NO userID:nil pageIndex:pageIndex comletionHandler:comletionHandler];
}
//热门愿望
+ (void)getHotWishListWithPageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler{
    [self getWishListWithWishType:YDWishTypeNone searchKeyword:nil isRecomand:NO isHot:YES userID:nil pageIndex:pageIndex comletionHandler:comletionHandler];
}
// 预热愿望
+(void)getWillHotWishListWithPageIndex:(NSInteger)pageIndex comlettionHandler:(RequestConpletion) comletionHandler{
    [self getWishListWithWishType:YDWishTypeWillHot searchKeyword:nil isRecomand:NO isHot:NO userID:nil pageIndex:pageIndex comletionHandler:comletionHandler];
}

+ (void)getWishListWithWishType:(YDWishType)wishType searchKeyword:(NSString *)keyword isRecomand:(BOOL)isRecomand isHot:(BOOL)isHot userID:(NSString *)userID pageIndex:(NSInteger)pageIndex comletionHandler:(RequestConpletion) comletionHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (wishType != YDWishTypeNone) {
        parameters[@"wish_type"] = @(wishType);
    }
    if (keyword != nil) {
        parameters[@"search"] = keyword;
    }
    if (isRecomand == YES) {
        parameters[@"is_tj"] = @1;
    }
    
    if (isHot) {
        parameters[@"is_hot"] = @1;
    }
    if (userID) {
        parameters[@"user_id"] = userID;
    }
    
    parameters[@"page"] = @(pageIndex);
    
    [self starGetRequest:WISH_LIST_URL parameters:parameters comletionHandler:^(YDResponse *response) {
        if (response.success) {
            //                [Array addObject:[YDWishModel mj_objectArrayWithKeyValuesArray:response.resultVaule]];
            NSArray *modelArray = [YDWishModel mj_objectArrayWithKeyValuesArray:response.resultVaule];
            response.resultVaule = modelArray;
        }
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
    
}

//今日返现
+(void)getCashBackTodayWithcomletionHandler:(RequestConpletion)comletionHandler{
    [self starPostRequest:CASH_BACK_TODAY_URL parameters:nil comletionHandler:^(YDResponse *response) {
        if (response.success) {
            NSArray *model = [NSArray mj_objectArrayWithKeyValuesArray:response.resultVaule];
            response.resultVaule = model;
        }
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

//往期返现
+(void)getPastCashbackWithcomletionHandler:(RequestConpletion)comletionHandler{
    [self starPostRequest:PAST_CASHBACK_URL parameters:nil comletionHandler:^(YDResponse *response) {
        if (response.success) {
            NSArray *model = [NSArray mj_objectArrayWithKeyValuesArray:response.resultVaule];
            response.resultVaule = model;
        }
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}

+ (void)getWishCommentsWithWishId:(NSString *)WishId comletionHandler:(RequestConpletion) comletionHandler{
    NSDictionary * paremeters = @{@"post_id":WishId};
    [self starGetRequest:WISH_COMMENTS_URL parameters:paremeters comletionHandler:^(YDResponse *response) {
        if (response.success) {
            NSArray *model = [NSArray mj_objectArrayWithKeyValuesArray:response.resultVaule];
            response.resultVaule = model;
        }
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
    
}

@end
