//
//  YDCashWithdrawViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDCashWithdrawViewController.h"

#import "YDUserRequest.h"
@interface YDCashWithdrawViewController () {
    CGFloat _space;
    CGFloat _height;
}

@property (nonatomic, strong) UITextField           *payAccountTextField;       //支付宝账号框
@property (nonatomic, strong) UITextField           *cashTextField;             //提现金额框
@property (nonatomic, strong) UILabel               *cashLabel;                 //提现金额标签
@property (nonatomic, strong) UIButton              *cashButton;                //提现按钮
@property (nonatomic, strong) UIView                *lineView;                  //横线


@end

@implementation YDCashWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUserUI];
    
}
//界面加载
- (void)initUserUI {
    _space = 10.0;
    _height = 50.0 * SCREEN_HEIGHT_SCALE;
    self.title = @"我要提现";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.payAccountTextField];
    [self.view addSubview:self.cashTextField];
    [self.view addSubview:self.cashLabel];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.cashButton];
    
    //监听所有的textFeild
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setChangeButtonColor) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- action
//改变按钮字体以及边框颜色
- (void)setChangeButtonColor{
    if (self.payAccountTextField.text.length > 0 && self.cashTextField.text.length > 0) {
        self.cashButton.backgroundColor = APP_MAIN_COLOR;
        self.cashButton.userInteractionEnabled = YES;
    } else {
        self.cashButton.backgroundColor = [UIColor lightGrayColor];
        self.cashButton.userInteractionEnabled = NO;
    }
}
- (void)onCashButton {
    YDLog(@"申请提现");
    
    NSString *card = self.payAccountTextField.text;
    NSString *price = self.cashTextField.text;
    [YDUserRequest moneyCashWithCard:card price:price comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"提现申请 提交成功");
        } else {
            
            YDLog(@"提现申请 提交失败 - %@",response.resultDesc);
        }
        
    }];
    
    
}

#pragma mark -- getter

- (UITextField *)payAccountTextField {
    if (!_payAccountTextField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(_space, 64, SCREEN_SIZE.width - 2 * _space, _height)];
        textField.placeholder = @"请输入提现账号";
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100 * SCREEN_WIDTH_SCALE, _height)];
        leftLabel.text = @"支付宝";
        textField.leftView = leftLabel;
        textField.leftViewMode = UITextFieldViewModeAlways;
        _payAccountTextField = textField;
    }
    return _payAccountTextField;
}

- (UILabel *)cashLabel {
    if (!_cashLabel) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.payAccountTextField.frame), 100, _height)];
        leftLabel.text = @"提现金额";
        _cashLabel = leftLabel;
    }
    return _cashLabel;
}

- (UITextField *)cashTextField {
    if (!_cashTextField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(_space, CGRectGetMaxY(self.cashLabel.frame), SCREEN_SIZE.width - 2 * _space, _height)];
        textField.placeholder = @"请输入提现金额";
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, _height)];
        leftLabel.text = @"¥";
        textField.leftView = leftLabel;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        _cashTextField = textField;
    }
    return _cashTextField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cashTextField.frame), SCREEN_SIZE.width, 1)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIButton *)cashButton {
    if (!_cashButton) {
        _cashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashButton.frame = CGRectMake(3 * _space, CGRectGetMaxY(self.lineView.frame) + _height, SCREEN_SIZE.width - 2 * 3 * _space, _height);
        [_cashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cashButton setTitle:@"申请提现" forState:UIControlStateNormal];
        _cashButton.backgroundColor = [UIColor lightGrayColor];
        _cashButton.layer.cornerRadius = 5;
        _cashButton.userInteractionEnabled = NO;
        [_cashButton addTarget:self action:@selector(onCashButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashButton;
}

@end
