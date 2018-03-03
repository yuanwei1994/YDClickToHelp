//
//  YDAdviceFeedbackViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDAdviceFeedbackViewController.h"

#import "YDUserRequest.h"

@interface YDAdviceFeedbackViewController () {
    CGFloat _space;
}
@property (nonatomic, strong) UITextView    *adviceTextView;    //建议填写框
@property (nonatomic, strong) UIView        *lineView;          //横线视图
@property (nonatomic, strong) UIButton      *sendButton;        //发送按钮
@property (nonatomic, strong) UILabel       *promptLable;       //提示语

@end

@implementation YDAdviceFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUserUI];
    
}
//界面加载
- (void)initUserUI {
    self.title = @"反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _space = 20.0;
    
    [self.view addSubview:self.adviceTextView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.sendButton];
    
    //监听所有的textView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPromptLableAlpha) name:UITextViewTextDidChangeNotification object:nil];
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
//设置提示语Label的透明度
- (void)setPromptLableAlpha {
    self.promptLable.alpha = self.adviceTextView.text.length > 0 ? 0 : 1;
}

//发送按钮
- (void)onSendButton {
    if (self.adviceTextView.text.length <= 0) {
        return;
    }
    [YDUserRequest sendAdviceWithSuggestion:self.adviceTextView.text comletionHandler:^(YDResponse *response) {
        if (response.success) {
            YDLog(@"发送成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            YDLog(@"发送失败 - %@",response.resultDesc);
        }
    }];
}

#pragma mark -- getter
- (UITextView *)adviceTextView {
    if (!_adviceTextView) {
        _adviceTextView = [[UITextView alloc] initWithFrame:CGRectMake(_space, 64 + 30, SCREEN_SIZE.width - 2 * _space, SCREEN_SIZE.height - 64 - 30 - 50 - 1)];
        [_adviceTextView setFont:[UIFont systemFontOfSize:16]];
//        _adviceTextView.text=NSLocalizedString(@"描述你的建议或问题, 被采纳会有小礼物送哦", nil);//提示语
        [_adviceTextView addSubview:self.promptLable];
    }
    return _adviceTextView;
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.adviceTextView.frame) - 10, 20)];
        _promptLable.text = @"描述你的建议或问题, 被采纳会有小礼物送哦";
        _promptLable.textColor = [UIColor lightGrayColor];
        _promptLable.textAlignment = NSTextAlignmentJustified;
        [_promptLable setFont:[UIFont systemFontOfSize:16]];
        
    }
    return _promptLable;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(_space / 2, CGRectGetMaxY(self.adviceTextView.frame), SCREEN_SIZE.width - _space, 1)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(3 * _space, CGRectGetMaxY(self.lineView.frame) + 5, SCREEN_SIZE.width - 2 * 3 * _space, 40);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.backgroundColor = APP_MAIN_COLOR;
        _sendButton.layer.cornerRadius = 3;
        [_sendButton addTarget:self action:@selector(onSendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


@end
