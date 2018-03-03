//
//  YDBaseRequest.h
//  ClickToHelp
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "YDResponse.h"
#import "YDURL.h"

typedef void(^RequestConpletion)(YDResponse * response);

@interface YDRequest : NSObject

@property(nonatomic,assign) BOOL success;
@property(nonatomic,strong) id data;
@property(nonatomic,copy) NSString *error;

@end

@interface YDBaseRequest : NSObject

+ (void) starGetRequest:(NSString *)urlString parameters:(NSDictionary *)parameters comletionHandler:(RequestConpletion)comletionHandler;

+ (void) starPostRequest:(NSString *)urlString parameters:(NSDictionary *)parameters comletionHandler:(RequestConpletion)comletionHandler;
/*
 urlString 请求接口
 parameters 请求参数
 filePaths 要上传的文件的地址数组
 filePaths 要上传的文件对应的参数名数组 与 filePaths一一对应
 comletionHandler 回调block
 */
+ (void) uploadfiles:(NSString *)urlString parameters:(NSDictionary*)parameters filePaths:(NSArray *)filePaths fileKeys:(NSArray *)fileKeys comletionHandler:(RequestConpletion)comletionHandler;


//+ (void) getWishList:(NSString *)urlString parameters:(NSDictionary *)parameters page:(NSInteger)page comletionHandler:(RequestConpletion)comletionHandler;

+ (void) starGetVerifyCodeWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters comletionHandler:(RequestConpletion)comletionHandler;

@end
