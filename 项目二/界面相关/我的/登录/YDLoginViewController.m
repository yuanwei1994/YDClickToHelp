//
//  YDLoginViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/5.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDLoginViewController.h"
#import "YDRegisterViewController.h"
#import "YDResetPasswordViewController.h"
#import "YDAlertViewController.h"


#import "YDConfig.h"
#import "YDUserTextFeild.h"
#import "YDUserRequest.h"
#import "YDUserModel.h"


@interface YDLoginViewController ()

@property (nonatomic, strong) UITextField *usernameTextFeild;
@property (nonatomic, strong) UITextField *passwordTextFeild;
@property (nonatomic, strong) UIButton    *loginButton;

@end

@implementation YDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserUI];
    
    self.usernameTextFeild.text = @"18311111111";
    self.passwordTextFeild.text = @"abcd1234";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//界面加载
- (void)initUserUI {
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    
    //导航栏右边注册按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(0, 0, 44, 44);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(onRegisterBarItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registBtn];
    
    //自定义返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-5, 0, 60, 20);
    [btn setImage:[UIImage imageNamed:@"个人中心-left"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBackItem) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.view addSubview:self.usernameTextFeild];
    [self.view addSubview:self.passwordTextFeild];

    
    //找回密码按钮
    UIButton *findPassBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_SIZE.width - 20 - 70, CGRectGetMaxY(self.passwordTextFeild.frame) + 10, 80, 40);
        [btn setTitle:@"找回密码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14*SCREEN_HEIGHT_SCALE];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onFindPassBtn) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    
    [self.view addSubview:findPassBtn];
    
    //登录按钮
    UIButton *loginBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, CGRectGetMaxY(findPassBtn.frame) + 10, SCREEN_SIZE.width - 40, 50 * SCREEN_HEIGHT_SCALE);
        [btn setTitle:@"登 录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = APP_MAIN_COLOR;
        [btn addTarget:self action:@selector(onLoginBtn) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    self.loginButton = loginBtn;
    [self.view addSubview:self.loginButton];
    
    
}

#pragma mark -- action
- (void)onRegisterBarItem{
    YDLog(@"注册中----");
    [self.navigationController pushViewController:[YDRegisterViewController new] animated:YES];

}

//返回按钮
- (void)onBackItem {
    [self.navigationController popViewControllerAnimated:YES];
}
//找回密码按钮
- (void)onFindPassBtn {
    YDLog(@"找回密码中----");
    [self.navigationController pushViewController:[YDResetPasswordViewController new] animated:YES];
}

- (void)onLoginBtn {
    NSString *username = self.usernameTextFeild.text;
    NSString *password = self.passwordTextFeild.text;
    
    if (username.length <= 0 || password.length <= 0) {
        YDLog(@"用户名/密码 不能为空");
        [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:@"用户名/密码 不能为空" inVC:self defaulthandlerAction:nil];
        return;
    }
    self.loginButton.userInteractionEnabled = NO;
    
    [YDUserRequest loginWithUsername:username password:password comletionHandler:^(YDResponse *response) {
        if (response.success) {
            self.loginButton.userInteractionEnabled = YES;
            YDLog(@"/////////////////////////////////////////-------- 登录成功 - %@",response.resultDesc);
            //登录成功以后将返回的用户信息赋值给用户单例
            YDUserModel *userModel = [YDUserModel shareUserModel];
            userModel.isLogin = YES;
            NSString *userID = response.resultVaule[@"id"];
            //在拿到用户id后进行用户详细信息的网络请求
            [YDUserRequest userInfoWithUid:userID comletionHandler:^(YDResponse *response) {
                if (response.success) {
                    NSDictionary *userInfoDic = response.resultVaule;
                    userModel.user_id = userInfoDic[@"id"];
                    userModel.user_nicename = userInfoDic[@"user_nicename"];
                    userModel.avatar = userInfoDic[@"avatar"];
                    userModel.mobile = userInfoDic[@"mobile"];
                    userModel.sex = userInfoDic[@"sex"];
                    userModel.birthday = userInfoDic[@"birthday"];
                    userModel.score = userInfoDic[@"score"];
                    userModel.coin = userInfoDic[@"coin"];
                    userModel.last_login_time = userInfoDic[@"last_login_time"];
                    userModel.signature = userInfoDic[@"signature"];

                    userModel.password = password;
                    
                    [YDAlertViewController showWithViewTitle:@"恭喜" Defaulthandlertitle:@"确定" message:@"登录成功" inVC:self  defaulthandlerAction:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                } else {
                    YDLog(@"/////////////////////////////////////////-------- 登录失败 - %@",response.resultDesc);
                    NSString *message = [NSString stringWithFormat:@"登录失败 - %@",response.resultDesc];
                    [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:message inVC:self defaulthandlerAction:nil];
                }
            }];
            
        } else {
            self.loginButton.userInteractionEnabled = YES;
            YDLog(@"/////////////////////////////////////////-------- 登录失败 - %@",response.resultDesc);
            NSString *message = [NSString stringWithFormat:@"登录失败 - %@",response.resultDesc];
            [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:message inVC:self defaulthandlerAction:nil];
        }
    }];
}

#pragma mark -- getter

- (UITextField *)usernameTextFeild {
    if (!_usernameTextFeild) {
        _usernameTextFeild = [YDUserTextFeild setTextFeildWithFrame:CGRectMake(0, 64 + 10, SCREEN_SIZE.width, 50 * SCREEN_HEIGHT_SCALE) leftImangeName:@"登录注册-手机" dividerImageName:@"登录注册-分割线" placeholder:@"请输入手机号"];
        _usernameTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _usernameTextFeild;
}

- (UITextField *)passwordTextFeild {
    if (!_passwordTextFeild) {
        _passwordTextFeild = [YDUserTextFeild setTextFeildWithFrame:CGRectMake(0, CGRectGetMaxY(self.usernameTextFeild.frame) + 1, SCREEN_SIZE.width, 50 * SCREEN_HEIGHT_SCALE) leftImangeName:@"登录注册-钥匙" dividerImageName:@"登录注册-分割线" placeholder:@"请输入密码"];
        _passwordTextFeild.secureTextEntry = YES;
    }
    
    return _passwordTextFeild;
}

@end
