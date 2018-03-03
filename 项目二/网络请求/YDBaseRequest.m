//
//  YDBaseRequest.m
//  ClickToHelp
//
//  Created by rimi on 16/11/2.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDBaseRequest.h"
#import "YDWishModel.h"
#define TOKEN_KEY @"token_key"


@implementation YDBaseRequest

#pragma mark -- Get
+ (void) starGetRequest:(NSString *)urlString parameters:(NSDictionary *)parameters comletionHandler:(RequestConpletion)comletionHandler{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    //如果有token存在，进行本次网络请求
    if (token) {
        NSString * handleUrlStr = [self handleURLString:urlString Token:token];
        [manager GET:handleUrlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self handleResponse:responseObject error:nil completionHandler:comletionHandler];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self handleResponse:nil error:error completionHandler:comletionHandler];
            
        }];
    }
    //不存在 ，则先请求token 请求token成功后再进行本次的网路请求，请求token失败直接调用回到block
    else{
        [self startTokenRequestComletionHandler:^(YDResponse *response) {
            if (response.success) {
                [self starGetRequest:urlString parameters:parameters comletionHandler:comletionHandler];
            }else{
                return comletionHandler(response);
            }
        }];
    }
    
}

#pragma mark -- Post
+ (void) starPostRequest:(NSString *)urlString parameters:(NSDictionary *)parameters comletionHandler:(RequestConpletion)comletionHandler{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    //如果有token存在，进行本次网络请求
    if (token) {
        NSString * handleUrlStr = [self handleURLString:urlString Token:token];
        [manager POST:handleUrlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self handleResponse:responseObject error:nil completionHandler:comletionHandler];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self handleResponse:nil error:error completionHandler:comletionHandler];
            
        }];
    }
    //不存在 ，则先请求token 请求token成功后再进行本次的网路请求，请求token失败直接调用回到block
    else{
        [self startTokenRequestComletionHandler:^(YDResponse *response) {
            if (response.success) {
                [self starGetRequest:urlString parameters:parameters comletionHandler:comletionHandler];
            }else{
                return comletionHandler(response);
            }
        }];
    }

    
}

#pragma mark -- 上传文件
//urlString         ->请求接口
//parameters        ->请求参数
//filePaths         ->要上传的文件的地址数组
//fileKeys          ->要上传文件对应的参数名 与 filePaths 对应
+ (void) uploadfiles:(NSString *)urlString parameters:(NSDictionary*)parameters filePaths:(NSArray *)filePaths fileKeys:(NSArray *)fileKeys comletionHandler:(RequestConpletion)comletionHandler{
    AFHTTPSessionManager * manager = [self sessionManager];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    if (token) {
        NSString * handleurlString = [self handleURLString:urlString Token:token];
        [manager POST:handleurlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i = 0; i<filePaths.count; i++) {
                NSURL *fileURL = [NSURL fileURLWithPath:filePaths[i]];
                [formData appendPartWithFileURL:fileURL name:fileKeys[i] error:nil];
            }
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponse:responseObject error:nil completionHandler:comletionHandler];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            [self handleResponse:nil error:error completionHandler:comletionHandler];
        }];
    } else {
        [self startTokenRequestComletionHandler:^(YDResponse *response) {
            if (response.success) {
                [self uploadfiles:urlString parameters:parameters filePaths:filePaths fileKeys:fileKeys comletionHandler:comletionHandler];
            }else{
                if (comletionHandler) {
                    comletionHandler(response);
                }
            }
        }];
    }
}

#pragma mark -- Private

+ (AFHTTPSessionManager * )sessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0;
    return manager;
}

//处理接口地址
+ (NSString *)handleURLString:(NSString*)urlString Token:(NSString*)token {
    return [NSString stringWithFormat:@"%@%@&token=%@",BASE_URL,urlString,token];
}

//获取Token
+(void)startTokenRequestComletionHandler:(RequestConpletion)comletionHandler {
    AFHTTPSessionManager * manager = [self sessionManager];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,TOKEN_URL];
    YDResponse * response = [[YDResponse alloc] init];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger resultCode = [responseObject[@"code"] integerValue];
        if (resultCode == 200) {
            NSString * token = responseObject[@"token"];
            
            //存储在本地
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            response.success = YES;
            response.resultVaule = token;
        }
        response.resultDesc = responseObject[@"referer"];
        
        if (comletionHandler) {
            comletionHandler(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response.resultDesc = error.localizedDescription;
        if (comletionHandler) {
            comletionHandler(response);
        }
    }];
}
//处理请求结果
+(void)handleResponse:(id)responsObjct error:(NSError*)error completionHandler:(RequestConpletion)completionHandler {
    YDResponse * response = [[YDResponse alloc] init];
    if (error) {
        //请求失败
        response.resultDesc = error.localizedDescription;
        if (error.code == NSURLErrorNotConnectedToInternet) {
            response.resultDesc = @"无网络连接";
        }else if (error.code == NSURLErrorTimedOut){
            response.resultDesc = @"网络连接超时";
        }
    }else{
        NSLog(@"responds = %@", responsObjct);
        //请求成功
        NSInteger resultCode = [responsObjct[@"code"] integerValue];
        if (resultCode == 200) {
            response.success = YES;
            //判断list是否为空
            if (responsObjct[@"list"] == nil && responsObjct[@"msg"] != nil) {
                response.resultVaule = responsObjct[@"msg"];
                response.resultDesc = @"获取数据成功";
            } else {
                response.resultVaule = responsObjct[@"list"];
                response.resultDesc = @"获取数据成功";
            }
            
        }
        else{
            NSString *message = responsObjct[@"msg"];
            if (message) {
                response.resultDesc = message;
            }else{
                response.resultDesc = @"获取数据失败";
            }
            if (resultCode == 4001) {
                //token 失效 将本地token清除
                response.resultDesc = @"获取数据失败";
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TOKEN_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
        }
    }
    
    if (completionHandler) {
        completionHandler(response);
    }
}

#pragma mark -- 验证码请求 ------------------------------以下全部为验证码请求专用---------------------------------------
+ (void) starGetVerifyCodeWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters comletionHandler:(RequestConpletion)comletionHandler{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    //如果有token存在，进行本次网络请求
    if (token) {
        NSString * handleUrlStr = [self handleURLString:urlString Token:token];
        [manager GET:handleUrlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self verifyHandleResponse:responseObject error:nil completionHandler:comletionHandler];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self verifyHandleResponse:nil error:error completionHandler:comletionHandler];
            
        }];
    }
    //不存在 ，则先请求token 请求token成功后再进行本次的网路请求，请求token失败直接调用回到block
    else{
        [self startTokenRequestComletionHandler:^(YDResponse *response) {
            if (response.success) {
                [self starGetRequest:urlString parameters:parameters comletionHandler:comletionHandler];
            }else{
                return comletionHandler(response);
            }
        }];
    }
    
}

#pragma mark - 验证码结果处理
//处理请求结果
+ (void)verifyHandleResponse:(id)responsObjct error:(NSError*)error completionHandler:(RequestConpletion)completionHandler {
    YDResponse * response = [[YDResponse alloc] init];
    if (error) {
        //请求失败
        response.resultDesc = error.localizedDescription;
        if (error.code == NSURLErrorNotConnectedToInternet) {
            response.resultDesc = @"无网络连接";
        }else if (error.code == NSURLErrorTimedOut){
            response.resultDesc = @"网络连接超时";
        }
    }else{
        //请求成功
        NSInteger resultCode = [responsObjct[@"code"] integerValue];
        if (resultCode == 200) {
            response.success = YES;
            response.resultVaule = responsObjct[@"yzm"];
            response.resultDesc = @"获取数据成功";
        }
        else{
            NSString *message = responsObjct[@"msg"];
            if (message) {
                response.resultDesc = message;
            }else{
                response.resultDesc = @"获取数据失败";
            }
            if (resultCode == 4001) {
                //token 失效 将本地token清除
                response.resultDesc = @"获取数据失败";
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TOKEN_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
        }
    }
    
    if (completionHandler) {
        completionHandler(response);
    }
}

@end
