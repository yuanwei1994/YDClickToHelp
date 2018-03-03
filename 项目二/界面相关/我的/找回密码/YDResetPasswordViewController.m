//
//  YDResetPasswordViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/10.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDResetPasswordViewController.h"
#import "YDAlertViewController.h"

#import "YDConfig.h"
#import "YDUserTextFeild.h"
#import "YDUserRequest.h"

@interface YDResetPasswordViewController ()

@property (nonatomic, strong) UITextField *usernameTextFeild;   //用户名框
@property (nonatomic, strong) UITextField *passwordTextFeild;   //密码框
@property (nonatomic, strong) UITextField *verifyCodeTextFeild; //验证码框
@property (nonatomic, strong) UIButton    *verifyCodeBtn;       //验证码按钮
@property (nonatomic, strong) UIButton    *resetPasswordBtn;    //找回密码按钮

@end

@implementation YDResetPasswordViewController {
    NSString *_verifyCode;
    CGFloat _height;
    NSTimer *_timer;
    CGFloat _countdown;     // 倒计时时长
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _height = 50 * SCREEN_HEIGHT_SCALE;
    _countdown = 60.0;
    
    [self initUserUI];
    
}

//界面初始化
- (void)initUserUI {
    
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    self.title = @"找回密码";
    [self.view addSubview:self.usernameTextFeild];
    [self.view addSubview:self.passwordTextFeild];
    [self.view addSubview:self.verifyCodeTextFeild];
    [self.view addSubview:self.verifyCodeBtn];
    [self.view addSubview:self.resetPasswordBtn];
    
    //监听所有的textFeild
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setChangeButtonColor) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark -- action

- (void)onResetPasswordBtn {
    
    NSString *mobile = self.usernameTextFeild.text;
    NSString *verifyCode = self.verifyCodeTextFeild.text;
    NSString *password = self.passwordTextFeild.text;
    if (mobile.length <= 0 || password.length <= 0 || verifyCode.length <= 0) {
        [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:@"用户名/密码/验证码 不能为空" inVC:self defaulthandlerAction:nil];
        YDLog(@"用户名/密码/验证码 不能为空");
        return;
    }
    
    if (![verifyCode isEqualToString:_verifyCode]) {
        YDLog(@"验证码错误");
        [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:@"验证码错误" inVC:self defaulthandlerAction:nil];
        return;
    }
    
    [YDUserRequest resetPasswordWithMobile:mobile password:password comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"找回密码成功!");
            [YDAlertViewController showWithViewTitle:@"恭喜" Defaulthandlertitle:@"确定" message:@"修改密码成功!" inVC:self defaulthandlerAction:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else {
            YDLog(@"找回密码失败! - %@",response.resultDesc);
            NSString *message = [NSString stringWithFormat:@"找回密码失败! - %@",response.resultDesc];
            [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:message inVC:self defaulthandlerAction:nil];
        }
    }];
}

#pragma mark -- VerifyCode --- Begining

- (void)onVerifyCodeBtn {
    YDLog(@"获取验证码中...");
    NSString *mobile = self.usernameTextFeild.text;
    if (mobile.length <= 0) {
        YDLog(@"手机号不能为空");
        [YDAlertViewController showWithViewTitle:@"警告" Defaulthandlertitle:@"确定" message:@"手机号不能为空" inVC:self defaulthandlerAction:nil];
        return;
    }
    
    //关闭用户交互
    self.verifyCodeBtn.userInteractionEnabled = NO;
    //每秒执行一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setCountdown) userInfo:nil repeats:YES];
    
    [YDUserRequest verifyCodeWithMobile:mobile comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"验证码为 - %@", response.resultVaule);
            _verifyCode = [NSString stringWithFormat:@"%@",response.resultVaule];
        } else {
            YDLog(@"验证码获取失败 - %@",response.resultDesc);
        }
    }];
}

//移除计时器
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

//倒计时
- (void)setCountdown {
    //开始倒计时
    [self setBeginingCountdown];
    if (_countdown <= 0) {
        [self stopTimer];
        //结束倒计时
        [self setDidCountdown];
        return;
    }
}

//验证码倒计时开始后
- (void)setBeginingCountdown {
    _countdown --;
    //把按钮颜色重置为最初的灰色
    [self setNormalColor];
    //将倒计时赋值给按钮的title
    [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%.f S",_countdown] forState:UIControlStateNormal];
}

//验证码倒计时结束后
- (void)setDidCountdown {
    //重置倒计时 时间
    _countdown = 60.0;
    //移除计时器
    [self stopTimer];
    //改变按钮颜色
    [self setChangeButtonColor];
    //开启用户交互
    self.verifyCodeBtn.userInteractionEnabled = YES;
    //重置按钮title
    [_verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

//改变按钮字体以及边框颜色
- (void)setChangeButtonColor{
    if (self.usernameTextFeild.text.length > 0) {
        [self setChangeColor];
    } else {
        [self setNormalColor];
    }
    
    if (self.usernameTextFeild.text.length > 0 && self.passwordTextFeild.text.length > 0 && self.verifyCodeTextFeild.text.length > 0) {
        self.resetPasswordBtn.backgroundColor = APP_MAIN_COLOR;
    } else {
        self.resetPasswordBtn.backgroundColor = COLOR_RGB(154, 154, 154, 1);
    }
}

- (void)setChangeColor {
    self.verifyCodeBtn.layer.borderColor = APP_MAIN_COLOR.CGColor;
    [self.verifyCodeBtn setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
}

- (void)setNormalColor {
    self.verifyCodeBtn.layer.borderColor = COLOR_RGB(154, 154, 154, 1).CGColor;
    [self.verifyCodeBtn setTitleColor:COLOR_RGB(154, 154, 154, 1) forState:UIControlStateNormal];
}

#pragma mark -- VerifyCode --- End


#pragma mark -- getter

- (UITextField *)usernameTextFeild {
    if (!_usernameTextFeild) {
        _usernameTextFeild = [YDUserTextFeild setTextFeildWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, _height) leftImangeName:@"登录注册-手机" dividerImageName:@"登录注册-分割线" placeholder:@"请输入手机号"];
        _usernameTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _usernameTextFeild;
}

- (UITextField *)passwordTextFeild {
    if (!_passwordTextFeild) {
        _passwordTextFeild = [YDUserTextFeild setTextFeildWithFrame:CGRectMake(0, CGRectGetMaxY(self.usernameTextFeild.frame) + 1, SCREEN_SIZE.width, _height) leftImangeName:@"登录注册-钥匙" dividerImageName:@"登录注册-分割线" placeholder:@"请输入密码"];
        _passwordTextFeild.secureTextEntry = YES;
    }
    return _passwordTextFeild;
}

- (UITextField *)verifyCodeTextFeild {
    if (!_verifyCodeTextFeild) {
        _verifyCodeTextFeild = [YDUserTextFeild setTextFeildWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordTextFeild.frame) + 1, SCREEN_SIZE.width, _height) leftImangeName:@"登录注册-验证码" dividerImageName:@"登录注册-分割线" placeholder:@"请输入验证码"];
        _verifyCodeTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return _verifyCodeTextFeild;
}

- (UIButton *)verifyCodeBtn {
    if (!_verifyCodeBtn) {
        _verifyCodeBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_SIZE.width - 20 - 100, 70, 100, CGRectGetHeight(self.usernameTextFeild.frame) - 10);
            [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_RGB(154, 154, 154, 1) forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = COLOR_RGB(154, 154, 154, 1).CGColor;
            btn.layer.borderWidth = 1;
            [btn addTarget:self action:@selector(onVerifyCodeBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _verifyCodeBtn;
}

- (UIButton *)resetPasswordBtn {
    if (!_resetPasswordBtn) {
        _resetPasswordBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20, CGRectGetMaxY(self.verifyCodeTextFeild.frame) + 10, SCREEN_SIZE.width - 40, _height);
            [btn setTitle:@"找回密码" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.backgroundColor = COLOR_RGB(154, 154, 154, 1);
            [btn addTarget:self action:@selector(onResetPasswordBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _resetPasswordBtn;
}


@end
