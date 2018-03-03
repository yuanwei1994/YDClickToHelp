//
//  YDAboutMeViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/20.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDAboutMeViewController.h"

#import "YDUserRequest.h"

@interface YDAboutMeViewController ()

@property (nonatomic, strong) UIView       * lineView;
@property (nonatomic, strong) UIWebView    * webView;

@end

@implementation YDAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserUI];
    
}
//界面加载
- (void)initUserUI {
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.webView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    
    [YDUserRequest getAboutMeWithComletionHandler:^(YDResponse *response) {
        if (response.success) {
            [self.webView loadHTMLString:response.resultVaule[@"content"] baseURL:nil];
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:self.webView.frame];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = response.resultDesc;
            [self.webView addSubview:label];
        }
    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- getter
- (UIView *)lineView {
    if (!_lineView) {
        CGFloat _lineSpace = 100.0 * SCREEN_WIDTH_SCALE;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(_lineSpace, 64 + 30, SCREEN_SIZE.width - 2 * _lineSpace, 1)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame) + 20, SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 60 - 10)];
        self.webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
@end
