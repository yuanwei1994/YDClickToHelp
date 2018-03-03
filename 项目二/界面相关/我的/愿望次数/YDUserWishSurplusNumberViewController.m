//
//  YDUserWishSurplusNumberViewController.m
//  ClickToHelp
//
//  Created by Candy on 16/11/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "YDUserWishSurplusNumberViewController.h"

#import "YDConfig.h"
#import "YDUserRequest.h"


@interface YDUserWishSurplusNumberViewController () {
    CGFloat _spaceWidth;    //间隔
    CGFloat _spaceHeight;
}

@property (nonatomic, strong) UILabel       * numLabel;         //愿望剩余次数
@property (nonatomic, strong) UITextView    * ruleTextView;     //规则详情


@end

@implementation YDUserWishSurplusNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUserUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [YDUserRequest getWishSurplusNumWithComletionHandler:^(YDResponse *response) {
        if (response.success) {
            
            NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次",[NSString stringWithFormat:@"%@",response.resultVaule[@"num"]]]];
            [mutableAttrStr addAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:50]} range:NSMakeRange(0, mutableAttrStr.length - 1)];
            self.numLabel.attributedText = mutableAttrStr;
            self.ruleTextView.text = response.resultVaule[@"desc"];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//界面加载
- (void)initUserUI {
    self.view.backgroundColor = [UIColor whiteColor];
    _spaceWidth = 30.0;
    _spaceHeight = 64.0 + 40.0;
    //累计标签Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_spaceWidth, _spaceHeight, 80, 20)];
    label.text = @"我的累计";
    [self.view addSubview:label];
    //累计图标
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), _spaceHeight - 10, 40, 40)];
    imageView.image = [UIImage imageNamed:@"愿望次数-填写"];
    [self.view addSubview: imageView];
    //累计次数标签Label
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(label.frame) + 50, SCREEN_SIZE.width - 2 * _spaceWidth, 40)];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.numLabel];
    //横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(self.numLabel.frame) + 40, SCREEN_SIZE.width - 2 * _spaceWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    //愿望规则标签Label
    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(lineView.frame) + _spaceWidth, 200, 20)];
    ruleLabel.text = @"愿望规则介绍:";
    [self.view addSubview:ruleLabel];
    //详细规则
    self.ruleTextView = [[UITextView alloc] initWithFrame:CGRectMake(_spaceWidth, CGRectGetMaxY(ruleLabel.frame) + 20, SCREEN_SIZE.width - 2 * _spaceWidth, SCREEN_SIZE.height - CGRectGetMaxY(ruleLabel.frame) - _spaceWidth)];
    [self.ruleTextView setFont:[UIFont systemFontOfSize:15]];
    self.ruleTextView.userInteractionEnabled = NO;
    [self.view addSubview:self.ruleTextView];
    
}

@end

